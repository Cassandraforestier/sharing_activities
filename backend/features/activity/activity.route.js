const express = require("express");
const router = express.Router();
const activityController = require("./activity.controller");

// Route pour obtenir toutes les activités
router.get("/activities", activityController.getAllActivities);

// Route pour obtenir les détails d'une activité par ID
router.get("/activities/:activityId", activityController.getActivityById);

// Route pour filtrer les activités par catégorie
router.get(
  "/activities/category/:category",
  activityController.getActivitiesByCategory
);

module.exports = router;
