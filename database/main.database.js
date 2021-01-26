var mysql = require('mysql');
require('dotenv').config({path:".env"});

var conn = mysql.createConnection({
    host: process.env.DB_HOST,
    user: process.env.DB_USER,
    password: process.env.DB_PASS,
    database: process.env.DB
});

// conn.query("TRUNCATE TABLE `object`",(err)=>{if(err) throw err;})
// conn.query("TRUNCATE TABLE `city`",(err)=>{if(err) throw err;})
// conn.query("TRUNCATE TABLE `district`",(err)=>{if(err) throw err;})
// conn.query("TRUNCATE TABLE `location`",(err)=>{if(err) throw err;})
module.exports = conn;