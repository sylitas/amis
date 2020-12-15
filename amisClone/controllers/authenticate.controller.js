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

function cookieCreater(res,token){
    res.cookie("login",token,{
        httpOnly:true,
        signed:true,
        maxAge:4*1000*60*60
    });
}

function cookieCreaterAdmin(res,token){
    res.cookie("admin",token,{
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

function checkCookieAdmin(res,userId){
    //create JWT
    var token = jwt.sign({
        exp: Math.floor(Date.now() / 1000) + (60 * 60 *4),
        data: userId
    }, privateKey);
    //sending to user and storing inside cookie
    cookieCreaterAdmin(res,token);
    db.all("SELECT * FROM `cookies` WHERE userId = ?",userId,(err,rs)=>{
        if(err) throw err;
        if(rs.length > 0){update(userId,token);}else{insert(userId,token);}
    });
}

function checkRole(res,userId,role){
    if(role == "administrator"){
        checkCookieAdmin(res,userId)
        res.send('trueA');
    }else{
        checkCookie(res,userId);
        res.send('trueU');
    }
}

function setRole(userId){
    var sql = "CALL Proc_InsertNewUserRole(?)";
    conn.query(sql,[userId],(err,rs)=>{
        if(err) throw err;
    });
}

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
    var sql = "CALL Proc_SelectAccountForLogin(?,?)";
    conn.query(sql,[md5(username),md5(password)],(err,rss)=>{
        if(err){throw err}else{
            rss = rss[0];
            //check user is local-user or ldap-user
            if(rss.length>0){
                var sql = "CALL Proc_SelectRoleUser(?)";
                conn.query(sql,[rss[0].userId],(err,rs)=>{
                    if(err) throw err;
                    checkRole(res,rss[0].userId,rs[0][0].userRoleName);
                });
            }else{
                ad.authenticate(username+domain, password, function(err, auth) {
                    if (auth) {
                        var sql = "CALL Proc_SelectUserInUser(?)";
                        conn.query(sql,[username],(err,rss)=>{
                            if(err) throw err;
                            rss = rss[0];
                            if(rss.length>0){
                                var sql = "CALL Proc_SelectRoleUser(?)";
                                conn.query(sql,[rs[0].userId],(err,rs)=>{
                                    if(err) throw err;
                                    checkRole(res,rss[0].userId,rs[0][0].userRoleName);
                                });
                            }else{
                                var sql = "CALL Proc_InsertUserFromLDAP(?)";
                                conn.query(sql,[username],(err,rs)=>{
                                    if(err) throw err;
                                    var sql = "CALL Proc_SelectUserInUser(?)";
                                    conn.query(sql,[username],(err,rss)=>{
                                        if(err) throw err;
                                        rss = rss[0];
                                        setRole(rss[0].userId);
                                        var sql = "CALL Proc_SelectRoleUser(?)";
                                        conn.query(sql,[rs[0].userId],(err,rs)=>{
                                            if(err) throw err;
                                            checkRole(res,rss[0].userId,rs[0][0].userRoleName);
                                        });
                                    });
                                });
                            }
                        });
                    }else {res.send("Invalid Data");}
                });
            }
        }
    });
}