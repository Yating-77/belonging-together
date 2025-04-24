const express = require('express');
const { Pool } = require('pg');
const cors = require('cors');

const app = express();
const port = process.env.PORT || 3000;
const path = require('path');
app.use(cors());
app.use(express.json());
app.use('/image', express.static(path.join(__dirname, 'public/image')));
const pool = new Pool({
  user: 'postgres',
  host: 'autism-database.c9gms0e0w8ty.ap-southeast-2.rds.amazonaws.com',
  database: 'postgres',
  password: 'Yt139130.',
  port: 5432,
  ssl: {
    rejectUnauthorized: false
  }
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

app.get('/api/scenes', async (req, res) => {
  console.log('Request received for /api/scenes');
  try {
    const result = await pool.query(`
      SELECT id, name, display_name AS title, description AS subtitle
      FROM scenes
      ORDER BY name ASC
    `);

    console.log(`Found ${result.rows.length} scenes.`);
    
    res.json({ success: true, data: result.rows });
  } catch (error) {
    console.error('Error fetching scenes:', error);
    res.status(500).json({ success: false, error: 'Failed to fetch scenes', details: error.message });
  }
});


// Endpoint to get sensory expectations for a specific scene
app.get('/api/scenes/:id/sensory-expectations', async (req, res) => {
  const { id } = req.params;
  console.log(`Request received for sensory expectations for scene ID: ${id}`);
  try {
      // Validate ID
      const sceneId = parseInt(id, 10);
      if (isNaN(sceneId)) {
          return res.status(400).json({ success: false, error: 'Invalid scene ID provided.' });
      }

      const result = await pool.query(`
          SELECT id, category, description
          FROM scene_sensory_expectations
          WHERE scene_id = $1
          ORDER BY
              CASE category
                  WHEN 'hearing' THEN 1
                  WHEN 'sight' THEN 2
                  WHEN 'smell' THEN 3
                  WHEN 'touch' THEN 4
                  ELSE 5 -- Default order for any other categories
              END
      `, [sceneId]);

      console.log(`Found ${result.rows.length} sensory expectations for scene ID: ${sceneId}`);
      res.json({ success: true, data: result.rows });
  } catch (error) {
      console.error(`Error fetching sensory expectations for scene ID ${id}:`, error);
      res.status(500).json({ success: false, error: 'Failed to fetch sensory expectations', details: error.message });
  }
});
// Endpoint to get distinct venue types for filtering
app.get('/api/sensory-venues/types', async (req, res) => {
  console.log('Request received for /api/sensory-venues/types');
  try {
      const result = await pool.query('SELECT DISTINCT venue_type FROM sensory_venues WHERE venue_type IS NOT NULL ORDER BY venue_type ASC');
      res.json({ success: true, data: result.rows.map(row => row.venue_type) });
  } catch (error) {
      console.error('Error fetching distinct venue types:', error);
      res.status(500).json({ success: false, error: 'Failed to fetch venue types', details: error.message });
  }
});

// Endpoint to get distinct locations (simple version - might need refinement)
app.get('/api/sensory-venues/locations', async (req, res) => {
  console.log('Request received for /api/sensory-venues/locations');
  try {
      // This is basic, might return full addresses. Consider extracting suburbs later if needed.
      const result = await pool.query('SELECT DISTINCT venue_location FROM sensory_venues WHERE venue_location IS NOT NULL ORDER BY venue_location ASC');
      res.json({ success: true, data: result.rows.map(row => row.venue_location) });
  } catch (error) {
      console.error('Error fetching distinct locations:', error);
      res.status(500).json({ success: false, error: 'Failed to fetch locations', details: error.message });
  }
});

// Endpoint to get distinct sensory features/types (simple version)
app.get('/api/sensory-venues/sensory-categories', async (req, res) => {
  console.log('Request received for /api/sensory-venues/sensory-categories');
  try {
      // This fetches the raw combined text. Ideally, you'd have predefined categories.
      const result = await pool.query('SELECT DISTINCT venue_sensory_type FROM sensory_venues WHERE venue_sensory_type IS NOT NULL ORDER BY venue_sensory_type ASC');
      res.json({ success: true, data: result.rows.map(row => row.venue_sensory_type) });
  } catch (error) {
      console.error('Error fetching distinct sensory types:', error);
      res.status(500).json({ success: false, error: 'Failed to fetch sensory categories', details: error.message });
  }
});


// Main endpoint to get venues with filtering and pagination
app.get('/api/sensory-venues', async (req, res) => {
  console.log('Request received for /api/sensory-venues with query:', req.query);
  const {
      search = '',
      sensoryCategory = '',
      location = '',
      venueType = '',
      page = 1,
      limit = 6 // Number of venues per page
  } = req.query;

  const currentPage = parseInt(page, 10) || 1;
  const itemsPerPage = parseInt(limit, 10) || 6;
  const offset = (currentPage - 1) * itemsPerPage;

  let queryParams = [];
  let paramIndex = 1;
  let whereClauses = [];

  // Build WHERE clauses based on filters
  if (search) {
      whereClauses.push(`(venue_title ILIKE $${paramIndex} OR venue_description ILIKE $${paramIndex})`);
      queryParams.push(`%${search}%`);
      paramIndex++;
  }
  if (sensoryCategory) {
      // Basic search within the combined text field
      whereClauses.push(`venue_sensory_type ILIKE $${paramIndex}`);
      queryParams.push(`%${sensoryCategory}%`); // Use the exact value or parts depending on need
      paramIndex++;
  }
  if (location) {
      whereClauses.push(`venue_location ILIKE $${paramIndex}`);
      queryParams.push(`%${location}%`); // Use exact location from dropdown
      paramIndex++;
  }
  if (venueType) {
      whereClauses.push(`venue_type = $${paramIndex}`);
      queryParams.push(venueType); // Exact match for type
      paramIndex++;
  }

  const whereCondition = whereClauses.length > 0 ? `WHERE ${whereClauses.join(' AND ')}` : '';

  try {
      // Query to get the filtered and paginated venues
      const venuesQuery = `
          SELECT id, venue_title, venue_location, venue_sensory_type,
                 venue_sensory_info_link, venue_description, venue_type, image_url
          FROM sensory_venues
          ${whereCondition}
          ORDER BY venue_title ASC
          LIMIT $${paramIndex} OFFSET $${paramIndex + 1}
      `;
      const venuesResult = await pool.query(venuesQuery, [...queryParams, itemsPerPage, offset]);
      console.log(`Venue query executed. Params: ${JSON.stringify([...queryParams, itemsPerPage, offset])}. Found ${venuesResult.rows.length} venues for this page.`);

      // Query to get the total count of filtered venues (for pagination)
      const countQuery = `SELECT COUNT(*) FROM sensory_venues ${whereCondition}`;
      const countResult = await pool.query(countQuery, queryParams); // Use only filter params for count
      const totalItems = parseInt(countResult.rows[0].count, 10);
      const totalPages = Math.ceil(totalItems / itemsPerPage);
      console.log(`Total count query executed. Params: ${JSON.stringify(queryParams)}. Total matching items: ${totalItems}. Total pages: ${totalPages}`);
      // Add image path prefix (similar to scenes)
       const venuesWithImagePath = venuesResult.rows.map(venue => ({
          ...venue,
          // Construct the full URL path, use placeholder if null
          image_full_url: venue.image_url ? `/image/${venue.image_url}` : '/image/placeholder-venue.png' // Assumes a placeholder in public/image
          
      }));


      res.json({
          success: true,
          data: {
              venues: venuesWithImagePath, // Use the updated array
              totalPages: totalPages,
              currentPage: currentPage,
              totalItems: totalItems
          }
      });

  } catch (error) {
      console.error('Error fetching sensory venues:', error);
      res.status(500).json({ success: false, error: 'Failed to fetch sensory venues', details: error.message });
  }
});
// Endpoint to get checklist items for a specific scene
app.get('/api/scenes/:sceneId/checklist', async (req, res) => {
  const { sceneId } = req.params;
  console.log(`Request received for checklist for scene ID: ${sceneId}`);
  try {
    const sceneIdInt = parseInt(sceneId, 10);
    if (isNaN(sceneIdInt)) {
      return res.status(400).json({ success: false, error: 'Invalid scene ID provided.' });
    }

    const result = await pool.query(
      `SELECT id, title, description, child_reaction 
       FROM checklist_items 
       WHERE scene_id = $1 
       ORDER BY id ASC`, // Or however you want to order them
      [sceneIdInt]
    );

    console.log(`Found ${result.rows.length} checklist items for scene ID: ${sceneIdInt}`);
    res.json({ success: true, data: result.rows });
  } catch (error) {
    console.error(`Error fetching checklist items for scene ID ${sceneId}:`, error);
    res.status(500).json({ success: false, error: 'Failed to fetch checklist items', details: error.message });
  }
});

// Endpoint to get a combined list of image keywords AND image labels for a specific scene
app.get('/api/scenes/:sceneId/terms', async (req, res) => { // Renamed from /keywords to /terms
  const { sceneId } = req.params;
  console.log(`Request received for terms (keywords & labels) for scene ID: ${sceneId}`);
  try {
    const sceneIdInt = parseInt(sceneId, 10);
    if (isNaN(sceneIdInt)) {
      return res.status(400).json({ success: false, error: 'Invalid scene ID provided.' });
    }

    // SQL Query using UNION to combine keywords and labels, ensuring distinctness
    const query = `
      SELECT ik.keyword AS term -- Select keyword, alias as 'term'
      FROM image_keywords ik
      JOIN checklist_items ci ON ik.checklist_item_id = ci.id
      WHERE ci.scene_id = $1
      
      UNION -- Combine results and automatically make them distinct
      
      SELECT il.image_label AS term -- Select image_label, alias as 'term'
      FROM image_labels il
      JOIN checklist_items ci ON il.checklist_item_id = ci.id
      WHERE ci.scene_id = $1
    `;

    const result = await pool.query(query, [sceneIdInt]);

    // Extract just the terms into an array of lowercase strings
    // The 'term' alias makes this easy
    const terms = result.rows.map(row => row.term.toLowerCase()); 

    console.log(`Found ${terms.length} distinct terms (keywords & labels) for scene ID: ${sceneIdInt}`);
    // Send the combined list
    res.json({ success: true, data: terms }); 

  } catch (error) {
    console.error(`Error fetching terms for scene ID ${sceneId}:`, error);
    res.status(500).json({ success: false, error: 'Failed to fetch terms', details: error.message });
  }
});


app.listen(port, '0.0.0.0', () => {
  console.log(`Server running on http://localhost:${port}`);
  console.log(`API available at http://localhost:${port}/api/`);
});