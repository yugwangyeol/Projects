const express = require('express');
const app = express();
app.use(express.static('public'));

const port = process.env.PORT || 3000;

app.get('/', (req, res) => res.send("Hello World! I'm YMK"));

app.get('*', (request, response) => {
    response.send(404);
    response.send('해당 경로에는 아무것도 없습니다.');
});

app.listen(port, () => console.log(`Example server listening on port ${port}!`));
