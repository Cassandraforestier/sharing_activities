const express = require("express");
const router = express.Router();
const activityController = require("./activity.controller");

router.get("/activities", activityController.getAllActivities);

router.get("/activities/:activityId", activityController.getActivityById);

router.get(
  "/activities/category/:category",
  activityController.getActivitiesByCategory
);

module.exports = router;
