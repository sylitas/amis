var ActiveDirectory = require('activedirectory');
var CryptoJS = require("crypto-js");
var jwt = require('jsonwebtoken');


var privateKey = process.env.KEY;
var key = process.env.KEY;
const functionId = 1;// /management/role

var db = require("../database/sqlite.database");
var conn = require("../database/main.database");
var func_lib = require("./function.controller");

var key = process.env.KEY;
const isLocal = 2;
const activeVal =  "66048";
//render LDAP API
module.exports.getAuthLDAPPage = (req,res)=>{
    if(req.signedCookies.auth_token){
        var token = req.signedCookies.auth_token;
        var userId = func_lib.decode(token,privateKey).userId;
        var role = func_lib.decode(token,privateKey).roleId;
        db.all("SELECT * FROM `cookies` WHERE cookie = ? AND userId = ?",[token,userId],(err,rs)=>{
            if(err) throw err;
            if(rs.length>0){
                //render
                var sql = "CALL Proc_SelectUserInUserByUserId(?)";
                conn.query(sql,[userId],(err,rs)=>{
                    if(err)throw err;
                    if(rs.length>0){
                        var username = rs[0][0].accountName;
                        var sql = "CALL Proc_SelectPermissionByUserRoleName(?,?)";
                        conn.query(sql,[role,functionId],(err,rs)=>{
                            if(err)throw err;
                            rs = rs[0];
                            var checkPer = [];
                            if(rs.length>0){
                                for(var i=0;i<rs.length;i++){
                                    checkPer.push(rs[i].actionId);
                                }
                                var data = func_lib.func_noPer(checkPer);
                                get_connection_from_LDAP(function(config){
                                    if(config){
                                        res.render("LDAP",{
                                            "accountName":username,
                                            "url":config.url,
                                            "baseDN":config.baseDN,
                                            "username":config.username,
                                            "password":config.password,
                                            "use":data.use,
                                            "add":data.add,
                                            "edit":data.edit,
                                            "del":data.del,
                                            "exp":data.exp
                                        });
                                    }else{
                                        res.render("LDAP",{
                                            "accountName":username
                                        });
                                    }
                                });
                            }else{
                                res.render("LDAP",{
                                    "accountName":username
                                });
                            }
                        });
                    }
                });
            }else{res.redirect("/logout");}
        });
    }else{res.redirect("/logout");}
};
//LDAP page
module.exports.postAuthLDAPPage = (req,res)=>{
    var url = req.body.ip;
    if(url.includes("ldap://")){
        var url = url;
    }else{
        var url = "ldap://"+url;
    }
    var baseDN = req.body.baseDN;
    var username =  req.body.username;
    if(username.includes("@htc-itc.local")){
        var username = username;
    }else{
        var username = username+"@htc-itc.local";
    }
    var password = req.body.password;

    if(!url){return;}
    if(!baseDN){return;}
    if(!username){return;}
    if(!password){return;}

    var cipher_pass = CryptoJS.AES.encrypt(password, key).toString();
    db.all("SELECT * FROM `ldap` WHERE id = 1",(err,rs)=>{
        if(rs.length > 0){
            db.run("UPDATE `ldap` SET ip = ?, baseDN = ?, username = ?, password = ?",[url,baseDN,username,cipher_pass],(err,rs)=>{
                if(err) throw err;
            });
        }else{
            db.run("INSERT INTO `ldap`(ip,baseDN,username,password) VALUES(?,?,?,?)",[url,baseDN,username,cipher_pass],(err,rs)=>{
                if(err) throw err;
            });
        }
    });
    var config = { 
        url     : url,
        baseDN  : baseDN,
        username: username,
        password: password 
    }
    var ad = new ActiveDirectory(config);
    ad.authenticate(username, password, function(err, auth) {
        if(auth){
            var userList_filtered = [];
            var ad = new ActiveDirectory({
                url     : url,
                baseDN  : baseDN,
                username: username,
                password: password,
                attributes: {
                    user: [ 'objectSid', 'sAMAccountName', 'mail', 'displayName' , 'description' , 'userAccountControl' ]
                },
                entryParser : customEntryParser
            });
            ad.findUsers('cn=*', function(err, rs) {
                for(var i=0;i<rs.length;){
                    var fullname =  rs[i].displayName;
                    if(!fullname){i++;}else{
                        var sid = JSON.stringify(rs[i].objectSid);
                        var name = rs[i].sAMAccountName;
                        var email = rs[i].mail;
                        var des = rs[i].description;
                        if(rs[i].userAccountControl == activeVal){var status = "active";}else{var status = "inactive"}
                        if(!name){name = null;};
                        if(!email){email=null;}
                        if(!des){des = null;}
                        var data = {
                            sid:sid,
                            name:name,
                            fullname:fullname,
                            email:email,
                            description:des,
                            status:status
                        }
                        userList_filtered.push(data);
                        i++;
                    }
                }
                for(let i=0;i<userList_filtered.length;i++){
                    let sid = userList_filtered[i].sid;
                    let name = userList_filtered[i].name;
                    let fullname = userList_filtered[i].fullname;
                    let des = userList_filtered[i].description;
                    let status = userList_filtered[i].status;
                    if(status == "inactive"){var inactive = 1;}else{var inactive = 0;}
                    (function(name,isLocal,fullname,des,inactive){
                        conn.query("SELECT `objectSid` FROM `user` WHERE `objectSid` = ?",[sid],(err,rs)=>{
                            if(err) throw err;
                            if(rs.length>0){
                                conn.query( "UPDATE `user` SET accountName = ?, isLocal = ?, fullName = ?, userNote = ?, inactive = ? WHERE objectSid = ?",[name,isLocal,fullname,des,inactive,sid],(err)=>{
                                    if(err)throw err;
                                });
                            }else{
                                conn.query( "INSERT INTO `user`(accountName,objectSid,isLocal,fullName,userNote,inactive) VALUES (?,?,?,?,?,?)",[name,sid,isLocal,fullname,des,inactive],(err)=>{
                                    if(err)throw err;
                                });
                            }
                        });
                    })(name,isLocal,fullname,des,inactive);
                }
                res.send(true);
            });
        }else{
            res.send(false);
        }
    });
};
//data for LDAPuser
module.exports.postDataForLDAPuser = (req,res)=>{
    var dataList = [];
    var draw = req.body.draw;
    var length = req.body.length;
    var start = req.body.start;
    var recordsTotal; 
    var recordsFiltered;
    var searchStr = req.body.search.value;
    conn.query("SELECT * FROM `user` WHERE isLocal = 2",(err,rs)=>{
        if(err) throw err;
        recordsTotal = rs.length;
        recordsFiltered = rs.length;
        conn.query('SELECT * FROM `user` WHERE isLocal = 2 AND `fullName` LIKE "%'+searchStr+'%" LIMIT '+length+' OFFSET '+start,(err,rs)=>{
            if(err) throw err; 
            if(searchStr){
                recordsFiltered = rs.length;
            }
            if(rs.length>0){
                for(let i=0;i<rs.length;i++){
                    var name = rs[i].accountName;
                    var fullname = rs[i].fullName;
                    var email = rs[i].email;
                    var des = rs[i].userNote;
                    var status = rs[i].inactive;
                    if(!name){name = null;}
                    if(!fullname){fullname = null;}
                    if(!email){email = null;}
                    if(!des){des = null;}
                    if(status == 0){status = "active";}else{status = "inactive";}
                    var data = {
                        name:name,
                        fullname:fullname,
                        email:email,
                        description:des,
                        status:status
                    }
                    dataList.push(data);
                }
                var dataSend = {
                    "data":dataList,
                    "draw":draw,
                    "recordsTotal":recordsTotal,
                    "recordsFiltered":recordsFiltered
                }
                res.send(dataSend);
            }else{
                dataList = [];
                var dataSend = {
                    "data":dataList,
                    "draw":draw,
                    "recordsTotal":recordsTotal,
                    "recordsFiltered":recordsFiltered
                }
                res.send(dataSend);
            }
        });
    });
};
//sync clicked
module.exports.syncDataToDatabase = (req,res)=>{
    get_connection_from_LDAP((config)=>{
        if(config){
            var userList_filtered = [];
            var ad = new ActiveDirectory({
                url:config.url,
                baseDN:config.baseDN,
                username:config.username,
                password:config.password,
                attributes: {
                    user: [ 'objectSid', 'sAMAccountName', 'mail', 'displayName' , 'description' , 'userAccountControl' ]
                },
                entryParser : customEntryParser
            });
            ad.findUsers('cn=*', function(err, rs) {
                for(var i=0;i<rs.length;){
                    var fullname =  rs[i].displayName;
                    if(!fullname){i++;}else{
                        var sid = JSON.stringify(rs[i].objectSid);
                        var name = rs[i].sAMAccountName;
                        var email = rs[i].mail;
                        var des = rs[i].description;
                        if(rs[i].userAccountControl == activeVal){var status = "active";}else{var status = "inactive"}
                        if(!name){name = null;};
                        if(!email){email=null;}
                        if(!des){des = null;}
                        var data = {
                            sid:sid,
                            name:name,
                            fullname:fullname,
                            email:email,
                            description:des,
                            status:status
                        }
                        userList_filtered.push(data);
                        i++;
                    }
                }
                for(let i=0;i<userList_filtered.length;i++){
                    let sid = userList_filtered[i].sid;
                    let name = userList_filtered[i].name;
                    let fullname = userList_filtered[i].fullname;
                    let des = userList_filtered[i].description;
                    let status = userList_filtered[i].status;
                    if(status == "inactive"){var inactive = 1;}else{var inactive = 0;}
                    (function(name,isLocal,fullname,des,inactive){
                        conn.query("SELECT `objectSid` FROM `user` WHERE `objectSid` = ?",[sid],(err,rs)=>{
                            if(err) throw err;
                            if(rs.length>0){
                                conn.query( "UPDATE `user` SET accountName = ?, isLocal = ?, fullName = ?, userNote = ?, inactive = ? WHERE objectSid = ?",[name,isLocal,fullname,des,inactive,sid],(err)=>{
                                    if(err)throw err;
                                });
                            }else{
                                conn.query( "INSERT INTO `user`(accountName,objectSid,isLocal,fullName,userNote,inactive) VALUES (?,?,?,?,?,?)",[name,sid,isLocal,fullname,des,inactive],(err)=>{
                                    if(err)throw err;
                                });
                            }
                        });
                    })(name,isLocal,fullname,des,inactive);
                }
                res.send("Done");
            });
        }else{
            res.send("Please Create Connection First");
        } 
    });
};
function get_connection_from_LDAP(callback){
    db.all("SELECT * FROM `ldap` WHERE id = 1",(err,rs)=>{
        if(rs.length>0){
            var url = rs[0].ip;
            var baseDN = rs[0].baseDN;
            var username = rs[0].username;
            var cipher_password = rs[0].password;
            var decrypt_password  = CryptoJS.AES.decrypt(cipher_password, key);
            var password = decrypt_password.toString(CryptoJS.enc.Utf8);
            var config = { 
                url     : url,
                baseDN  : baseDN,
                username: username,
                password: password 
            }
            var ad = new ActiveDirectory(config);
            ad.authenticate(username, password, function(err, auth) {
                if(auth){
                    callback(config);
                }else{
                    callback(null);
                }
            });
        }else{
            callback(null);
        }
    });
};
function customEntryParser(entry, raw, callback){
    if (raw.hasOwnProperty("objectSid")){
        entry.objectSid = raw.objectSid;
    }
    callback(entry);
};