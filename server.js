require('dotenv').config();

const express = require('express');
const mysql = require('mysql2');
const bodyParser = require('body-parser');
const { exec } = require('child_process');

const app = express();
const port = process.env.PORT || 3002;

// Create MySQL connection
const connection = mysql.createConnection({
  host: process.env.HOST,
  user: process.env.USER,
  password: process.env.PASSWORD,
  database: process.env.DB
});

connection.connect(err => {
  if (err) {
    console.error('Error connecting to MySQL: ' + err.stack);
    return;
  }
  console.log('Connected to MySQL as id ' + connection.threadId);
});

// Middleware to parse JSON
app.use(bodyParser.json());

app.post('/add-domain', (req, res) => {
  const { domain } = req.body;

  // Execute MySQL query
  connection.query('INSERT INTO domains (domain_name) VALUES (?)', [domain], (err, results) => {
    if (err) {
      console.error(err);
      return res.status(500).json({ error: 'Failed to add domain to MySQL' });
    }

    // Execute shell command
    const shellCommand = `sudo sh -c 'cd add_domain/ && ./add_dom.sh ${domain}'`;
    exec(shellCommand, (execError, stdout, stderr) => {
      if (execError) {
        console.error(execError);
        return res.status(500).json({ error: 'Failed to execute shell command' });
      }

      console.log(stdout);
      console.error(stderr);

      res.json({ success: true, message: 'Domain added successfully' });
    });
  });
});


// Start the server
app.listen(port, () => {
  console.log(`Server is running on port ${port}`);
});

