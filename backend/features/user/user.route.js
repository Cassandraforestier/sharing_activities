const express = require("express");
const router = express.Router();
const {
  getUser,
  updateUser,
  deleteUser,
  getUserByName,
  loginUser,
} = require("./user.controller");

// Public route - GET user
// router.get('/user/:id', getUser);

// Public route - GET user
router.get("/user/:name", getUserByName);

// Private route - UPDATE user
router.put("/user/:id", updateUser);

// Private route - DELETE user
router.delete("/user/:id", deleteUser);

//login route
router.post("/login", loginUser);

module.exports = router;
