var express = require('express');


var controller = require("../../controllers/local.controller");

var router = express.Router();
//main contact page
router.get('/',controller.getLocalPage);
router.post('/postDataForUserLocal',controller.postDataForUserLocal);
module.exports = router;
