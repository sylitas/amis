var mysql = require('mysql');
require('dotenv').config({path:".env"});

var conn = mysql.createConnection({
    host: process.env.DB_HOST,
    user: process.env.DB_USER,
    password: process.env.DB_PASS,
    database: process.env.DB
});

module.exports = conn;