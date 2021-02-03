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
router.get('/getExport',controller.getExport);
//create page
router.get('/create',controller.getCreatePage);
//edit page
router.get('/edit',controller.getEditPage);
module.exports = router;
