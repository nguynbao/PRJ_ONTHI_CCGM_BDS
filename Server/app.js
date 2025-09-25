const express = require('express');
const app = express();

app.use(express.json()); // nhớ có middleware này để đọc req.body
app.use('/api', require('./Router')); // gom router

// error handler tối thiểu
app.use((err, req, res, next) => {
    console.error(err);
    res.status(500).json({ error: 'Internal error' });
});

module.exports = app;
