/*
English :
port is the gate for running local/non-local things
post is a way to send data/values throw

MVC: 
- models contain routers and middlewares
- views--> should be view + "s" because pug render using it
- controllers

Author:         duynt
Objective:      Create management api (focusing on role and grant permision)
Description:    Using express

.env contains private key
*/
//require modules

require('dotenv').config({path:".env"});
var express = require('express');
var bodyParser = require('body-parser');
var cookieParser = require('cookie-parser');
var pug = require('pug');
//require routers
const authenticateRouter = require("./models/routers/authenticate.router");
const dashboardRouter = require("./models/routers/dashboard.router");
const roleRouter = require("./models/routers/role.router");
const contactRouter = require("./models/routers/contact.router");
const testRouter = require("./models/routers/test.router");
const clientRouter = require("./models/routers/client.router");
const LDAPRouter = require("./models/routers/LDAP.router");

var app = express();
var port = 1999;
//body-parser config
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));
//pug config
app.set('view engine', 'pug');
app.set("views","./views");
//static file (css,jvs,scss,...)
app.use(express.static('public'));
//cookie perser config
app.use(cookieParser(process.env.KEY));//change later
// '/'--->authenticate.router.js--->authenticate.controller.js
//For login, authen with cookies, JWT
app.use('/',authenticateRouter);
// '/dashboard'--->dashboard.router.js--->dashboard.controller.js
//Dashboard API is main site(do later)
app.use('/dashboard',dashboardRouter);
// '/management/role'--->management.router.js--->management.controller.js
// Management is a site that contain everything with manage. Role API is one of them 
app.use('/management/role',roleRouter);
// for LDAP
app.use('/management/LDAP',LDAPRouter);
//'/contact -->contact.router.js------>contact.controller.js
// Contact contain all the information of personal client and company client
app.use('/contact',contactRouter);
//for testing
app.use('/test',testRouter);
// client is the same with contact -------------//do it later
app.use('/client',clientRouter);
// for logout
app.use('/logout',(req,res)=>{
    res.clearCookie("auth_token");
    res.redirect('/');
});

app.use(function(req, res){
    res.render('404');   
});

app.listen(port,()=>{console.log("Compile complete on port "+port);});
