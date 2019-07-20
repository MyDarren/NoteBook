
var mysql = require('mysql');

var connection = mysql.createConnection({
	host: 'localhost',
	user: 'root',
	password: 'cyk654321',
	database: 'mysql'
});

connection.connect(function(error){
	if (error) {
		console.log(error);
	}
});

connection.query('SELECT * FROM student',function (error,result,fields) {
	if (error) throw error;
	console.log(result);
});

// NULL表示使用自动生成的值
connection.query('INSERT INTO student VALUES(NULL,"Lucy","女",20)',function(error,result,fields){
	if (error) throw error;
	console.log(result);
})

connection.end();