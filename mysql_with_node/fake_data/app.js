const faker = require('faker');
const mysql = require('mysql');

const connection = mysql.createConnection({
    host: 'localhost',
    user: mysql_user,
    password: mysql_password,
    database: 'join_us'
});

// SELECTING DATA

const q = 'SELECT COUNT(*) AS total FROM users';
connection.query(q, function (error, results){
    if (error) throw error;
    console.log(results[0].total);
});


// INSERTING SINGLE DATA

var person = {
    email : faker.internet.email(),
    created_at: faker.date.past()
};
connection.query('INSERT INTO users SET ?', person, function (error, results ){
    if (error) throw error;
    console.log(results);
});


// INSERTING MULTIPLE DATA

var data = [];
for(let i=0; i<500; i++){
    data.push([
        faker.internet.email(),
        faker.date.past()
    ]);
}
const q3 = 'INSERT INTO users (email, created_at) VALUES ?';
connection.query(q3, [data], function (error, result){
    if (error) throw error;
    console.log(result);
});


connection.end();