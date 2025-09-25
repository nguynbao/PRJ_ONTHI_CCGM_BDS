const bcrypt = require('bcrypt');
const { AuthUser } = require('../Model');

async function register(email, password) {
    const existing = await AuthUser.findOne({ email });
    if (existing) throw new Error('EMAIL_EXISTS');

    const passwordHash = password ? await bcrypt.hash(password, 10) : undefined;
    const user = await AuthUser.create({ email, passwordHash, isActive: true });
    return { id: user._id, email: user.email };
}
async function login(email, password) {
    const user = await AuthUser.findOne({ email });
    if (!user || !user.passwordHash) throw new Error('INVALID_CREDENTIALS');

    const ok = await bcrypt.compare(password, user.passwordHash);
    if (!ok) throw new Error('INVALID_CREDENTIALS');


    return { id: user._id, email: user.email };
}

module.exports = { register, login };