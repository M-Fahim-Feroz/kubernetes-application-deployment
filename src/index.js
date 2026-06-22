const express = require('express');
const app = express();
const port = process.env.PORT || 3000;

// Middleware to parse JSON
app.use(express.json());

app.get('/', (req, res) => {
  res.json({
    message: 'Hello from Kubernetes!',
    environment: process.env.NODE_ENV || 'development',
    version: '1.0.0',
    configValue: process.env.CONFIG_VALUE || 'Not set',
    secretValue: process.env.SECRET_VALUE ? 'Set (Hidden)' : 'Not set'
  });
});

app.get('/health', (req, res) => {
  // Liveness probe endpoint
  res.status(200).json({ status: 'healthy' });
});

app.get('/ready', (req, res) => {
  // Readiness probe endpoint
  // In a real app, check DB connections, cache, etc.
  res.status(200).json({ status: 'ready' });
});

app.listen(port, () => {
  console.log(`Server listening on port ${port}`);
});
