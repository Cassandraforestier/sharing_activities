const express = require('express');
const router = express.Router();
const cartController = require('./cart.controller');

router.get('/cart/:userId', cartController.getCartById);

router.post('/cart/:cartId/activity/:activityId', cartController.addActivityToCart);

router.delete('/cart/:cartId/activity/:activityId', cartController.deleteActivityFromCart);

module.exports = router;
