var jwt = require("jsonwebtoken");
var conn = require("../database/main.database");

function decode(token,key){
    return  jwt.verify(token,key,(err,decoded)=>{
        if(err) throw err;
        return decoded.data;
    });
};
function func_noPer(number){
    for(var i=0;i<number.length;i++){
        if(number[i] == 1){var f_use    = true;}
        if(number[i] == 2){var f_add    = true;}
        if(number[i] == 3){var f_edit   = true;}
        if(number[i] == 4){var f_delete = true;}
        if(number[i] == 5){var f_export = true;}
    }
    var data = {
        "use":f_use,
        "add":f_add,
        "edit":f_edit,
        "del":f_delete,
        "exp":f_export
    }
    return data;
};
function func_validate(data){
    for(var i=0;i<data.length;i++){
        if(data[i] == null){data[i] = "-";}
    }
    return data;
};
function func_validate_for_query(data){
    for(var i=0;i<data.length;i++){
        if(!data[i]){data[i] = null;}
    }
    return data;
};
function func_validate_for_edit(data){
    for(var i=0;i<data.length;i++){
        if(data[i] == null){data[i] = "";}
    }
    return data;
};
function func_checkObjectExist(email,callback){
    var sql = "SELECT * FROM `object` WHERE `companyEmail` = ?";
    conn.query(sql,[email],(err,rs)=>{
        if(err) throw err;
        if(rs.length>0){
            callback(false);
        }else{
            callback(true);
        }
    })
};
function func_updateRole(id,name,note){
    var sql = "CALL Proc_UpdateTableUserRoleById(?,?,?)";
    conn.query(sql,[id,name,note],(err,rs)=>{
        if(err)throw err;
    });
};


module.exports = {
    decode,
    func_noPer,
    func_validate,
    func_validate_for_query,
    func_checkObjectExist,
    func_updateRole,
    func_validate_for_edit
}
