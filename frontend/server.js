const http = require('http');
const fs = require('fs');
const path = require('path');

const PORT = 2026;
const ROOT = path.join(__dirname, 'build');

const MIME = {
  '.html': 'text/html',
  '.js': 'application/javascript',
  '.css': 'text/css',
  '.json': 'application/json',
  '.png': 'image/png',
  '.jpg': 'image/jpeg',
  '.svg': 'image/svg+xml',
  '.ico': 'image/x-icon',
  '.woff': 'font/woff',
  '.woff2': 'font/woff2',
  '.ttf': 'font/ttf',
};

const PROXY_TARGET = 'spmvv_backend';
const PROXY_PORT = 8000;

http.createServer((req, res) => {
  // Proxy /api and /media to backend
  if (req.url.startsWith('/api') || req.url.startsWith('/media')) {
    const options = {
      hostname: PROXY_TARGET,
      port: PROXY_PORT,
      path: req.url,
      method: req.method,
      headers: { ...req.headers, host: 'localhost' },
    };
    const proxy = http.request(options, (backRes) => {
      res.writeHead(backRes.statusCode, backRes.headers);
      backRes.pipe(res, { end: true });
    });
    proxy.on('error', (e) => {
      res.writeHead(502);
      res.end('Bad Gateway: ' + e.message);
    });
    req.pipe(proxy, { end: true });
    return;
  }

  // Serve static files
  let filePath = path.join(ROOT, req.url === '/' ? 'index.html' : req.url);
  
  // SPA fallback: if file not found, serve index.html
  if (!fs.existsSync(filePath) || fs.statSync(filePath).isDirectory()) {
    filePath = path.join(ROOT, 'index.html');
  }

  const ext = path.extname(filePath);
  const contentType = MIME[ext] || 'application/octet-stream';

  fs.readFile(filePath, (err, data) => {
    if (err) {
      res.writeHead(404);
      res.end('Not found');
      return;
    }
    res.writeHead(200, { 'Content-Type': contentType });
    res.end(data);
  });
}).listen(PORT, '0.0.0.0', () => {
  console.log('Static server with proxy running on port ' + PORT);
});
