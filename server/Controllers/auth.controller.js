const httpStatus = { OK:200, CREATED:201, BAD_REQUEST:400, UNAUTHORIZED:401, CONFLICT:409, SERVER:500 };
const authService = require('../services/auth.service');

exports.register = async (req, res) => {
  try {
    const { email, password } = req.body || {};
    const data = await authService.register(email, password);
    return res.status(httpStatus.CREATED).json({
      message: 'Registered. Please login to get token.',
      data
    });
  } catch (err) {
    const code = err.statusCode || httpStatus.SERVER;
    const msg =
      err.message === 'EMAIL_EXISTS' ? 'Email already in use.' :
      err.message === 'EMAIL_PASSWORD_REQUIRED' ? 'Email and password are required.' :
      'Internal server error.';
    return res.status(code).json({ error: msg });
  }
};

exports.login = async (req, res) => {
  try {
    const { email, password } = req.body || {};
    const { token, user } = await authService.login(email, password);
    return res.status(httpStatus.OK).json({ token, user });
  } catch (err) {
    const code = err.statusCode || httpStatus.SERVER;
    const msg = err.message === 'INVALID_CREDENTIALS' ? 'Invalid email or password.' : 'Internal server error.';
    return res.status(code).json({ error: msg });
  }
};
