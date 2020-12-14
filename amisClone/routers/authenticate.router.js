var express = require('express');


var controller = require("../controllers/authenticate.controller");

var router = express.Router();

router.get('/',controller.getAuthenticate);
router.post('/',controller.postAuthenticate);

module.exports = router;
