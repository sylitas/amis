var express = require('express');


var controller = require("../../controllers/management.controller");

var router = express.Router();

//managerment/role
router.get('/',controller.getRole);
router.post('/postDataByAjax',controller.postRole);
router.post('/postUserInRoleByAjax',controller.postUserInRole);
module.exports = router;