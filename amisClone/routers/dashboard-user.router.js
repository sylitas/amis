var express = require('express');


var controller = require("../controllers/dashboard-user.controller");

var router = express.Router();

router.get('/',controller.getDashboard_user);

module.exports = router;