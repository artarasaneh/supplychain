var express = require('express');
var app = express();
app.use(express.static('/'));
app.use(express.static('/smart/build/contracts'));
app.get('/', function(req, res) {
    res.render('index.html');
});
app.listen(3000, function() {
    console.log('Your Dapp listening on port 3000!');
});