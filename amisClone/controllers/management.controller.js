var conn = require("../database/main.database");
module.exports.getRole = (req,res)=>{
    res.render("role");
};
module.exports.postRole = (req,res)=>{
    var dataList = [];
    var draw = req.body.draw;
    var recordsTotal; 
    var recordsFiltered;
    var searchStr = req.body.search.value;
    var sql = 'CALL Proc_SelectAllUserRole()';
    conn.query(sql,(err,rs)=>{
        if(err)throw err;
        rs = rs[0];
        recordsTotal = rs.length;
        recordsFiltered = rs.length;
        var sql = 'SELECT * FROM `userRole` WHERE `userRoleName` LIKE "%'+searchStr+'%"';
        conn.query(sql,(err,rs)=>{
            if(err)throw err;
            if(searchStr){
                recordsFiltered = rs.length;
            }
            for(var i = 0;i<rs.length;i++){
                var id = rs[i].userRoleId;
                var name = rs[i].userRoleName;
                var note = rs[i].userRoleNote;
                if(!note){note = null;}
                var data = {
                    "id":id,
                    "name":name,
                    "note":note
                };
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
module.exports.postUserInRole = (req,res)=>{
    if(req.body.id){var roleId = req.body.id;}else{var roleId = 1}
    var data = [];
    var dataList = [];
    var draw = req.body.draw;
    var recordsTotal; 
    var recordsFiltered;
    var sql = 'CALL Proc_SelectUserbyUserRoleId(?)';
    conn.query(sql,[roleId],(err,rs)=>{
        if(err)throw err;
        rs = rs[0];
        recordsTotal = rs.length;
        recordsFiltered = rs.length;
        for(var i = 0;i<rs.length;i++){
            var id = rs[i].userId;
            var name = rs[i].accountName;
            var fullname = rs[i].fullName;
            var title = rs[i].title;
            var workplace = rs[i].workplace;
            var note = rs[i].userNote;
            var data = [id,name,fullname,title,workplace,note];
            var arr_data = func_validate(data);
            dataList.push(arr_data);
        }
            var dataSend = {
                "draw":draw,
                "recordsTotal":recordsTotal,
                "recordsFiltered":recordsFiltered,
                "data":dataList
            }
            res.send(dataSend);
        });
};
module.exports.postAddNewRole = (req,res)=>{
    if(!req.body.role){
        res.send("Invalid Data!");
    }else{
        var role = req.body.role;
        if(req.body.note){var note = req.body.note;}else{var note = null;}
        var sql = "CALL Proc_SelectRoleIdByName(?)";
        conn.query(sql,[role],(err,rs)=>{
            rs = rs[0];
            if(rs.length>0){
                res.send("false");
            }else{
                var sql = "INSERT INTO `userRole`(userRoleName,userRoleNote) VALUES(?,?)";
                conn.query(sql,[role,note],(err,rs)=>{
                    if(err)throw err;
                    res.send("Added!");
                });
            }
        });
    }
};
module.exports.postDeleteRole = (req,res)=>{
    if(!req.body.id){
        res.send("Invalid Data");
    }else{
        var id = req.body.id;
        var sql = "DELETE FROM `userRole` WHERE userRoleId = ?";
        conn.query(sql,[id],(err,rs)=>{
            if(err)throw err;
            res.send("Deleted!");
        });
    }
};
module.exports.takeValueForEditRole = (req,res)=>{
    var id = req.body.id;
    var sql = "CALL Proc_SelectRoleByRoleId(?)";
    conn.query(sql,[id],(err,rs)=>{
        if(err) throw err;
        if(rs.length>0){
            rs = rs[0][0];
            var name = rs.userRoleName;
            var note = rs.userRoleNote;
            var arr_data = [name,note];
            var data = func_validate(arr_data);
            var dataSend = {
                "name":data[0],
                "note":data[1]
            }
            res.send(dataSend);
        }else{
            res.send("false");
        }
    });
};
module.exports.postEditRole = (req,res)=>{
    var id = req.body.id;
    var name = req.body.name;
    var note = req.body.note;
    if(note == ""){note = null;}
    var sql = "CALL Proc_SelectRoleIdByName(?)";
    conn.query(sql,[name],(err,rs)=>{
        if(err) throw err;
        rs = rs[0];
        if(rs.length>0){
            var userRoleId = rs[0].userRoleId;
            if(id.toString() !== userRoleId.toString()){
                res.send("false");
            }else{
                func_updateRole(id,name,note);
                res.send("true");
            }
        }else{
            func_updateRole(id,name,note);
            res.send("true");
        }
    });
};
module.exports.postUserDataByAjax = (req,res)=>{
    var dataList = [];
    var draw = req.body.draw;
    var recordsTotal; 
    var recordsFiltered;
    var searchStr = req.body.search.value;
    var sql = 'SELECT userId,accountName,fullName,title,workplace,userNote FROM `user`';
    conn.query(sql,(err,rs)=>{
        if(err)throw err;
        recordsTotal = rs.length;
        recordsFiltered = rs.length;
        var sql = 'SELECT userId,accountName,fullName,title,workplace,userNote FROM `user` WHERE accountName LIKE "%'+searchStr+'%"';
        conn.query(sql,(err,rs)=>{
            if(err)throw err;
            if(searchStr){
                recordsFiltered = rs.length;
            }
            for(var i = 0;i<rs.length;i++){
                var id = rs[i].userId;
                var username = rs[i].accountName;
                var fullname = rs[i].fullName;
                var title = rs[i].title;
                var place = rs[i].workplace;
                var note = rs[i].userNote;
                var arr_data = [id,username,fullname,title,place,note];
                var vad = func_validate(arr_data);
                var data = {
                    "id":vad[0],
                    "username":vad[1],
                    "fullname":vad[2],
                    "title":vad[3],
                    "place":vad[4],
                    "note":vad[5]
                };
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
module.exports.postDataForAddingUser = (req,res)=>{
    var userId = req.body.userId;
    var roleId = req.body.roleId;
    var check = 0;
    if(req.body.roleId !== undefined && userId !== undefined){
        for (var i=0;i<userId.length;i++){
            var id = userId[i];
            (function(id){
                conn.query( "SELECT * FROM `userUserRole` WHERE userId = ? AND userRoleId = ?",[id,roleId],(err,rs)=>{
                    if(err)throw err;
                    if(rs.length == 0){
                        conn.query("INSERT INTO `userUserRole`(userId,userRoleId) VALUES(?,?)",[id,roleId],(err,rs)=>{
                            if(err)throw err;
                        });
                    }
                });
            })(id);
        }
    }else{
        res.send("false2");
    }
    res.send("true");
};
module.exports.postDeleteUserInRole = (req,res)=>{
    var roleId = req.body.roleId;
    var userId = req.body.userId;
    var sql = "DELETE FROM `userUserRole` WHERE `userUserRole`.`userId` = ? AND `userUserRole`.`userRoleId` = ?";
    conn.query(sql,[userId,roleId],(err,rs)=>{
        if(err) throw err;
        res.send("Done");
    });
};
module.exports.postActionData = (req,res)=>{
    var fId = req.body.fId;
    var urId = req.body.urId;
    //
    var draw = req.body.draw;


    //
    var total = [];
    var sql = 'CALL Proc_SelectAllActionByFunctionId(?)';
    conn.query(sql,[fId],(err,rs)=>{
        if(err)throw err;
        rs=rs[0];
        var dataList = [];
        var recordsTotal = rs.length;
        var recordsFiltered = rs.length;
        for(var i = 0;i<rs.length;i++){
            var id = rs[i].actionId;
            var name = rs[i].actionName;
            var arr_data = [id,name];
            var vad = func_validate(arr_data);
            var data = {
                "id":vad[0],
                "name":vad[1]
            };
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
        
        // var sql = "CAll Proc_SelectAllActionByFunctionId(?)";
        // conn.query(sql,[fId],(err,rsActionTable)=>{
        //     if(err)throw err;
        //     rsActionTable = rsActionTable[0];
        //     recordsTotal = rsActionTable.length;
        //     recordsFiltered = rsActionTable.length;
        //     for(var i=0;i<rsActionTable.length;i++){
        //         var actionId = rsActionTable[i].actionId;
        //         total.push(actionId);
        //     }
        //     var hasPermission = [];
        //     var sql = "SELECT actionId FROM `permission` WHERE functionId = ? and userRoleId = ?";
        //     conn.query(sql,[fId,urId],(err,rs)=>{
        //         if(err)throw err;
        //         if(rs.length>0){
        //             for(var i=0;i<rs.length;i++){
        //                 var actionId = rs[i].actionId;
        //                 hasPermission.push(actionId);
        //             }
        //             var n = total.length-hasPermission.length+1;
        //             var notHasPermission = total.slice(n);
        //             console.log(hasPermission,notHasPermission);//

                    
        //             var dataSend = {
        //                 "draw":draw,
        //                 "recordsTotal":recordsTotal,
        //                 "recordsFiltered":recordsFiltered,
        //                 "data":dataList
        //             }
        //             res.send(dataSend);
        //         }else{
                    
        //         }
        //     });
        // });
};//fix later
module.exports.postFuction = (req,res)=>{
    var sql = "SELECT * FROM `function`";
    conn.query(sql,(err,rs)=>{
        if(err)throw err;
        var dataList = [];
        for(var i = 0;i<rs.length;i++){
            var data = {
                "id":rs[i].functionId,
                "name":rs[i].functionName,
                "note":rs[i].functionNote
            }
            dataList.push(data);
        }
        res.send(dataList);
    });
};
module.exports.postDataForPermission = (req,res)=>{
    var fId = req.body.fId;
    var aId = req.body.aId;
    var urId = req.body.urId;
    conn.query( 
        "UPDATE `permission` SET isPermission = 0 WHERE functionId = ? AND userRoleId = ?",
        [fId,urId],
        (err,rs)=>{
            if(err)throw err;
        });
    for (var i=0;i<aId.length;i++){
        var id = aId[i];
        (function(id){
            conn.query( 
            "SELECT * FROM `permission` WHERE functionId = ? AND actionId = ? AND userRoleId = ?",
            [fId,id,urId],
            (err,rs)=>{
                if(err)throw err;
                if(rs.length > 0){
                    var sql = "UPDATE `permission` SET isPermission = 1 WHERE functionId = ? AND actionId = ?  AND userRoleId = ?";
                    conn.query(sql,[fId,id,urId],(err,rs)=>{
                        if(err)throw err;
                    });
                }else{
                    var sql = "INSERT INTO `permission`(functionId,actionId,userRoleId,isPermission) VALUES(?,?,?,1)";
                    conn.query(sql,[fId,id,urId],(err,rs)=>{
                        if(err)throw err;
                    });
                }
            });
        })(id);
    }
    res.send("done");
};
function func_validate(data){
    for(var i=0;i<data.length;i++){
        if(data[i] == null){data[i] = "";}
    }
    return data;
}
function func_updateRole(id,name,note){
    var sql = "CALL Proc_UpdateTableUserRoleById(?,?,?)";
    conn.query(sql,[id,name,note],(err,rs)=>{
        if(err)throw err;
    });
}
function func_data(rs,draw){
    
    return dataSend;
}
