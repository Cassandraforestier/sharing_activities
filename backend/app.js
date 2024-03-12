require('dotenv').config();
const express = require("express");
const app = express();
const mongoose = require("mongoose");
const userRoutes = require("./features/user/user.route");
const activiyRoutes = require("./features/activity/activity.route");
const cartRoutes = require("./features/cart/cart.route");
const morgan = require("morgan");
const cors = require("cors");

main().catch((err) => console.log(err));

async function main() {
  await mongoose.connect(
    process.env.MONGO_URL
  );
}

app.use(morgan("dev"));
app.use(cors());
app.use(express.json());
app.use(express.urlencoded({ extended: true }));
app.use('/images', express.static('uploads'));
app.use("/api", userRoutes);
app.use("/api", activiyRoutes);
app.use("/api", cartRoutes);

const port = process.env.PORT || 3000;

app.listen(port, () => {
  console.log(`Server is running on port ${port}`);
});
