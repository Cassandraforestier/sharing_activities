const mongoose = require('mongoose');

const cartSchema = new mongoose.Schema({
    userId: { ref: 'User', type: mongoose.Schema.Types.ObjectId, required: true },
    activityList: [{ ref: 'Activity', type: mongoose.Schema.Types.ObjectId, required: true }],
    totalPrice: { type: Number, required: true },
});

const Cart = mongoose.model('Cart', cartSchema);

module.exports = Cart;
