const httpStatus = {
  OK: 200,
  BAD_REQUEST: 400,
  UNAUTHORIZED: 401,
  NOT_FOUND: 404,
  SERVER: 500,
};
const { updateProfile, getDisplayName } = require("../services/user.service");

exports.updateMe = async (req, res) => {
  try {
    const userId = req.user?.userId; // lấy từ middleware auth
    if (!userId)
      return res
        .status(httpStatus.UNAUTHORIZED)
        .json({ error: "UNAUTHORIZED" });

    const updated = await updateProfile(userId, req.body || {});
    return res
      .status(httpStatus.OK)
      .json({ message: "Profile updated", user: updated });
  } catch (err) {
    return res
      .status(err.statusCode || httpStatus.SERVER)
      .json({ error: err.message || "Internal server error" });
  }
};
exports.getDisplayName = async (req, res) => {
  try {
    const userId = req.user?.userId; // lấy từ middleware auth

    if (!userId)
      return res.status(httpStatus.UNAUTHORIZED).json({ error: "UNAUTHORIZED" });

    const name = await getDisplayName(userId);
    return res.status(httpStatus.OK).json({ userName: name });
  } catch (err) {
    return res
      .status(err.statusCode || httpStatus.SERVER)
      .json({ error: err.message || "Internal server error" });
  }
};
