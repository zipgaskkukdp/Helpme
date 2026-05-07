const http = require('http');
const port = 3000;

const server = http.createServer((req, res) => {
  res.statusCode = 200;
  res.setHeader('Content-Type', 'text/plain; charset=utf-8');
  res.end('destroy 언제할건데.\n');
});

server.listen(port, () => {
  console.log(`서버가 ${port}번 포트에서 실행 중입니다.`);
});