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
var cookieParser = require('cookie-parser');
var pug = require('pug');
//require routers
var authenticateRouter = require("./models/routers/authenticate.router");
var dashboardRouter = require("./models/routers/dashboard.router");
var managementRouter = require("./models/routers/management.router");

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
//cookie perser config
app.use(cookieParser('privatekey'));//change later

app.use('/',authenticateRouter);
app.use('/dashboard',dashboardRouter);
app.use('/management/role',managementRouter);
app.use('/logout',(req,res)=>{
    res.clearCookie("auth_token");
    res.redirect('/');
});

// app.use(function(req, res){
//     res.render('404');   
// });

app.listen(port,()=>{console.log("Compile complete on "+port);});
