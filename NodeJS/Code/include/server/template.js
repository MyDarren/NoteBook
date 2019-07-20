
var path = require('path');
var express = require('express');
var server = express();

server.use(express.static(path.join(__dirname,'./public/')));
server.use('/node_modules',express.static('../../../node_modules/'));
server.set('views',path.join(__dirname,'../views/'));
server.engine('html',require('express-art-template'));

server.get('/index.html',function (request,response) {
	response.render('index.html',{
		content : '好帅啊'
	})
});

server.get('/child1.html',function (request,response) {
	response.render('child1.html',{
		content : '好帅啊'
	})
});

server.get('/child2.html',function (request,response) {
	response.render('child2.html',{
		content : '好帅啊'
	})
});

server.listen(3000,function (data){
	console.log('Running...');
})