var express = require('express');


var controller = require("../../controllers/contact.controller");

var router = express.Router();
//main contact page
router.get('/',controller.getContactPage);
router.post('/postDataForClientTable',controller.postDataForClientTable);
router.post('/postDeleteDataFromTableClient',controller.postDeleteDataFromTableClient);
router.post('/postAddingClientInformation',controller.postAddingClientInformation);
router.post('/postDataForEdit',controller.postDataForEdit);
router.post('/postEditData',controller.postEditData);

//create page
router.get('/create',controller.getCreatePage);
module.exports = router;
