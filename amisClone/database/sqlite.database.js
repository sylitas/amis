var sqlite3 = require('sqlite3').verbose();
let db = new sqlite3.Database('./database/cookie.db',(err)=>{
    if(err) throw err;
});


module.exports = db;