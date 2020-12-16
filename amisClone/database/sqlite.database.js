var sqlite3 = require('sqlite3').verbose();
let db = new sqlite3.Database('./database/cookie.db',(err)=>{
    if(err) throw err;
});

//db.run("DROP TABLE cookies");
//db.run("CREATE TABLE cookies(id INTEGER PRIMARY KEY AUTOINCREMENT,userId INTERGER,cookie TEXT)");

module.exports = db;