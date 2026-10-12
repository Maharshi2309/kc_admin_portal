// Dev-only CORS proxy for Flutter web.
//
// The hosted API answers browser preflights itself and only allows its own
// origin, so Chrome blocks calls from http://localhost:<port>. This proxy
// listens locally, forwards every request to the hosted API (server to
// server, so no CORS applies) and adds the CORS headers the browser needs.
//
//   node tools/dev_cors_proxy.js
//   flutter run -d chrome --dart-define-from-file=env/dev.proxy.json
//
// Never use this in production.
const http = require('http');

const TARGET = process.env.TARGET || 'https://4q5htxof0b.c35.airoapp.ai';
const PORT = Number(process.env.PORT || 3001);

function cors(res, origin) {
  res.setHeader('Access-Control-Allow-Origin', origin || '*');
  res.setHeader('Access-Control-Allow-Methods', 'GET, POST, PATCH, PUT, DELETE, OPTIONS');
  res.setHeader('Access-Control-Allow-Headers', 'Authorization, Content-Type, Accept');
  res.setHeader('Access-Control-Expose-Headers', 'X-Request-Id, Retry-After');
  res.setHeader('Vary', 'Origin');
}

http.createServer(async (req, res) => {
  const origin = req.headers.origin;
  if (req.method === 'OPTIONS') {
    cors(res, origin);
    res.setHeader('Access-Control-Max-Age', '600');
    res.writeHead(204).end();
    return;
  }
  try {
    const chunks = [];
    for await (const c of req) chunks.push(c);
    const body = chunks.length ? Buffer.concat(chunks) : undefined;
    const headers = {};
    for (const k of ['authorization', 'content-type', 'accept']) {
      if (req.headers[k]) headers[k] = req.headers[k];
    }
    const upstream = await fetch(TARGET + req.url, {
      method: req.method,
      headers,
      body: ['GET', 'HEAD'].includes(req.method) ? undefined : body,
    });
    cors(res, origin);
    const type = upstream.headers.get('content-type');
    if (type) res.setHeader('Content-Type', type);
    res.writeHead(upstream.status);
    res.end(Buffer.from(await upstream.arrayBuffer()));
    console.log(req.method, req.url, upstream.status);
  } catch (e) {
    cors(res, origin);
    res.writeHead(502, { 'Content-Type': 'application/json' });
    res.end(JSON.stringify({ message: 'Proxy could not reach the API: ' + e.message }));
  }
}).listen(PORT, () => console.log(`CORS proxy: http://localhost:${PORT} -> ${TARGET}`));
