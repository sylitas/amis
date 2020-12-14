/*
English :
port is the gate for running local/non-local things
post is a way to send data/values throw
*/

var express = require('express');




var port = 3000;
var app = express();

app.get('/',function(req,res){
    res.send("Hello World");
});

app.listen(port,()=>{
    console.log("This project's port is "+port);
});
