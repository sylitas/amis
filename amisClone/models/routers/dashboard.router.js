var express = require('express');


var controller = require("../../controllers/dashboard.controller");

var router = express.Router();
//dashboard
router.get('/',controller.getDashboard);

module.exports = router;