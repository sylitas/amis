var express = require('express');


var controller = require("../../controllers/management.controller");

var router = express.Router();

//managerment/role
router.get('/role',controller.getRole);

module.exports = router;