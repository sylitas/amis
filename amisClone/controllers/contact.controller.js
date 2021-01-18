var jwt = require("jsonwebtoken");
var dateFormat = require("dateformat");

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
                        var sql = "CALL Proc_SelectPermissionByUserRoleName_contact(?)";
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
    var draw = req.body.draw;
    var recordsTotal; 
    var recordsFiltered;
    var searchStr = req.body.search.value;
    var sql = 'SELECT * FROM `object` WHERE userId = ?';
    conn.query(sql,[userId],(err,rs)=>{
        if(err)throw err;
        recordsTotal = rs.length;
        recordsFiltered = rs.length;
        var sql = 'SELECT * FROM `object` WHERE `userId` = ? AND `objectName` LIKE "%'+searchStr+'%"';
        conn.query(sql,[userId],(err,rs)=>{
            if(err)throw err;
            if(searchStr){
                recordsFiltered = rs.length;
            }
            let dataList = [];
            if(rs.length>0){
                for(let i = 0;i<rs.length;i++){
                    var locationId = rs[i].objectId;
                    var id = rs[i].objectId;
                    var name = rs[i].objectName;
                    var phone = rs[i].objectContact_Phone;
                    var email = rs[i].objectContact_Email;
                    var tax = rs[i].objectTaxation_Tax;
                    var ot = rs[i].objectType;if(ot == 1){ot = "Personal Customer";}else{ot = "Company Customer";}
                    var bc = rs[i].objectTaxation_BudgetCode;
                    
                    Get_data(locationId,id,name,phone,email,tax,ot,bc,(data)=>{
                        dataList.push(data);
                        if(i==rs.length-1){
                            var dataSend = {
                                "data":dataList,
                                "draw":draw,
                                "recordsTotal":recordsTotal,
                                "recordsFiltered":recordsFiltered
                            }
                            res.send(dataSend);
                        }
                    })
                }   
            }else{
                var dataSend = {
                    "data":dataList,
                    "draw":draw,
                    "recordsTotal":recordsTotal,
                    "recordsFiltered":recordsFiltered
                }
                res.send(dataSend)
            }
        });
    });
};
//delete clicked 
module.exports.postDeleteDataFromTableClient = (req,res)=>{
    isPermission_contact_del(req,function(rs){
        if(rs == true){
            if(req.body.id){
                conn.query("DELETE FROM `object` WHERE `objectId` = ?",[req.body.id],(err)=>{
                    if(err) throw err;
                    res.send("Deleted!");
                })
            }else{
                res.send("Invalid!");;
            }
        }else{
            res.send("Don't have permission !");
        }
    });
};
//receive data when submiting
module.exports.postAddingClientInformation = (req,res)=>{
/*

--Column----------------Name-----D.Values-----Status------

*General Info
  Code          ->      cc                                      
  List          ->      cl              ---Change to Select 
  Name          ->      name            ---DONE                 
  Group         ->      cg              ---Change to Select
  Type          ->      toc             ---DONE
                        {
                            1-->Personal Customer
                            2-->Company Customer
                        }
  BIC           ->      sc
  Born Date     ->      dob
*Identify Card
  Number        ->      numberId
  Date          ->      dateId
  Place         ->      place
*Contact
  Phone         ->      phone           ---DONE
  Fax           ->      fax             
  Postal Code   ->      pc              
  Email         ->      emaiL           ---DONE
*Location
  City          ->      city            ---DONE
  Address       ->      address         ---DONE
  District      ->      district        ---DONE
  Trade Place   ->      tp
*Taxation & Bank Account
  Tax           ->      tax             ---DONE
  Bank Number   ->      numberBank
  Budget Code   ->      bc              ---DONE
  Branch        ->      branch 
*/
    isPermission_contact_add(req,function(rs){
        if(rs==true){
            if(req.body.data){
                //TOKEN for checking and authorize 
                var token = req.signedCookies.auth_token;
                var userId = func_lib.decode(token,privateKey).userId;
                var data = req.body.data;
                /*--start "General Info" variable receiving-- */
                var code = data[0].value;
                var list = data[1].value;
                var name = data[2].value;
                var group = data[3].value;
                if(data[4].value === "1" || data[4].value === "2"){
                    var toc = parseInt(data[4].value);
                }else{
                    res.send("Invalid Type");
                    return;
                }
                var sc = data[5].value;
                var dob = data[6].value;
                //--end General data receiving--//

                //--start Identify Card receiving data--//
                var numberId = data[7].value;
                var dateId = data[8].value;
                var place = data[9].value;
                //--end Identify Card receiving data--//

                //--start Contact receiving data--//
                var phone = data[10].value;
                var fax = data[11].value;
                var pc = data[12].value;
                var email = data[13].value;
                //--end Contact receiving data--//

                //--start Location receiving data--//
                var city = data[14].value;
                var address = data[15].value;
                var district = data[16].value;
                var tp = data[17].value;
                //--end Location receiving data--//

                //--start Taxation & Bank Account receiving data--//
                var tax = data[18].value;
                var numberBank = data[19].value;
                var bc = data[20].value;
                var branch = data[21].value;
                //--end Taxation & Bank Account receiving data--//
                var validated = func_lib.func_validate_for_query(
                    [   
                        code,list,name,group,sc,
                        numberId,dateId,place,
                        phone,fax,pc,email,
                        address,tp,
                        tax,bc,
                        numberBank,branch
                    ]
                );
                if(!dob){
                    dob=null;
                }
                if(!validated[2]){
                    res.send("Invalid Name");
                    return;
                }
                if(!city){
                    res.send("Invalid City");
                    return;
                }
                if(!validated[12]){
                    address=null;
                }     
                Create_Location(city,district,address);
                //Insert all values except "list" and "group"
                var sql = 
                "INSERT INTO `object`(\
                    userId,\
                    objectCode, objectType, objectName, objectBirthday, objectSwiftCode,\
                    objectIdCard_Number ,objectIDCard_Date, objectIDCard_Place,\
                    objectContact_Phone, objectContact_Fax, objectContact_PostalCode, objectContact_Email,\
                    objectLocation_TradePlace,\
                    objectTaxation_Tax, objectTaxation_BudgetCode,\
                    objectBank_AccountNumber, objectBank_Branch) \
                VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
                conn.query(sql,[
                    userId,
                    validated[0],toc,validated[2],dob,validated[4],
                    validated[5],validated[6],validated[7],
                    validated[8],validated[9],validated[10],validated[11],
                    validated[13],
                    validated[15],validated[16],
                    validated[17],validated[18]
                ],(err)=>{
                    if(err) throw err;
                    res.send("Added!");
                });
            }else{
                res.send("Invalid Data");
            }
        }else{
            res.send("Don't have permission !");
        }
    });
};
//click edit
module.exports.postDataForEdit = (req,res)=>{
    isPermission_contact_edit(req,function(rs){
        if(rs==true){
            if(req.body.id){
                var sql = "SELECT * FROM `object` WHERE objectId = ?";
                conn.query(sql,[req.body.id],(err,rs)=>{
                    if(err) throw err;
                    if(rs.length>0){
                        var locationId = req.body.id;
                        /*--start "General Info" variable receiving-- */
                        var code = rs[0].objectCode;
                        var list = "";
                        var name = rs[0].objectName;
                        var group = "";
                        var toc = rs[0].objectType;
                        var sc = rs[0].objectSwiftCode;
                        if(rs[0].objectBirthday != null){
                            var dob = dateFormat(rs[0].objectBirthday,"yyyy-mm-d");
                        }else{
                            var dob = null;
                        }
                        //--end General data receiving--//

                        //--start Identify Card receiving data--//
                        var numberId = rs[0].objectIDCard_Number;
                        if(rs[0].objectIDCard_Date != null){
                            var dateId = dateFormat(rs[0].objectIDCard_Date,"yyyy-mm-d");
                        }else{
                            var dateId = null;
                        }
                        var place = rs[0].objectIDCard_Place;
                        //--end Identify Card receiving data--//

                        //--start Contact receiving data--//
                        var phone = rs[0].objectContact_Phone;
                        var fax = rs[0].objectContact_Fax;
                        var pc = rs[0].objectContact_PostalCode;
                        var email = rs[0].objectContact_Email;
                        //--end Contact receiving data--//

                        //--start Location receiving data--//
                        // var city = rs[0].;
                        //var address = rs[0].;
                        // var district = rs[0].;
                        var tp = rs[0].objectLocation_TradePlace;
                        //--end Location receiving data--//

                        //--start Taxation & Bank Account receiving data--//
                        var tax = rs[0].objectTaxation_Tax;
                        var numberBank = rs[0].objectBank_AccountNumber;
                        var bc = rs[0].objectTaxation_BudgetCode;
                        var branch = rs[0].objectBank_AccountNumber;
                        //--end Taxation & Bank Account receiving data--//

                        var validated = func_lib.func_validate_for_edit(
                            [   
                                code,list,name,group,sc,
                                numberId,dateId,place,
                                phone,fax,pc,email,
                                tp,
                                tax,bc,
                                numberBank,branch
                            ]
                        );
                        conn.query( "CALL Proc_SelectCityOfObjectFromLocation(?)",[locationId],(err,rs)=>{
                            if(err)throw err;
                            rs = rs[0];
                            var city = rs[0].cityName;
                            var address = rs[0].address;
                            var districtId = rs[0].districtId;
                            var sql = "SELECT `districtName` FROM `district` WHERE districtId = ?";
                            conn.query(sql,[districtId],(err,rs)=>{
                                if(err) throw err;
                                if(rs.length>0){
                                    var district = rs[0].districtName;
                                }else{
                                    var district = null;
                                }
                                var data = {
                                    "code":validated[0],"list":validated[1],"name":validated[2],"group":validated[3],"toc":toc,"sc":validated[4],"dob":dob,
                                    "numberId":validated[5],"dateId":validated[6],"place":validated[7],
                                    "phone":validated[8],"fax":validated[9],"pc":validated[10],"email":validated[11],
                                    "city":city,"address":address,"district":district,"tp":validated[12],
                                    "tax":validated[13],"bc":validated[14],
                                    "numberBank":validated[15],"branch":validated[16]
                                }
                                res.send(data);
                            });
                        });
                        
                    }
                });
            }else{
                res.send("err")
            }
        }else{
            res.send("err2");
        }
    });
};
//submit editer
module.exports.postEditData = (req,res)=>{
    isPermission_contact_edit(req,function(check){
        if(check == true){
            var objectId = req.body.id;
            var data = req.body.data;
            if(!objectId){
                req.send("Invalid Data");
                return;
            }
            for(let i = 0;i<data.length;i++){
                if(data[i].name == "name"){
                    if(!data[i].value){
                        res.send("Invalid Data!")
                        return;
                    }
                }
                if(data[i].name == "toc"){
                    if(!data[i].value){
                        res.send("Invalid Data!");
                        return;
                    }
                }
                if(data[i].name == "calc_shipping_provinces"){
                    if(!data[i].value){
                        res.send("Invalid Data!");
                        return;
                    }
                }
            }
            /*--start "General Info" variable receiving-- */
            var code = data[0].value;
            var list = data[1].value;
            var name = data[2].value;
            var group = data[3].value;
            if(data[4].value === "1" || data[4].value === "2"){
                var toc = parseInt(data[4].value);
            }else{
                res.send("Invalid Type");
                return;
            }
            var sc = data[5].value;
            var dob = data[6].value;
            //--end General data receiving--//

            //--start Identify Card receiving data--//
            var numberId = data[7].value;
            var dateId = data[8].value;
            var place = data[9].value;
            //--end Identify Card receiving data--//

            //--start Contact receiving data--//
            var phone = data[10].value;
            var fax = data[11].value;
            var pc = data[12].value;
            var email = data[13].value;
            //--end Contact receiving data--//

            //--start Location receiving data--//
            var city = data[14].value;
            var address = data[15].value;
            var district = data[16].value;
            var tp = data[17].value;
            //--end Location receiving data--//

            //--start Taxation & Bank Account receiving data--//
            var tax = data[18].value;
            var numberBank = data[19].value;
            var bc = data[20].value;
            var branch = data[21].value;
            //--end Taxation & Bank Account receiving data--//
            var validated = func_lib.func_validate_for_query(
                [   
                    code,list,name,group,sc,
                    numberId,dateId,place,
                    phone,fax,pc,email,
                    address,tp,
                    tax,bc,
                    numberBank,branch
                ]
            );
            if(!dob){
                dob=null;
            }
            if(!validated[12]){
                address=null;
            }
            var sql = 
            "UPDATE `object` \
            SET\
                objectCode = ?, objectType = ?, objectName = ?, objectBirthday = ?, objectSwiftCode = ?, \
                objectIdCard_Number = ?, objectIDCard_Date = ?, objectIDCard_Place = ?, \
                objectContact_Phone = ?, objectContact_Fax = ?, objectContact_PostalCode = ?, objectContact_Email = ?, \
                objectLocation_TradePlace = ?, \
                objectTaxation_Tax = ?, objectTaxation_BudgetCode = ?, \
                objectBank_AccountNumber = ?, objectBank_Branch = ? \
            WHERE objectId = ?";
            conn.query(sql,[
                validated[0],toc,validated[2],dob,validated[4],
                validated[5],validated[6],validated[7],
                validated[8],validated[9],validated[10],validated[11],
                validated[13],
                validated[15],validated[16],
                validated[17],validated[18],
                objectId
            ],(err,rs)=>{
                if(err)throw err;
                res.send("Updated!");
            });

        }else{
            res.send("Permission Denied!");
        }
    });
};
function isPermission_contact_del(req,callback){
    var token = req.signedCookies.auth_token;
    var role = func_lib.decode(token,privateKey).roleId;
    var sql = "CALL Proc_SelectPermissionByUserRoleName_contact(?)";
    conn.query(sql,[role],(err,rs)=>{
        if(err)throw err;
        rs = rs[0];
        var checkPer = [];
        if(rs.length>0){
            for(var i=0;i<rs.length;i++){
                checkPer.push(rs[i].actionId);
            }
            var data = func_lib.func_noPer(checkPer);
            if(data.del==true){
                callback(true);
            }else{
                callback(false);
            }
        }else{
            callback(false);
        }
    });
};
function isPermission_contact_add(req,callback){
    var token = req.signedCookies.auth_token;
    var role = func_lib.decode(token,privateKey).roleId;
    var sql = "CALL Proc_SelectPermissionByUserRoleName_contact(?)";
    conn.query(sql,[role],(err,rs)=>{
        if(err)throw err;
        rs = rs[0];
        var checkPer = [];
        if(rs.length>0){
            for(var i=0;i<rs.length;i++){
                checkPer.push(rs[i].actionId);
            }
            var data = func_lib.func_noPer(checkPer);
            if(data.add==true){
                callback(true);
            }else{
                callback(false);
            }
        }else{
            callback(false);
        }
    });
};
function isPermission_contact_edit(req,callback){
    var token = req.signedCookies.auth_token;
    var role = func_lib.decode(token,privateKey).roleId;
    var sql = "CALL Proc_SelectPermissionByUserRoleName_contact(?)";
    conn.query(sql,[role],(err,rs)=>{
        if(err)throw err;
        rs = rs[0];
        var checkPer = [];
        if(rs.length>0){
            for(var i=0;i<rs.length;i++){
                checkPer.push(rs[i].actionId);
            }
            var data = func_lib.func_noPer(checkPer);
            if(data.edit==true){
                callback(true);
            }else{
                callback(false);
            }
        }else{
            callback(false);
        }
    });
};
function Create_Location(city,district,address){
    var sql = "SELECT `cityName` FROM `city` WHERE cityName = ?";
    conn.query(sql,[city],(err,rs)=>{
        if(err) throw err;
        if(rs.length==0){
            var sql = "INSERT INTO `city`(cityName) VALUES (?)";
            conn.query(sql,[city],(err)=>{
                if(err) throw err;
            });
        }
        var sql = "SELECT `cityId` FROM `city` WHERE cityName = ?";
        conn.query(sql,[city],(err,rs)=>{
            if(err) throw err;
            var cityId = rs[0].cityId
            if(district){
                var sql = "SELECT `districtName` FROM `district` WHERE districtName = ?";
                conn.query(sql,[district],(err,rs)=>{
                    if(err) throw err;
                    if(rs.length==0){
                        var sql = "INSERT INTO `district`(cityId,districtName) VALUES (?,?)";
                        conn.query(sql,[cityId,district],(err)=>{
                            if(err) throw err;
                        });
                    }
                    var sql = "SELECT `districtId` FROM `district` WHERE `districtName` = ? AND cityId = ?";
                    conn.query(sql,[district,cityId],(err,rs)=>{
                        if(err) throw err;
                        var districtId = rs[0].districtId;
                        var sql = "INSERT INTO `location`(cityId,districtId,address) VALUES(?,?,?)";
                        conn.query(sql,[cityId,districtId,address],(err)=>{
                            if(err)throw err;
                        });
                    });
                });
            }else{
                var sql = "INSERT INTO `location`(cityId,address) VALUES(?,?)";
                conn.query(sql,[cityId,address],(err)=>{
                    if(err)throw err;
                });
            }
        });
    });
};
function Get_Location(locationId,callback){
    var location;
    conn.query( "CALL Proc_SelectCityOfObjectFromLocation(?)",[locationId],(err,rs)=>{
        if(err)throw err;
        rs = rs[0];
        var city = rs[0].cityName;
        var address = rs[0].address;
        var district = rs[0].districtId;
        var sql = "SELECT `districtName` FROM `district` WHERE districtId = ?";
        conn.query(sql,[district],(err,rs)=>{
            if(err) throw err;
            if(rs.length>0){
                if(address){location = address +", "+rs[0].districtName+", "+city;}else{location = rs[0].districtName+", "+city;}
                callback(location);
            }else{
                if(!address){location = city;}else{location = address +", "+ city;}
                callback(location);
            }
        });
    });
};
function Get_data(locationId,id,name,phone,email,tax,ot,bc,callback){
    Get_Location(locationId,(location)=>{
        var validating = [id,name,phone,email,tax,bc];
        var validated = func_lib.func_validate(validating);
        let data = {
            "id":validated[0],
            "name":validated[1],
            "phone":validated[2],
            "email":validated[3],
            "location":location,
            "tax":validated[4],
            "ot":ot,
            "bc":validated[5]
        }
        callback(data);
    });
};