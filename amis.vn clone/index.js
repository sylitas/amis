var express = require('express');
var bodyParser = require('body-parser');

var contactRoute = require('./routers/contact.route');



var app = express();
var port = 1999;

app.use(express.static('public'));
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));

app.use("/contact",contactRoute);

app.listen(port,function(){
    console.log("I live in "+port+" street, come and visit me!");
});