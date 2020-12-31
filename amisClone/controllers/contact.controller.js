var jwt = require("jsonwebtoken");

var func_lib = require("./function.controller");
var conn = require("../database/main.database");
var db = require("../database/sqlite.database");
var privateKey = process.env.KEY;

module.exports.getContactPage = (req,res)=>{
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
                        var sql = "CALL Proc_SelectPermissionByUserRoleName(?)";
                        conn.query(sql,[role],(err,rs)=>{
                            if(err)throw err;
                            rs = rs[0];
                            var checkPer = [];
                            if(rs.length>0){
                                for(var i=0;i<rs.length;i++){
                                    checkPer.push(rs[i].actionId);
                                }
                                var data = func_lib.func_noPer(checkPer);
                                res.render("contact",{
                                    "username":username,
                                    "use":data.use,
                                    "add":data.add,
                                    "edit":data.edit,
                                    "del":data.del,
                                    "exp":data.exp
                                });
                            }else{
                                res.render("contact",{
                                    "username":username
                                });
                            }
                        });
                    }
                });
            }else{res.redirect("/logout");}
        });
    }else{res.redirect("/logout");}
};
//for main table
module.exports.postDataForClientTable = (req,res)=>{
    var token = req.signedCookies.auth_token;
    var userId = func_lib.decode(token,privateKey).userId;
    var dataList = [];
    var draw = req.body.draw;
    var recordsTotal; 
    var recordsFiltered;
    var searchStr = req.body.search.value;
    var sql = 'SELECT * FROM `object` WHERE userId = ?';
    conn.query(sql,[userId],(err,rs)=>{
        if(err)throw err;
        recordsTotal = rs.length;
        recordsFiltered = rs.length;
        var sql = 'SELECT * FROM `object` WHERE `userId` = ? AND `name` LIKE "%'+searchStr+'%"';
        conn.query(sql,[userId],(err,rs)=>{
            if(err)throw err;
            if(searchStr){
                recordsFiltered = rs.length;
            }
            for(var i = 0;i<rs.length;i++){
                var id = rs[i].objectId;
                var name = rs[i].name;
                var phone = rs[i].phone;
                var email = rs[i].companyEmail;
                var address = rs[i].address;
                var tax = rs[i].tax;
                var ot = rs[i].objectType;
                if(ot == 1){
                    ot = "Personal Customer";
                }else{
                    ot = "Company Customer";
                }
                var bc = rs[i].budgetCode;
                var validating = [id,name,phone,email,address,tax,bc];
                var validated = func_lib.func_validate(validating);
                var data = {
                    "id":validated[0],
                    "name":validated[1],
                    "phone":validated[2],
                    "email":validated[3],
                    "address":validated[4],
                    "tax":validated[5],
                    "ot":ot,
                    "bc":validated[6]
                }
                dataList.push(data);
            }
            var dataSend = {
                "draw":draw,
                "recordsTotal":recordsTotal,
                "recordsFiltered":recordsFiltered,
                "data":dataList
            }
            res.send(dataSend);
        });
    });
};
//delete clicked 
module.exports.postDeleteDataFromTableClient = (req,res)=>{
    if(req.body.id){
        conn.query("DELETE FROM `object` WHERE `objectId` = ?",[req.body.id],(err)=>{
            if(err) throw err;
            res.send("Deleted!");
        })
    }else{
        res.send("Invalid!");;
    }
};
module.exports.postAddingClientInformation = (req,res)=>{
    if(req.body.name){
        var token = req.signedCookies.auth_token;
        var userId = func_lib.decode(token,privateKey).userId;
        var name = req.body.name;
        var phone = req.body.phone;
        var email = req.body.email;
        var address = req.body.address;
        var tax = req.body.tax;
        var bc = req.body.bc;
        var validated = func_lib.func_validate_for_query([name,phone,email,address,tax,bc]);
        if(email){
            func_lib.func_checkObjectExist(email,function(rs){
                if(rs == false){
                    res.send("Client Existed!");
                }else{
                    var sql = "INSERT INTO `object`(name,phone,companyEmail,address,tax,budgetCode,userId,objectType) VALUES(?,?,?,?,?,?,?,1)";
                    conn.query(sql,[validated[0],validated[1],validated[2],validated[3],validated[4],validated[5],userId],(err)=>{
                        if(err) throw err;
                        res.send("Added!");
                    });
                }
            })
        }else{
            var sql = "INSERT INTO `object`(name,phone,companyEmail,address,tax,budgetCode,userId,objectType) VALUES(?,?,?,?,?,?,?,2)";
            conn.query(sql,[name,phone,email,address,tax,bc,userId],(err)=>{
                if(err) throw err;
                res.send("Added!");
            });
        }
    }else{
        res.send("Invalid Name!");
    }
};
//click edit
module.exports.postDataForEdit = (req,res)=>{
    if(req.body.id){
        var sql = "SELECT * FROM `object` WHERE objectId = ?";
        conn.query(sql,[req.body.id],(err,rs)=>{
            if(err) throw err;
            var name = rs[0].name;
            var phone = rs[0].phone;
            var email = rs[0].email;
            var address = rs[0].address;
            var tax = rs[0].tax;
            var bc = rs[0].budgetCode;

            var data = func_lib.func_validate_for_edit([name,phone,email,address,tax,bc]);
            var dataSend = {
                "name":data[0],
                "phone":data[1],
                "email":data[2],
                "address":data[3],
                "tax":data[4],
                "bc":data[5]
            }
            res.send(dataSend);
        });
    }else{
        res.send("err")
    }
};
//submit editer
module.exports.postEditData = (req,res)=>{
    if(req.body.name){
        var id = req.body.id;
        var name = req.body.name;
        var phone = req.body.phone;
        var email = req.body.email;
        var address = req.body.address;
        var tax = req.body.tax;
        var bc = req.body.bc;
        var sql = "UPDATE `object` SET name = ? , phone = ? , companyEmail = ? , address = ? , tax = ? , budgetCode = ? WHERE objectId = ?";
        conn.query(sql,[name,phone,email,address,tax,bc,id],(err,rs)=>{
            if(err)throw err;
            res.send("Updated!");
        });
    }else{
        res.send("Please fill inside (*) tag");
    }
};