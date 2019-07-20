
// 路由设计，方式二
var express = require('express');
// 创建一个路由容器
var router = express.Router();

var fsTool = require('../../../Tool/fileTool.js');

// 将路由挂载到路由容器中
router.get('/',function (request,response) {
	response.status(404).send('Not Found');
});

router.get('/index.html',function (request,response) {
	fsTool.readFile('./students.json',function (isSuccess,data) {
		if (!isSuccess) {
			response.status(500).send('Unknown Error');
		}else{
			var studentArray = JSON.parse(data.toString()).students;
			/**
			 * Express为Response响应对象提供了render方法，该方法默认不可使用，只有配置了模版引擎才能使用
			 * 参数一：模版名，默认会去项目的views目录查找该模版文件
			 * 		Express中有一个约定，所有的视图文件都放在views目录
			 * 		如果想要修改默认的view路径，则可以使用
			 * 		server.set('views',render函数路径)
			 * 		渲染文件不一定要有模版数据
			 * 参数二：模版数据
			 */
			response.render('index.html',{
				students : studentArray,
				title : 'Express'
			});
		}
	});
});

router.post('/submit',function (request,response) {
	fsTool.readFile('./students.json',function (isSuccess,data) {
		if (!isSuccess) {
			response.status(500).send('Unknown Error');
		}else{
			var studentsInfo = JSON.parse(data.toString());
			studentsInfo.students.unshift(request.body);
			fsTool.writeFile('./students.json',JSON.stringify(studentsInfo),function(isSuccess){
				if (!isSuccess) {
					response.status(500).send('Unknown Error');
				}else{
					/**
					 * 方法一：
					 * 	response.statusCode = 302;
					 *	response.setHeader('Location','/index.html');
					 *	response.send();
					 */
					
					// 方法二
					// 服务端重定向只对同步请求有效，对异步请求无效
					response.redirect('/index.html');
				}
			});
		}
	});
});


module.exports = router;
