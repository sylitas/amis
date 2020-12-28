var jwt = require('jsonwebtoken');

var conn = require("../database/main.database");
var db = require("../database/sqlite.database");

//private key for JWT
var privateKey = process.env.key//change later

function decode(token,key){
    return  jwt.verify(token,key,(err,decoded)=>{
        if(err) throw err;
        return decoded.data;
    });
}

module.exports.getDashboard = (req,res)=>{
    if(req.signedCookies.auth_token){
        var token = req.signedCookies.auth_token;
        var userId = decode(token,privateKey).userId;
        var role = decode(token,privateKey).role;
        db.all("SELECT * FROM `cookies` WHERE cookie = ? AND userId = ?",[token,userId],(err,rs)=>{
            if(err) throw err;
            if(rs.length>0){
                //render
                var sql = "CALL Proc_SelectUserInUserByUserId(?)";
                conn.query(sql,[userId],(err,rs)=>{
                    if(err)throw err;
                    if(rs.length>0){
                        var username = rs[0][0].accountName;
                        //many more
                        res.render("dashboard",{
                            "username":username
                        });
                    }
                });
            }else{res.redirect("/logout");}
        });
    }else{res.redirect("/logout");}
};


