/*
English :
port is the gate for running local/non-local things
post is a way to send data/values throw

MVC: 
- models
- views--> should be view + "s" because pug render using it
- controllers
*/
//require modules
var express = require('express');
var bodyParser = require('body-parser');
var pug = require('pug');
//require routers
var authenticateRouter = require("./routers/authenticate.router");


var app = express();

var port = 3000;
//body-parser config
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));
//pug config
app.set('view engine', 'pug');
app.set("views","./views");
//static file (css,jvs,scss,...)
app.use(express.static('public'));

app.use('/',authenticateRouter);

app.listen(port,()=>{
    console.log("Successful on "+port);
});
