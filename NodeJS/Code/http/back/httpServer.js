/**
 * 使用Node可以轻松地构建Web服务器
 * 在Node中提供了http核心模块，其职责是创建编写服务器
 */

/**
 * 客户端渲染与服务端渲染
 * 客户端渲染不利于SEO搜索引擎优化
 * 服务端渲染可以被爬虫到，客户端异步渲染很难被爬虫到
 * 一般网站都是将两者结合使用
 * 例如京东的商品列表采用的就是服务端渲染，目的是为了SEO搜索引擎优化
 * 而商品的评论列表为了用户体验，而且不需要SEO优化，采用的客户端渲染
 * 浏览器在收到HTML相应内容后，开始从上到下解析，在解析过程中，
 * 如果发现：link、script、img、iframe、video、audio等带有src或者href(link)属性的标签的时候，浏览器会自动对这些资源发起新的请求
 */

// 加载http核心模块
var http = require('http');

var url = require('url');

// 创建Web服务器
var server = http.createServer();

// Web服务资源路径
var rootPath = './';

var template = require('art-template');

/**
 * 注册request请求事件
 * 当客户端请求过来，触发服务器request请求事件，执行回调处理函数
 * request请求事件处理函数，接受两个参数
 * 		Request 请求对象
 * 			可以获取客户端的一些请求信息，例如请求路径
 * 		Response 响应对象
 * 			可以用来给客户端发送响应消息
 * 			使用write()方法可以用来给客户端发送响应数据，可以使用多次，但是一定要使用end()来结束响应，否则客户端会一直等待
 * 			服务器发送响应数据时，默认使用UTF-8编码，浏览器在不知道服务器响应内容编码的情况下，会按照当前操作系统的默认编码解析
 * 			中文操作系统默认编码为GBK，使用response.setHeader设置Content-Type
 * 			不同的资源对应不同的Content-Type http://tool.oschina.net/commons
 * 			图片一般不需要指定编码，一般只为字符数据指定编码
 */			
server.on('request',function (request,response) {
	var fsTool = require('../../../Tool/fileTool.js');
	
	/**
	 * 使用url.parse()方法可以将路径解析为方便操作的对象，
	 * 参数一：要解析的url
	 * 参数二：为true表示直接将query字符串转化为一个对象
	 */
	var parseObj = url.parse(request.url,true);
	// 获取不包含查询字符串的路径部分
	var pathName = parseObj.pathname;
	var filePath = 'index.html';
	if (pathName === '/') {
		filePath = '/index.html';
	}else{
		filePath = request.url;
	}

	fsTool.readFile(rootPath + filePath,function(isSuccess,data){
		if (!isSuccess) {
			/**
			 * 如何通过服务器让客户端重定向
			 * 1、状态码设置为302，临时重定向
			 * 	  statusCode
			 * 2、在响应头中通过Location告诉客户端重定向地址
			 *    setHeader
			 */
			response.statusCode = 302;
			response.setHeader('Location','404.html');
			response.end();
			return;
		}
		if (filePath === '/index.html') {
			fsTool.readFile('students.json',function (isSuccess,studentData) {
				if (!isSuccess) {
					response.statusCode = 302;
					response.setHeader('Location','404.html');
					response.end();
					return;
				}
				var students = JSON.parse(studentData.toString()).students;
				var result = template.render(data.toString(),{
					students : students
				});
				response.setHeader('Content-Type','text/html;charset=utf-8');
				return response.end(result);
			})
		}else if (filePath === '/main.css') {
			response.setHeader('Content-Type','text/css;charset=utf-8');
			response.end(data);
		}else if (filePath === '/main.js') {
			response.setHeader('Content-Type','application/x-javascript;charset=utf-8');
			response.end(data);
		}else if (filePath === '/child.jpg') {
			response.setHeader('Content-Type','image/jpeg');
			response.end(data);
		}else{
			response.setHeader('Content-Type','text/html;charset=utf-8');
			response.end(data);
		}
	});

	/*
	if (pathName == '/') {
		fsTool.readFile('./index.html',function(isSuccess,data){
			response.setHeader('Content-Type','text/html;charset=utf-8');
			response.end(data);
		});
	}else if (pathName == '/bbs') {
		var students = [
			{
				name:"David",
				age:18,
				sex:"male"
			},
			{
				name:"Lucy",
				age:20,
				sex:"female"
			},
			{
				name:"Ketty",
				age:25,
				sex:"female"
			}
		];
		// 方式一：
		// response.write(JSON.stringify(students));
		// response.end()
		// 方式二：上面的方式比较麻烦，可以使用end在结束的同时发送数据
		response.end(JSON.stringify(students));
	}else if (pathName == '/main.css') {
		fsTool.readFile('./main.css',function(isSuccess,data){
			response.setHeader('Content-Type','text/css');
			response.end(data);
		});
	}else if (pathName == '/main.js') {
		fsTool.readFile('./main.js',function(isSuccess,data){
			response.setHeader('Content-Type','application/x-javascript');
			response.end(data);
		});
	}else if (pathName == '/child.jpg') {
		fsTool.readFile('./child.jpg',function(isSuccess,data){
			response.setHeader('Content-Type','image/jpeg');
			response.end(data);
		});
	}else{
		response.end("Not Found");
	}
	*/
});

// 绑定端口号，启动服务器
server.listen(3000,function () {
	console.log("服务器启动成功，可以通过http://127.0.0.1:3000/来访问");
});
