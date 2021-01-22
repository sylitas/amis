var express = require('express');


var controller = require("../../controllers/test.controller");

var router = express.Router();
//main contact page
router.get('/graph',controller.test_Graph);
router.post('/graph/getDataForDraw',controller.getDataForDraw);
module.exports = router;
