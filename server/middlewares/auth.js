const { verifyToken } = require('../services/auth.service');

module.exports = function auth(req, res, next) {
  try {
    const raw = req.headers.authorization || '';
    const token = raw.startsWith('Bearer ') ? raw.slice(7) : raw;
    if (!token) return res.status(401).json({ error: 'UNAUTHORIZED' });
    const payload = verifyToken(token);
    req.user = payload; // { id, email, userId, provider }
    next();
  } catch (e) {
    return res.status(401).json({ error: 'UNAUTHORIZED' });
  }
};
