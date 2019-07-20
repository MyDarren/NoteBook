/**
 *  使用nodemon解决频繁修改代码重启服务器问题
 *  nodemon是基于Node.js开发的第三方命令行工具
 *  使用命令npm install --global nodemon安装
 *  使用nodemon express.js启动的服务，当文件发生变化的时候，自动重启
 */

var express = require('express');

// 创建服务器应用程序，相当于http.createServer()
var server = express();

// 公开指定目录
// 当请求路径以/public/开头的时候，其./public/路径中查找
// server.use('/public/',express.static('../public/')); //http://127.0.0.1:3000/public/css/index.css
// 当省略第一个参数时，可以在请求路径中省略/static/的方式来访问
// server.use(express.static('../public/')); //http://127.0.0.1:3000/css/index.css
// server.use('/static/',express.static('../static/')); //http://127.0.0.1:3000/static/image/child.jpg
// server.use(express.static('../static/')); //http://127.0.0.1:3000/image/child.jpg
// server.use('/a/',express.static('../public/')); //http://127.0.0.1:3000/a/css/index.css

server.use(express.static('../public/css/'));
server.use(express.static('../public/javascript/'));

/**
 * 在express中配置art-template模版引擎
 * express-art-template是专门用来把art-template整合到express中的，虽然不需要加载但是必须安装其依赖art-template
 * 1、安装
 * 	  npm install art-template --save
 * 	  npm install express-art-template --save
 * 2、配置
 * 	  参数一：表示当渲染以.html结尾的文件的时候，使用art-template模版引擎
 */
server.engine('html',require('express-art-template'));
server.set('view options',{
	debug : process.env.NODE_ENV !== 'production'
});
server.set('views','../views');

/**
 * 在express中获取表单post请求体数据
 * 在express中没有内置获取表单post请求体的API，需要使用第三方件body-parser
 * npm install body-parser --save
 */
var bodyParser = require('body-parser');
// parse application/x-www-form-urlencoded
// 加入这个配置，会在request请求对象上多出一个属性body，可以通过request.body获取表单post请求体数据
server.use(bodyParser.urlencoded({extended:false}));
// parse application/json
server.use(bodyParser.json());

// 路由设计，方式一
// var customRouter = require('./customRouter');
// customRouter(server);

// // 路由设计，方式二
var expressRouter = require('./expressRouter');
// // 将路由容器挂载到服务中
// // 配置模版引擎和body-parser必须在挂载路由之前
server.use(expressRouter);

// 相当于http.listen()
server.listen(3000,function () {
	console.log('server is running at port 3000');
});

