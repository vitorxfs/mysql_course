const express = require('express');
const app = express();
const mysql = require('mysql');
const bodyParser = require('body-parser');

app.set('view engine', 'ejs');
app.use(bodyParser.urlencoded({extended:true}));
app.use(express.static(__dirname + "/public"));

const PORT = 3000;
const connection = mysql.createConnection({
    host: 'localhost',
    user: mysql_user,
    password: mysql_password,
    database: 'join_us'
});


app.get('/', (req, res) => {
    const q = 'SELECT COUNT(*) AS total FROM users';
    connection.query(q, function (error, results){
        if (error) throw error;
        const count = results[0].total;
        res.render("home", { count });
    });
});

app.post('/register', (req, res) => {
    const person = { email: req.body.email };
    connection.query('INSERT INTO users SET ?', person, function (error, results ){
        if (error) throw error;
        res.redirect("/");
    });
});



app.listen(PORT, () => console.log("Server running on port ", PORT));