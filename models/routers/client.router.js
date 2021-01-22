var express = require('express');


var controller = require("../../controllers/client.controller");

var router = express.Router();
//main contact page
router.get('/',controller.getClientPage);
module.exports = router;
