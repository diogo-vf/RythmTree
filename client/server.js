const connect = require('connect');
const serveStatic = require('serve-static');

connect()
    .use(serveStatic(__dirname))
    .listen(process.env.PORT || 8080, () => console.log(`Server running on ${process.env.PORT}...`));