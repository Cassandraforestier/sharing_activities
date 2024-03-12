const mongoose = require('mongoose');

const activitySchema = new mongoose.Schema({
    title: { type: String, required: true },
    location: { type: String, required: true },
    price: { type: Number, required: true },
    imageUrl: { type: String },
    category: { type: String, required: true },
    minPeople: { type: Number, required: true },
});

const Activity = mongoose.model('Activity', activitySchema);

module.exports = Activity;
