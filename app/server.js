const express = require('express');
const { Pool } = require('pg');
const app = express();
const PORT = process.env.PORT || 3000;

// 1. Connection Config
const pool = new Pool({
  host: process.env.DB_HOST,
  user: 'postgres',                  // Changed to match your RDS Terraform code
  password: process.env.DB_PASSWORD, 
  database: 'shopfastdb',            // Changed to match 'db_name' in your RDS code
  port: 5432,
});

// Root route for the ALB Health Check (matches matcher = "200,404")
app.get('/', (req, res) => {
  res.status(200).json({ service: "ShopFast API", status: "Online" });
});

app.get('/health', (req, res) => {
  res.status(200).send('Healthy');
});

app.get('/track/:orderId', async (req, res) => {
  try {
    const { orderId } = req.params;
    // Test the connection:
    await pool.query('SELECT NOW()'); 
    
    res.json({
      orderId: orderId,
      status: "In Transit",
      location: "Dubai Logistics Hub",
      database_connected: true,
      eta: "2026-05-15"
    });
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: "Database Connection Failed", details: err.message });
  }
});

// CRITICAL: Listen on 0.0.0.0
app.listen(PORT, '0.0.0.0', () => {
  console.log(`ShopFast API running on port ${PORT}`);
});