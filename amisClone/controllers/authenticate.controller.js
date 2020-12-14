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

module.exports.getAuthenticate = (req,res)=>{
    if(!req.signedCookies.login){
        res.render("login");
    }else{
        db.all("SELECT * FROM `cookies` WHERE cookie = ?",req.signedCookies.login,(err,rs)=>{
            if(err) throw err;
            if(rs.length>0){
                res.redirect("/dashboard");
            }else{
                res.render("login");
            }
        });
    }
    
};

module.exports.postAuthenticate = (req,res)=>{
    var username = req.body.username;
    var password = req.body.password;
    var sql = "SELECT * FROM `user` WHERE accountName = ? AND password = ?";
    conn.query(sql,[md5(username),md5(password)],(err,rs)=>{
        if(err){throw err}else{
            //check user is local-user or ldap-user
            if(rs.length>0){
                checkCookie(res,rs[0].userId);
                res.send('true');
                //done
            }else{
                ad.authenticate(username+domain, password, function(err, auth) {
                    if (auth) {
                        var sql = "SELECT * FROM `user` WHERE accountName = ?";
                        conn.query(sql,[username],(err,rs)=>{
                            if(err) throw err;
                            if(rs.length>0){
                                checkCookie(res,rs[0].userId);
                                res.send("true");
                            }else{
                                var sql = "INSERT INTO `user`(accountName) VALUES(?)";
                                conn.query(sql,[username],(err,rs)=>{
                                    if(err) throw err;
                                    var sql = "SELECT userId FROM `user` WHERE accountName = ?";
                                    conn.query(sql,[username],(err,rs)=>{
                                        if(err) throw err;
                                        checkCookie(res,rs[0].userId);
                                    });
                                });
                                res.send("true");
                            }
                        });
                    }
                    else {
                        res.send("Invalid Data");
                    }
                });
            }
        }
    });

}

function cookieCreater(res,token){
    res.cookie("login",token,{
        httpOnly:true,
        signed:true,
        maxAge:4*1000*60*60
    });
}

function update(userId,cookie){
    db.run("UPDATE `cookies` SET cookie = ? WHERE userId = ?",[cookie,userId],(err,rs)=>{
        if(err) throw err;
    });
}

function insert(userId,cookie){
    db.run("INSERT INTO `cookies`(userId,cookie) VALUES(?,?)",userId,cookie,(err,rs)=>{
        if(err) throw err;
    })
}

function checkCookie(res,userId){
    //create JWT
    var token = jwt.sign({
        exp: Math.floor(Date.now() / 1000) + (60 * 60 *4),
        data: userId
    }, privateKey);
    //sending to user and storing inside cookie
    cookieCreater(res,token);
    db.all("SELECT * FROM `cookies` WHERE userId = ?",userId,(err,rs)=>{
        if(err) throw err;
        if(rs.length > 0){update(userId,token);}else{insert(userId,token);}
    });
}