const express = require('express');
const { Pool } = require('pg');
const cors = require('cors');

const app = express();
app.use(cors());
app.use(express.json());

const pool = new Pool({
  user: 'postgres',   
  host: 'localhost',
  database: 'postgres',
  password: '12345678',
  port: 5432,
});

pool.connect()
  .then(() => console.log('Connected to PostgreSQL database'))
  .catch((err) => console.error('Connection error', err.stack));

app.get('/api/recommendations/:optionId', async (req, res) => {
  const { optionId } = req.params;

  console.log(`Received recommendation request for option ID: ${optionId}`);

  try {
    // Ensure valid option ID
    if (!optionId || isNaN(parseInt(optionId))) {
      return res.status(400).json({ error: 'Invalid option ID' });
    }

    const result = await pool.query(
      'SELECT title, content, example, display_order FROM recommendations WHERE option_id = $1 ORDER BY display_order',
      [optionId]
    );

    console.log(`Option ID ${optionId} returned ${result.rows.length} recommendations`);

    // If no data found, return appropriate message
    if (result.rows.length === 0) {
      console.warn(`No recommendations found for option ID ${optionId}`);
    }

    res.json(result.rows);
  } catch (error) {
    console.error('Error fetching recommendations:', error);
    res.status(500).json({ error: 'Internal server error', details: error.message });
  }
});

// Add an endpoint to get all options
app.get('/api/options/:categoryId', async (req, res) => {
  const { categoryId } = req.params;
  
  console.log(`Received options request for category ID: ${categoryId}`);

  try {
    const result = await pool.query(
      'SELECT id, text as label, display_order FROM options WHERE question_id = (SELECT id FROM questions WHERE category_id = $1) ORDER BY display_order',
      [categoryId]
    );

    console.log(`Category ID ${categoryId} returned ${result.rows.length} options`);
    
    res.json(result.rows);
  } catch (error) {
    console.error('Error fetching options:', error);
    res.status(500).json({ error: 'Internal server error', details: error.message });
  }
});

// Get all categories
app.get('/api/categories', async (req, res) => {
  console.log('Received request to get all categories');

  try {
    const result = await pool.query(
      'SELECT id, title, display_order FROM categories ORDER BY display_order'
    );

    console.log(`Returned ${result.rows.length} categories`);
    
    res.json(result.rows);
  } catch (error) {
    console.error('Error fetching categories:', error);
    res.status(500).json({ error: 'Internal server error', details: error.message });
  }
});

// Get questions by category ID
app.get('/api/questions/:categoryId', async (req, res) => {
  const { categoryId } = req.params;
  
  console.log(`Received questions request for category ID: ${categoryId}`);

  try {
    const result = await pool.query(
      'SELECT id, question_text as text, category_id, display_order FROM questions WHERE category_id = $1 ORDER BY display_order',
      [categoryId]
    );

    console.log(`Category ID ${categoryId} returned ${result.rows.length} questions`);
    
    res.json(result.rows);
  } catch (error) {
    console.error('Error fetching questions:', error);
    res.status(500).json({ error: 'Internal server error', details: error.message });
  }
});

const PORT = process.env.PORT || 3001;
app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
  console.log(`API available at http://localhost:${PORT}/api/`);
});
