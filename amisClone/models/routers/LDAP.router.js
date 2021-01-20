var express = require('express');


var controller = require("../../controllers/LDAP.controller");

var router = express.Router();
//main contact page
router.get('/',controller.getAuthLDAPPage);
router.post('/postAuthLDAPPage',controller.postAuthLDAPPage);
router.post('/postDataForLDAPuser',controller.postDataForLDAPuser);
router.post('/syncDataToDatabase',controller.syncDataToDatabase);
module.exports = router;
