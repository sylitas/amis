//libraries
var md5 = require("md5");
var jwt = require("jsonwebtoken");
var fs = require("fs");
var ActiveDirectory = require('activedirectory');
var CryptoJS = require("crypto-js");
//files
var conn = require("../database/main.database");
var db = require("../database/sqlite.database");

//private key for JWT
var privateKey = process.env.KEY;
var key = process.env.KEY;
//Active directory config
const domain = process.env.URL_DOMAIN;

function get_ad(callback){
    db.all("SELECT * FROM `ldap` WHERE id = 1",(err,rs)=>{
        if(rs.length > 0){
            var ip = rs[0].ip;
            var baseDN = rs[0].baseDN;
            var username = rs[0].username;
            var cipher_password = rs[0].password;
            var decrypt_password  = CryptoJS.AES.decrypt(cipher_password, key);
            var password = decrypt_password.toString(CryptoJS.enc.Utf8);
            var config = { 
                url     : ip,
                baseDN  : baseDN,
                username: username,
                password: password
            }
            console.log(config);
            var ad = new ActiveDirectory(config);
            callback(ad);
        }else{
            //create connection first (admin job)
            return;
        }
    });
}

module.exports.getAuthenticate = (req,res)=>{
    if(req.signedCookies.auth_token){
        db.all("SELECT * FROM `cookies` WHERE cookie = ?",req.signedCookies.auth_token,(err,rs)=>{
            if(err) throw err;
            if(rs.length>0){res.redirect('/dashboard');}
        });
    }else{res.render("login");}
};
module.exports.postAuthenticate = (req,res)=>{
    var username = req.body.username;
    var password = req.body.password;
    var sql = "CALL Proc_SelectAccountForLogin(?,?)";
    conn.query(sql,[username,md5(password)],(err,rs)=>{
        if(err){throw err}
        rs = rs[0];
        //check user is local-user or ldap-user
        if(rs.length>0){
            var userId = rs[0].userId;
            var sql = "CALL Proc_SelectRoleUser(?)";
            conn.query(sql,[userId],(err,rs)=>{
                if(err) throw err;
                var role = rs[0][0].userRoleName;
                var roleId = rs[0][0].userRoleId;
                func_token(res,userId,role,roleId);
            });
        }else{
            get_ad((ad)=>{
                if(username.includes(domain)){
                    var name = username ;
                }else{
                    var name = username + domain;
                }
                ad.authenticate(name, password, function(err, auth) {
                    if (auth) {
                        var sql = "CALL Proc_SelectUserInUser(?)";
                        conn.query(sql,[username],(err,rs)=>{
                            if(err) throw err;
                            rs = rs[0];
                            if(rs.length>0){
                                var userId = rs[0].userId;
                                var sql = "CALL Proc_SelectRoleUser(?)";
                                conn.query(sql,[userId],(err,rs)=>{
                                    if(rs[0].length>0){
                                        if(err) throw err;
                                        var role = rs[0][0].userRoleName;
                                        var roleId = rs[0][0].userRoleId;
                                        func_token(res,userId,role,roleId);
                                    }else{res.send("Ask admin for granting permission for this account!");}
                                });
                            }else{res.send("Sync first!");}
                        });
                    }else{
                        res.send("Wrong Username or Password");
                    }
                });
            })
        }
    });
};
function update(userId,cookie){
    db.run("UPDATE `cookies` SET cookie = ? WHERE userId = ?",[cookie,userId],(err,rs)=>{
        if(err) throw err;
    });
};
function insert(userId,cookie){
    db.run("INSERT INTO `cookies`(userId,cookie) VALUES(?,?)",[userId,cookie],(err,rs)=>{
        if(err) throw err;
    })
};
function func_token(res,userId,role,roleId){
    //create JWT
    var exp = Math.floor(Date.now() / 1000) + (60 * 60 *4);//lasting 4 hours
    var token = jwt.sign({
        exp: exp,
        data: {
            "userId" : userId,
            "role" : role,
            "roleId":roleId
        }
    }, privateKey);
    //store inside cookie
    res.cookie("auth_token",token,{
        httpOnly:true,
        signed:true,
        maxAge:4*1000*60*60// lasting for 4 hours
    });
    setTimeout(() => {
        var sql = "DELETE FROM `cookies` WHERE userId = ?";
        db.run(sql,userId, function(err) {
            if(err) throw err;
        });
    }, exp);
    //save cookie to database for checking
    db.all("SELECT * FROM `cookies` WHERE userId = ?",userId,(err,rs)=>{
        if(err) throw err;
        if(rs.length > 0){update(userId,token);}else{insert(userId,token);}
    });
    //bye server bru!!!, im ready to go to client-side
    res.send("true");
};