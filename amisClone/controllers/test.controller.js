const conn = require("../database/main.database");

module.exports.test_Graph = (req,res)=>{
    res.render("graph");
};
module.exports.getDataForDraw = (req,res)=>{
    conn.query("SELECT count(userId) AS lengthX FROM `user` ",(err,rs)=>{
        if(err) throw err;
        var length1 = rs[0].lengthX;
        conn.query("SELECT count(objectId) AS lengthY FROM `object`",(err,rs)=>{
            if(err) throw err;
            var length2 = rs[0].lengthY;
            var data = [length1,length2];
            var labels = ["user","object"];
            var dataSend = {
                "labels":labels,
                "data":data
            }
            res.send(dataSend);
        });
    });
}