const express = require('express');
const { Pool } = require('pg');
const cors = require('cors');

const app = express();
const port = process.env.PORT || 3000;

app.use(cors());
app.use(express.json());

const pool = new Pool({
  user: 'postgres',     
  host: 'localhost',    
  database: 'postgres',  
  password: '111111',    
  port: 5432,           
});

pool.connect()
  .then(() => console.log('Connected to PostgreSQL database'))
  .catch((err) => console.error('Connection error', err.stack));



app.get('/api/articles', async (req, res) => {
  try {
    const result = await pool.query(`
      SELECT 
        id, 
        title, 
        substring(content, 1, 150) as content, 
        created_at,
        view_count
      FROM articles 
      ORDER BY created_at DESC
    `);
    
    res.json({ success: true, data: result.rows });
  } catch (error) {
    console.error('Error getting article list:', error);
    res.status(500).json({ success: false, error: error.message });
  }
});

app.get('/api/articles/popular', async (req, res) => {
  try {
    const limit = 4; 
    const result = await pool.query(`
      SELECT 
        id, 
        title, 
        substring(content, 1, 150) as content, 
        created_at,
        view_count
      FROM articles 
      ORDER BY view_count DESC
      LIMIT $1
    `, [limit]);
    
    console.log('Found popular articles:', result.rows.length);
    res.json({ success: true, data: result.rows });
  } catch (error) {
    console.error('Error getting popular articles:', error);
    res.status(500).json({ success: false, error: error.message });
  }
});
app.get('/api/articles/search', async (req, res) => {
  try {
    const keyword = req.query.keyword || '';
    console.log('Search keyword:', keyword);
    
    const result = await pool.query(
      'SELECT id, title, substring(content, 1, 150) as content, created_at, view_count FROM articles WHERE title ILIKE $1 OR content ILIKE $1 ORDER BY created_at DESC',
      [`%${keyword}%`]
    );
    
    console.log(`Found ${result.rows.length} search results`);
    res.json({ 
      success: true, 
      data: result.rows 
    });
  } catch (error) {
    console.error('Error searching articles:', error);
    res.status(500).json({ success: false, error: error.message });
  }
});

app.post('/api/articles/:id/view', async (req, res) => {
  try {
    const articleId = req.params.id;
    await pool.query(
      'UPDATE articles SET view_count = view_count + 1 WHERE id = $1',
      [articleId]
    );
    
    res.json({ success: true });
  } catch (error) {
    console.error('Error updating article view count:', error);
    res.status(500).json({ success: false, error: error.message });
  }
});

app.get('/api/test-search', async (req, res) => {
  try {
    const keyword = req.query.keyword || '';
    console.log('Test search keyword:', keyword);
    
    const result = await pool.query('SELECT * FROM articles');
    
    const filteredResults = result.rows.filter(article => 
      article.title.toLowerCase().includes(keyword.toLowerCase()) || 
      article.content.toLowerCase().includes(keyword.toLowerCase())
    );
    
    res.json({
      success: true,
      data: filteredResults,
      message: 'This is the test route result'
    });
  } catch (error) {
    console.error('Test search error:', error);
    res.status(500).json({ success: false, error: error.message, stack: error.stack });
  }
});
app.get('/api/articles/:id', async (req, res) => {
  try {
    const articleId = req.params.id;
    const result = await pool.query(
      'SELECT * FROM articles WHERE id = $1',
      [articleId]
    );
    
    if (result.rows.length === 0) {
      return res.status(404).json({ success: false, error: 'Article not found' });
    }
    
    res.json({ success: true, data: result.rows[0] });
  } catch (error) {
    console.error('Error getting article details:', error);
    res.status(500).json({ success: false, error: error.message });
  }
});


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

app.get('/api/options/:categoryId', async (req, res) => {
  const { categoryId } = req.params;
  
  console.log(`Received options request for category ID: ${categoryId}`);
  
  try {
    const result = await pool.query(
      'SELECT id, text as label, display_order FROM options WHERE question_id IN (SELECT id FROM questions WHERE category_id = $1) ORDER BY display_order',
      [categoryId]
    );
    
    console.log(`Category ID ${categoryId} returned ${result.rows.length} options`);
    
    res.json(result.rows);
  } catch (error) {
    console.error('Error fetching options:', error);
    res.status(500).json({ error: 'Internal server error', details: error.message });
  }
});

app.get('/api/recommendations/:optionId', async (req, res) => {
  const { optionId } = req.params;
  
  console.log(`Received recommendation request for option ID: ${optionId}`);
  
  try {

    if (!optionId || isNaN(parseInt(optionId))) {
      return res.status(400).json({ error: 'Invalid option ID' });
    }
    
    const result = await pool.query(
      'SELECT title, content, example, display_order FROM recommendations WHERE option_id = $1 ORDER BY display_order',
      [optionId]
    );
    
    console.log(`Option ID ${optionId} returned ${result.rows.length} recommendations`);
    
    if (result.rows.length === 0) {
      console.warn(`No recommendations found for option ID ${optionId}`);
    }
    
    res.json(result.rows);
  } catch (error) {
    console.error('Error fetching recommendations:', error);
    res.status(500).json({ error: 'Internal server error', details: error.message });
  }
});

app.listen(port, () => {
  console.log(`Server running on http://localhost:${port}`);
  console.log(`API available at http://localhost:${port}/api/`);
});