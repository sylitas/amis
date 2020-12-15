var express = require('express');


var controller = require("../controllers/dashboard-admin.controller");

var router = express.Router();

router.get('/',controller.getDashboard_admin);

module.exports = router;