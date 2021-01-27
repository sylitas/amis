const conn = require("../database/main.database");

module.exports.getLocalPage = (req,res)=>{
    res.render("local");
};

module.exports.postDataForUserLocal = (req,res)=>{
    var dataList = [];
    var draw = req.body.draw;
    var length = req.body.length;
    var start = req.body.start;
    var recordsTotal; 
    var recordsFiltered;
    var searchStr = req.body.search.value;
    conn.query("SELECT * FROM `user` WHERE isLocal = 1",(err,rs)=>{
        if(err) throw err;
        recordsTotal = rs.length;
        recordsFiltered = rs.length;
        conn.query('SELECT * FROM `user` WHERE isLocal = 1 LIKE "%'+searchStr+'%" LIMIT '+length+' OFFSET '+start,(err,rs)=>{
            if(err) throw err; 
            recordsFiltered = rs.length;
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
}