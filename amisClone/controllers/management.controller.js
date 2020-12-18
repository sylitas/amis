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
        var sql = "INSERT INTO `userRole`(userRoleName,userRoleNote) VALUES(?,?)";
        conn.query(sql,[role,note],(err,rs)=>{
            if(err)throw err;
            res.send("Added!");
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
function func_validate(data){
    for(var i=0;i<data.length;i++){
        if(data[i] == null){data[i] = "";}
    }
    return data;
}