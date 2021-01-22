var express = require('express');


var controller = require("../../controllers/authenticate.controller");
var middleware = require("../middlewares/authenticate.middleware");

var router = express.Router();

router.get('/',controller.getAuthenticate);
router.post('/',middleware.authenticate,controller.postAuthenticate);

module.exports = router;
