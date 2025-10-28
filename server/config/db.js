const mongoose = require('mongoose');

const MONGO_URI = process.env.MONGO_URI || 'mongodb://127.0.0.1:27017/ccgm_bds';

mongoose.set('strictQuery', true);
mongoose.set('autoCreate', true);

mongoose.connect(MONGO_URI, {
    autoIndex: true
}).then(() => {
    // eslint-disable-next-line no-console
    console.log('Connected to MongoDB');
}).catch((error) => {
    // eslint-disable-next-line no-console
    console.error('MongoDB connection error:', error);
});

module.exports = mongoose;

