
// 路由设计，方式一
module.exports = function (server) {

	var studentArray = [
		{
			name:'张三',
			age:18
		},
		{
			name:'李四',
			age:20
		}
	];
	
	server.get('/',function (request,response) {
		response.status(404).send('Not Found');
	});
	
	// 当服务器收到get请求的时候，执行回调处理函数
	server.get('/index.html',function (request,response) {
		response.render('index.html',{
			students : studentArray,
			title : 'Express'
		});
	});

	server.post('/submit',function (request,response) {
		var student = request.body;
		studentArray.unshift(student);
		response.redirect('/index.html');
	});
}

