var ActiveDirectory = require('activedirectory');
var CryptoJS = require("crypto-js");

var db = require("../database/sqlite.database");
var key = process.env.KEY;
module.exports.getAuthLDAPPage = (req,res)=>{
    res.render('LDAP');
};
module.exports.postAuthLDAPPage = (req,res)=>{
    var ip = req.body.ip
    var baseDN = req.body.baseDN;
    var username =  req.body.username;
    var password = req.body.password;

    if(!ip){return;}
    if(!baseDN){return;}
    if(!username){return;}
    if(!password){return;}

    var cipher_pass = CryptoJS.AES.encrypt(password, key).toString();
    db.all("SELECT * FROM `ldap` WHERE id = 1",(err,rs)=>{
        if(rs.length > 0){
            db.run("UPDATE `ldap` SET ip = ?, baseDN = ?, username = ?, password = ?",[ip,baseDN,username,cipher_pass],(err,rs)=>{
                if(err) throw err;
            });
        }else{
            db.run("INSERT INTO `ldap`(ip,baseDN,username,password) VALUES(?,?,?,?)",[ip,baseDN,username,cipher_pass],(err,rs)=>{
                if(err) throw err;
            });
        }
    });
    var config = { 
        url     : ip,
        baseDN  : baseDN,
        username: username,
        password: password 
    }
    var ad = new ActiveDirectory(config);
    ad.authenticate(username, password, function(err, auth) {
        if(auth){
            res.send("Successful!")
        }else{
            res.send("Wrong Information!");
        }
    });
};