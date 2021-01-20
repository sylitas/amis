var ActiveDirectory = require('activedirectory');
var CryptoJS = require("crypto-js");
var jwt = require('jsonwebtoken');

var privateKey = process.env.KEY;
var key = process.env.KEY;

var db = require("../database/sqlite.database");
var conn = require("../database/main.database");

var key = process.env.KEY;
const isLocal = 2;
const activeVal =  "66048";
//render LDAP API
module.exports.getAuthLDAPPage = (req,res)=>{
    if(req.signedCookies.auth_token){
        var token = req.signedCookies.auth_token;
        var userId = decode(token,privateKey).userId;
        var role = decode(token,privateKey).role;
        db.all("SELECT * FROM `cookies` WHERE cookie = ? AND userId = ?",[token,userId],(err,rs)=>{
            if(err) throw err;
            if(rs.length>0){
                //render
                get_connection_from_LDAP(function(config){
                    if(config){
                        res.render("LDAP",{
                            "url":config.url,
                            "baseDN":config.baseDN,
                            "username":config.username,
                            "password":config.password
                        });
                    }else{
                        res.render("LDAP");
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

    var config = { 
        url     : url,
        baseDN  : baseDN,
        username: username,
        password: password 
    }
    
    var ad = new ActiveDirectory(config);
    ad.authenticate(username, password, function(err, auth) {
        if(auth){
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
            res.send(true);
        }else{
            res.send(false);
        }
    });
};
//data for LDAPuser
module.exports.postDataForLDAPuser = (req,res)=>{
    get_connection_from_LDAP((config)=>{
        var userList_filtered = [];
        var draw = req.body.draw;
        var recordsTotal; 
        var recordsFiltered;
        var searchStr = req.body.search.value;
        if(searchStr){
            var query = 'cn=*'+searchStr+'*'
        }else{
            var query = 'cn=*'
        }
        var ad = new ActiveDirectory(config);
        ad.findUsers('cn=*', function(err, rs) {
            recordsTotal = rs.length;
            recordsFiltered = rs.length;
            ad.findUsers(query, function(err, rs) {
                if(rs !== undefined){
                    if(searchStr){
                        recordsFiltered = rs.length;
                    }
                    for(var i=0;i<rs.length;){
                        var fullname =  rs[i].displayName;
                        if(!fullname){i++;}else{
                            var name = rs[i].sAMAccountName;
                            var email = rs[i].mail;
                            var des = rs[i].description;
                            if(rs[i].userAccountControl == activeVal){var status = "active";}else{var status = "inactive"}
                            if(!name){name = "";};
                            if(!email){email="";}
                            if(!des){des = "";}
                            var data = {
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
                }else{
                    userList_filtered = [];
                }
                var userList_filtered_Send = {
                    "draw":draw,
                    "recordsTotal":recordsTotal,
                    "recordsFiltered":recordsFiltered,
                    "data":userList_filtered
                }
                res.send(userList_filtered_Send);
            });
        });
    });
};
//sync clicked
module.exports.syncDataToDatabase = (req,res)=>{
    get_connection_from_LDAP((config)=>{
        var userList_filtered = [];
        var ad = new ActiveDirectory(config);
        ad.findUsers('cn=*', function(err, rs) {
            for(var i=0;i<rs.length;){
                var fullname =  rs[i].displayName;
                if(!fullname){i++;}else{
                    var name = rs[i].sAMAccountName;
                    var email = rs[i].mail;
                    var des = rs[i].description;
                    if(rs[i].userAccountControl == activeVal){var status = "active";}else{var status = "inactive"}
                    if(!name){name = "";};
                    if(!email){email="";}
                    if(!des){des = "";}
                    var data = {
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
            conn.query("DELETE FROM `user` WHERE isLocal = 2",(err,rs)=>{
                if(err) throw err;
            });
            for(let i=0;i<userList_filtered.length;i++){
                let name = userList_filtered[i].name;
                let fullname = userList_filtered[i].fullname;
                let des = userList_filtered[i].description;
                let status = userList_filtered[i].status;
                if(status == "inactive"){var inactive = 1;}
                (function(name,isLocal,fullname,des,inactive){
                    conn.query( "INSERT INTO `user`(accountName,isLocal,fullName,userNote,inactive) VALUES (?,?,?,?,?)",[name,isLocal,fullname,des,inactive],(err,rs)=>{
                        if(err)throw err;
                    });
                })(name,isLocal,fullname,des,inactive);
            }
            res.send("Done");
        });
    });
};
function decode(token,key){
    return  jwt.verify(token,key,(err,decoded)=>{
        if(err) throw err;
        return decoded.data;
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
            callback(config);
        }else{
            callback(null);
        }
    });
};