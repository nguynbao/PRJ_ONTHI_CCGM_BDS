const mongoose = require('mongoose');

const connection = mongoose.createConnection('mongodb://127.0.0.1:27017').on('open', () => {
    // eslint-disable-next-line no-console
    console.log('Connected to MongoDB');
}).on('error', (error) => {
    // eslint-disable-next-line no-console
    console.error('MongoDB connection error:', error);
});

module.exports = connection;

