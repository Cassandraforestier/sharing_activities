const express = require("express");
const router = express.Router();
const {
  getUser,
  updateUser,
  deleteUser,
  getUserByName,
  loginUser,
} = require("./user.controller");

router.get("/user/:name", getUserByName);

router.put("/user/:id", updateUser);

router.delete("/user/:id", deleteUser);

router.post("/login", loginUser);

module.exports = router;
