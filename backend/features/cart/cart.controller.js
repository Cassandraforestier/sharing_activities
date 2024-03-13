const Cart = require('./cart.model');

const getCartById = async (req, res) => {
    try {
        const userId = req.params.userId;

        const cart = await Cart.findOne({ userId })
            .populate('activityList');
        if (!cart) {
            const newCart = new Cart({
                userId,
                activityList: [],
                totalPrice: 0,
            });
            const savedCart = await newCart.save();
            return res.status(200).json(savedCart);
        }
        const total = cart.activityList.reduce((acc, activity) => {
            return acc + activity.price;
        }, 0);

        cart.totalPrice = total;

        res.status(200).json(cart);
    } catch (error) {
        res.status(500).json({ message: 'Internal server error', error: error.message });
    }
};

const addActivityToCart = async (req, res) => {
    try {
        const cart = await Cart.findById(req.params.cartId);
        if (!cart) {
            return res.status(404).json({ message: 'Cart not found' });
        }
        if (cart.activityList.includes(req.params.activityId)) {
            return res.status(400).json({ message: 'Activity already in the cart' });
        }
        cart.activityList.push(req.params.activityId);
        await cart.save();
        res.status(200).json({ message: 'Activity added to the cart' });
    } catch (error) {
        res.status(500).json({ message: 'Internal server error' });
    }
};

const deleteActivityFromCart = async (req, res) => {
    try {
        const cart = await Cart.findById(req.params.cartId);
        if (!cart) {
            return res.status(404).json({ message: 'Cart not found' });
        }
        const activityIndex = cart.activityList.indexOf(req.params.activityId);
        if (activityIndex === -1) {
            return res.status(404).json({ message: 'Activity not found in the cart' });
        }
        cart.activityList.splice(activityIndex, 1);
        await cart.save();
        res.status(200).json({ message: 'Activity removed from the cart' });
    } catch (error) {
        res.status(500).json({ message: 'Internal server error' });
    }
};

module.exports = {
    deleteActivityFromCart,
    getCartById,
    addActivityToCart
};
