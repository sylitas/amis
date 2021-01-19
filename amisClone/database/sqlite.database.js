var sqlite3 = require('sqlite3').verbose();
let db = new sqlite3.Database('./database/amis.db',(err)=>{
    if(err) throw err;
});

//db.run("DROP TABLE cookies");
//db.run("DROP TABLE ldap");
//db.run("CREATE TABLE cookies(id INTEGER PRIMARY KEY AUTOINCREMENT,userId INTERGER,cookie TEXT)");
//db.run("CREATE TABLE ldap(id INTEGER PRIMARY KEY AUTOINCREMENT,  ip TEXT, baseDN TEXT, username TEXT, password TEXT)");

module.exports = db;