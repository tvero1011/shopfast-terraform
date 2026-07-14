const express = require('express');
const { Pool } = require('pg');

const app = express();
const PORT = process.env.PORT || 3000;

// ---------------------------------------------------------
// 1. Database connection (all values come from the environment;
//    Terraform / ECS inject them: DB_HOST, DB_NAME, DB_USER, DB_PASSWORD)
// ---------------------------------------------------------
const pool = new Pool({
  host: process.env.DB_HOST,
  user: process.env.DB_USER || 'postgres',
  password: process.env.DB_PASSWORD,
  database: process.env.DB_NAME || 'shopfastdb',
  port: 5432,
  // RDS PostgreSQL 15+ requires SSL by default. This encrypts the connection but
  // does not verify the server certificate; production should ship the RDS CA
  // bundle and set rejectUnauthorized: true. Set DB_SSL=false for a local Postgres.
  ssl: process.env.DB_SSL === 'false' ? false : { rejectUnauthorized: false },
  connectionTimeoutMillis: 5000,
  max: 10,
});

// An idle client can error (e.g. DB restarts). Log it instead of crashing the process.
pool.on('error', (err) => {
  console.error('Unexpected error on idle database client', err);
});

// ---------------------------------------------------------
// 2. Routes
// ---------------------------------------------------------

// Shallow health check used by the ALB: proves the process is up, deliberately does NOT
// touch the database, so a DB outage does not make the ALB kill every healthy task.
app.get('/', (req, res) => {
  res.status(200).json({ service: 'ShopFast API', status: 'Online' });
});

app.get('/health', (req, res) => {
  res.status(200).send('Healthy');
});

// Demo endpoint: proves the app can reach the database (SELECT NOW()), then returns
// sample tracking data. The tracking values are hard-coded; there is no orders table.
app.get('/track/:orderId', async (req, res) => {
  try {
    const { orderId } = req.params;
    await pool.query('SELECT NOW()');

    res.json({
      orderId,
      status: 'In Transit',
      location: 'Dubai Logistics Hub',
      database_connected: true,
      eta: '2026-05-15',
    });
  } catch (err) {
    // Log the detail for operators (goes to CloudWatch); return a generic message to clients.
    console.error('Database query failed', err);
    res.status(500).json({ error: 'Database connection failed' });
  }
});

// ---------------------------------------------------------
// 3. Start and graceful shutdown
// ---------------------------------------------------------
// Listen on 0.0.0.0: inside a container, localhost would be unreachable from the ALB.
const server = app.listen(PORT, '0.0.0.0', () => {
  console.log(`ShopFast API running on port ${PORT}`);
});

// ECS sends SIGTERM on deploys and scale-in: stop taking new requests, finish
// in-flight ones, close DB connections, then exit (force-exit after 10s).
function shutdown(signal) {
  console.log(`${signal} received, shutting down`);
  server.close(async () => {
    await pool.end();
    process.exit(0);
  });
  setTimeout(() => process.exit(1), 10000).unref();
}

process.on('SIGTERM', () => shutdown('SIGTERM'));
process.on('SIGINT', () => shutdown('SIGINT'));
