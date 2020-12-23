var express = require('express');

var controller = require("../../controllers/management.controller");

var router = express.Router();

//managerment/role
router.get('/',controller.getRole);
//data for the 'tableRole' datatable 
router.post('/postDataByAjax',controller.postRole);
//data for the 'tableContained' datatable
router.post('/postUserInRoleByAjax',controller.postUserInRole);
//For adding a new role in database
router.post('/addNewRole',controller.postAddNewRole);
//For deleting a role in database
router.post('/deleteRole',controller.postDeleteRole);
//Get values by ID for editing
router.post('/takeValueForEditRole',controller.takeValueForEditRole);
//For Editing Role in Database
router.post('/postEditRole',controller.postEditRole);
//For query data from database to table (GRANT)
router.post('/postUserDataByAjax',controller.postUserDataByAjax);
//For grant User to role
router.post('/postDataForAddingUser',controller.postDataForAddingUser);
//For delete user in role
router.post('/postDeleteUserInRole',controller.postDeleteUserInRole);
//For Take Data from data to table
router.post('/postActionData',controller.postActionData);
//For function
router.post('/postFuction',controller.postFuction);

module.exports = router;