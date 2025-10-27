const httpStatus = { OK: 200, CREATED: 201, BAD: 400, UNAUTHORIZED: 401, server: 500 };
const authService = require('../services/auth.service');
const jwt = require('jsonwebtoken');

exports.register = async (req, res) => {
    try {
        const { email, password } = req.body || {};
        const data = await authService.register(email, password);
        return res.status(httpStatus.CREATED).json({ message: 'registered', data });
    } catch (err) {
        if (err.message === 'EMAIL_EXISTS') {
            return res.status(httpStatus.BAD).json({ error: 'Email already in use' });
        }
        return res.status(httpStatus.server).json({ error: 'Internal error' });
    }
};

exports.login = async (req, res) => {
    try {
        const { email, password } = req.body || {};
        const payload = await authService.login(email, password);
        const secret = process.env.JWT_SECRET || 'dev-secret-change-me';
        const token = jwt.sign(payload, secret, { expiresIn: '7d' });
        return res.status(httpStatus.OK).json({ token, user: payload });
    } catch (err) {
        const code = err.message === 'INVALID_CREDENTIALS' ? httpStatus.UNAUTHORIZED : httpStatus.server;
        return res.status(code).json({ error: 'Login failed' });
    }
};
