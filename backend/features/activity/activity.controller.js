const Activity = require("./activity.model");

const getAllActivities = async (req, res) => {
  try {
    const activities = await Activity.find();
    res.status(200).json(activities);
  } catch (error) {
    res.status(500).json({ message: "Internal server error" });
  }
};

const getActivitiesByCategory = async (req, res) => {
  try {
    if (req.params.category === "toutes") {
      const activities = await Activity.find();
      if (activities.length === 0) {
        return res.status(404).json({ message: "No activities found" });
      }
      return res.status(200).json(activities);
    } else {
      const activities = await Activity.find({ category: req.params.category });
      return res.status(200).json(activities);
    }
  } catch (error) {
    res.status(500).json({ message: "Internal server error" });
  }
};

const getActivityById = async (req, res) => {
  try {
    const activity = await Activity.findById(req.params.activityId);
    if (!activity) {
      return res.status(404).json({ message: "Activity not found" });
    }
    res.status(200).json(activity);
  } catch (error) {
    res.status(500).json({ message: "Internal server error" });
  }
};

module.exports = {
  getAllActivities,
  getActivitiesByCategory,
  getActivityById,
};
