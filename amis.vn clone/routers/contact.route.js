var express = require('express');
var controller = require('../controllers/contact.controller');
var router = express.Router();

router.get('/',controller.getContact);

module.exports = router;