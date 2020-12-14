var express = require('express');


var controller = require("../controllers/dashboard.controller");

var router = express.Router();

router.get('/',controller.getDashboard);

module.exports = router;