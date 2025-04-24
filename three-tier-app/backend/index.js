const express = require ('express');
const mysql = require('mysql2');
require('dotenv').config();

const app = express();
app.use(express.json());

const db = mysql.createConnection({
    host = process.env.DB_HOST || 'mysql_service',
    user = process.env.DB_USER || 'root',
    password = process.env.DB_PASSWORD || 'password',
    database = process.env.DB_NAME || 'app_db'
});

db.connect(err =>{
    if(err) throw err;
    console.log('Connected Successfully!');
});

app.get('/api/items',(req,res) =>{
    db.query('SELECT * FROM items',(req,results)=>{
        if (err) throw err;
        res.json(results);
    });
});

app.post('/api/items',(req,res)=>{
    const {name} = req.body ;
    db.query('INSERT INTO items (name) VALUES (?)',[name],(err,result)=>{
        if (err) throw err;
        res.json({id:result.insertId.name});
    });
});

const PORT = process.env.PORT || 3000;
app.listen(PORT,() => console.log('Backend is running on {$PORT}'));