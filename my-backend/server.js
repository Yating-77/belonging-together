/*
 * This is a RESTful API server that provides articles, recommendations, and chart data for autism support.
 * Main features include article management, recommendation system, and chart data endpoints.
 */

const express = require('express');
const { Pool } = require('pg');
const cors = require('cors');
const path = require('path');

const app = express();
const port = process.env.PORT || 3000;

app.use(cors());
app.use(express.json());
app.use('/image', express.static(path.join(__dirname, 'public/image'))); // Serve static image resources

// Configure PostgreSQL connect to RDS
const pool = new Pool({
  user: 'postgres',
  host: 'autism-database.c9gms0e0w8ty.ap-southeast-2.rds.amazonaws.com',
  database: 'postgres',
  password: 'Yt139130.', // Bitte ersetze dies mit einer sichereren Methode, z.B. Umgebungsvariablen
  port: 5432,
  ssl: {
    rejectUnauthorized: false // Notwendig für einige RDS-Konfigurationen, überprüfe deine Einstellungen
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

/*
  Get the list of popular articles
 */
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

/*
 Search articles by keyword in the title and content
 */
app.get('/api/articles/search', async (req, res) => {
  try {
    const keyword = req.query.keyword || '';
    console.log('Search keyword:', keyword);
    const result = await pool.query(
      'SELECT id, title, substring(content, 1, 150) as content, created_at, view_count FROM articles WHERE title ILIKE $1 OR content ILIKE $1 ORDER BY created_at DESC',
      [`%${keyword}%`]
    );
    console.log(`Found ${result.rows.length} search results`);
    res.json({ success: true, data: result.rows });
  } catch (error) {
    console.error('Error searching articles:', error);
    res.status(500).json({ success: false, error: error.message });
  }
});

/*
 Update article view count
 */
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

/*
 Get article details by ID
 */
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

// --- Bestehende Empfehlungs-Routen ---
/*
 Get all categories
 */
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

/*
 Get all questions under the specified category
 */
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

/*
 Get all options for the questions in the specified category
 */
app.get('/api/options/:categoryId', async (req, res) => {
   const { categoryId } = req.params;
   console.log(`Received options request for category ID: ${categoryId}`);
   try {
     const result = await pool.query(
       'SELECT o.id, o.text as label, o.display_order, o.question_id FROM options o JOIN questions q ON o.question_id = q.id WHERE q.category_id = $1 ORDER BY q.display_order, o.display_order',
       [categoryId]
     );
     console.log(`Category ID ${categoryId} returned ${result.rows.length} options`);
     res.json(result.rows);
   } catch (error) {
     console.error('Error fetching options:', error);
     res.status(500).json({ error: 'Internal server error', details: error.message });
   }
});

/*
 Get recommendation content based on the specified option
 */
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


// --- NEUE CHART-DATEN-ENDPUNKTE ---

/*
  Get data for Autism Prevalence Trend Chart
 */
app.get('/api/charts/prevalence-trends', async (req, res) => {
  console.log('Request received for /api/charts/prevalence-trends');
  try {
    const result = await pool.query(`
      SELECT age_group, prevalence_2015, prevalence_2018, prevalence_2022
      FROM autism_prevalence_by_age
      ORDER BY
        CASE age_group
          WHEN '0-4' THEN 1
          WHEN '5-9' THEN 2
          WHEN '10-14' THEN 3
          WHEN '15-19' THEN 4
          ELSE 5
        END;
    `);

    // Transform data for ECharts line chart
    const xAxisData = result.rows.map(row => row.age_group);
    const seriesData = [
      { name: '2015', type: 'line', data: result.rows.map(row => row.prevalence_2015) },
      { name: '2018', type: 'line', data: result.rows.map(row => row.prevalence_2018) },
      { name: '2022', type: 'line', data: result.rows.map(row => row.prevalence_2022) }
    ];

    console.log('Sending data for prevalence trends chart');
    res.json({ success: true, data: { xAxis: xAxisData, series: seriesData } });

  } catch (error) {
    console.error('Error fetching prevalence trend data:', error);
    res.status(500).json({ success: false, error: 'Internal server error', details: error.message });
  }
});

/*
  Get data for Autism Gender/Age Chart
 */
app.get('/api/charts/gender-age-prevalence', async (req, res) => {
  console.log('Request received for /api/charts/gender-age-prevalence');
  try {
    const result = await pool.query(`
      SELECT age_group, autistic_percent, ci_lower, ci_upper, gender
      FROM autism_gender_age
      ORDER BY
        CASE age_group
          WHEN '0-4' THEN 1
          WHEN '5-14' THEN 2
          ELSE 3
        END,
        gender;
    `);

    // Transform data for ECharts grouped bar chart
    const xAxisData = [...new Set(result.rows.map(row => row.age_group))].sort((a, b) => {
        // Custom sort for age groups
        const order = {'0-4': 1, '5-14': 2};
        return (order[a] || 99) - (order[b] || 99);
    });

    const seriesMap = {}; // Use a map for easier construction

    result.rows.forEach(row => {
      const genderLower = row.gender.toLowerCase();
      if (!seriesMap[genderLower]) {
        seriesMap[genderLower] = {
          name: genderLower, // Frontend expects 'male'/'female'
          type: 'bar',
          data: new Array(xAxisData.length).fill(null), // Initialize with nulls
          // Prepare markLine data structure if needed by frontend directly
          markLineData: []
        };
      }

      const index = xAxisData.indexOf(row.age_group);
      if (index !== -1) {
        seriesMap[genderLower].data[index] = row.autistic_percent;
        // Add markLine data for this specific bar
        seriesMap[genderLower].markLineData.push([
           { name: `${genderLower}-${row.age_group}-lower`, coord: [index, row.ci_lower], symbol: 'none' },
           { name: `${genderLower}-${row.age_group}-upper`, coord: [index, row.ci_upper], symbol: 'none' }
        ]);
      }
    });

    // Convert map values to array
    const seriesData = Object.values(seriesMap);

    console.log('Sending data for gender/age prevalence chart');
    res.json({ success: true, data: { xAxis: xAxisData, series: seriesData } });

  } catch (error) {
    console.error('Error fetching gender/age prevalence data:', error);
    res.status(500).json({ success: false, error: 'Internal server error', details: error.message });
  }
});

/*
  Get data for Autism Behavior Difficulty Chart
 */
app.get('/api/charts/behavioral-difficulties', async (req, res) => {
  console.log('Request received for /api/charts/behavioral-difficulties');
  try {
    // Order by percentage ASC to match the frontend's current Y-axis order
    const result = await pool.query(`
      SELECT behavior_difficulty, proportion_percent
      FROM autism_behavior_difficulty
      ORDER BY proportion_percent ASC;
    `);

    // Transform data for ECharts horizontal bar chart
    const yAxisData = result.rows.map(row => row.behavior_difficulty);
    const seriesData = result.rows.map(row => row.proportion_percent);

    console.log('Sending data for behavioral difficulties chart');
    res.json({ success: true, data: { yAxis: yAxisData, seriesData: seriesData } });

  } catch (error) {
    console.error('Error fetching behavioral difficulty data:', error);
    res.status(500).json({ success: false, error: 'Internal server error', details: error.message });
  }
});


// --- Server Start ---
app.listen(port, '0.0.0.0', () => {
  console.log(`Server running on http://localhost:${port}`);
  console.log(`API available at http://localhost:${port}/api/`);
  console.log(`Chart API available at http://localhost:${port}/api/charts/`);
});