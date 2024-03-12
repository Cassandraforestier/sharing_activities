const express = require('express');
const router = express.Router();
const cartController = require('./cart.controller');

// Get cart by ID
router.get('/cart/:userId', cartController.getCartById);

// add activity to cart
router.post('/cart/:cartId/activity/:activityId', cartController.addActivityToCart);

// Delete activity from cart
router.delete('/cart/:cartId/activity/:activityId', cartController.deleteActivityFromCart);

module.exports = router;
