//libraries
var md5 = require("md5");
var jwt = require("jsonwebtoken");
var fs = require("fs");
var ActiveDirectory = require('activedirectory');
//files
var conn = require("../database/main.database");
var db = require("../database/sqlite.database");

//private key for JWT
var privateKey = "privateKey"//change later
//Active directory config
var domain = "@htc-itc.local";
var config = { url: 'ldap://192.168.100.10',
               baseDN: 'dc=htc-itc,dc=local',
               username: 'duynt@htc-itc.local',
               password: 'Meg@troll123' }

var ad = new ActiveDirectory(config);

function update(userId,cookie){
    db.run("UPDATE `cookies` SET cookie = ? WHERE userId = ?",[cookie,userId],(err,rs)=>{
        if(err) throw err;
    });
};

function insert(userId,cookie){
    db.run("INSERT INTO `cookies`(userId,cookie) VALUES(?,?)",userId,cookie,(err,rs)=>{
        if(err) throw err;
    })
};

function func_roleForNewUser(userId){
    var sql = "CALL Proc_InsertNewUserRole(?)";
    conn.query(sql,[userId],(err,rs)=>{
        if(err) throw err;
    });
};

function func_token(res,userId,role){
    //create JWT
    var token = jwt.sign({
        exp: Math.floor(Date.now() / 1000) + (60 * 60 *4),//lasting 4 hours
        data: {
            "userId" : userId,
            "role" : role
        }
    }, privateKey);
    //store inside cookie
    res.cookie("auth_token",token,{
        httpOnly:true,
        signed:true,
        maxAge:4*1000*60*60// lasting for 4 hours
    });
    //save cookie to database for checking
    db.all("SELECT * FROM `cookies` WHERE userId = ?",userId,(err,rs)=>{
        if(err) throw err;
        if(rs.length > 0){update(userId,token);}else{insert(userId,token);}
    });
    //bye server bru!!!, im ready to go to client-side
    res.send("true");
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
        if(err){throw err}else{
            rs = rs[0];
            //check user is local-user or ldap-user
            if(rs.length>0){
                var userId = rs[0].userId;
                var sql = "CALL Proc_SelectRoleUser(?)";
                conn.query(sql,[userId],(err,rs)=>{
                    if(err) throw err;
                    var role = rs[0][0].userRoleName;
                    func_token(res,userId,role);
                });
            }else{
                var name = username+domain;
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
                                    if(err) throw err;
                                    var role = rs[0][0].userRoleName;
                                    func_token(res,userId,role);
                                });
                            }else{
                                var sql = "CALL Proc_InsertUserFromLDAP(?)";
                                conn.query(sql,[username],(err,rs)=>{
                                    if(err) throw err;
                                    var sql = "CALL Proc_SelectUserInUser(?)";
                                    conn.query(sql,[username],(err,rs)=>{
                                        if(err) throw err;
                                        var userId = rs[0][0].userId;
                                        func_roleForNewUser(userId);
                                        var sql = "CALL Proc_SelectRoleUser(?)";
                                        conn.query(sql,[userId],(err,rs)=>{
                                            if(err) throw err;
                                            var role = rs[0][0].userRoleName;
                                            func_token(res,userId,role);
                                        });
                                    });
                                });
                            }
                        });
                    }else {res.send("Wrong Username or Password");}
                });
            }
        }
    });
};