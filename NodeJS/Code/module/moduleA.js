
/**
 * require作用
 * 		1、加载文件模块并执行其中的代码
 *   	2、返回被加载文件模块导出的接口对象
 * 在Node中，模块有三种
 * 		1、具名的核心模块，他们具有特殊的名称标识
 * 			fs 文件操作模块
 * 			http 网络服务构建模块
 * 			os 操作系统信息模块
 * 			path 路径处理模块
 * 			url 路径操作模块
 * 		2、自己编写的文件模块
 * 			相对路径中的./不能省略，省略之后当作核心模块
 * 			.js的后缀名可以省略
 * 		3、第三方模块
 * 			art-template
 * 		 	需要通过npm下载才能使用
 * 		 	
 * 在Node中，没有全局作用域，只有模块作用域，模块完全是封闭的，外部无法访问内部，内部无法访问外部，可以避免变量命名冲突
 * 每一个模块中都有一个module对象，在该对象中有一个默认为空对象的exports对象，模块中最后返回module.exports对象
 * 如果需要对外导出成员，只需要把导出成员挂载到module.exports对象中，但是每次module.exports.xx=xx太麻烦
 * 因而Node为了方便，中在每个模块提供一个默认为空对象的exports对象，其中exports对象为module.exports的引用
 * 从而可以使用exports.xx=xx实现简化
 * 直接赋值exports则exports指向发生变化，不影响返回的module.exports对象
 * 直接赋值module.exports则module.exports指向发生变化，影响返回的module.exports对象
 * 一个模块中多次使用module.exports进行赋值，后者会覆盖前面的赋值
 * 最终返回的是module.exports对象。切记，该代码中不可见，手动return exports无效
 * 
 * 导出多个对象
 * 		方式一：exports.name = 'zhangsan';
 * 			   exports.getName = function(){
 * 			   	  console.log(this.name);
 * 			   };
 * 		方式二：module.exports = {
 * 			name:'zhangsan',
 * 			getName:function(){
 * 				console.log(this.name);
 * 			}
 * 		}
 * 导出单个对象
 * 		必须使用	module.exports = xxx的方式
 */

/**
 * npm命令
 * 网站:www.npmjs.com
 * 命令：
 * 		npm init -y 可以跳过向导，快速生成package.json
 * 		npm --version 				 查看版本号
 * 		npm install 包名				 下载依赖项，并在package.json的dependencies保存依赖项，简写npm i 包名，与下面一样
 * 		npm install 包名 --save 		 下载并在package.json的dependencies保存依赖项，简写npm i 包名 -S
 * 		npm install 包名 --no-save    仅下载依赖项，不保存到package.json中
 * 		npm install 				 一次性下载package.json的dependencies中保存的依赖项，简写npm i
 * 		npm install --global npm 	 升级npm
 * 		npm uninstall 包名			 删除依赖项，并在package.json的dependencies删除依赖项，简写npm un 包名，与下面一样
 * 		npm uninstall --save 包名	 删除依赖项并将package.json的dependencies依赖项删除，简写npm un -S 包名
 * 		npm uninstall 包名 --no-save	 仅删除依赖项，不从package.json的dependencies将依赖项删除
 * 		npm help					 查看使用帮助
 * 		npm 命令 help				 查看指定命令的帮助
 * 		可以在命令后面添加--registry=https://registry.npm.taobao.org指定使用淘宝镜像源下载依赖项
 * 		可以使用npm config set registry https://registry.npm.taobao.org进行配置，配置之后再使用npm下载都是从淘宝镜像源下载
 * 		可以通过npm config list查看配置信息
 */

/**
 * package.json
 * 包描述文件，建议每个项目根目录中都有一个package.json文件
 * 可以通过npm init的方式创建出来
 * 建议在执行npm install xxx的时候都加上--save选项，目的是用来保存依赖项信息
 * 当项目中的node_modules被删除后，使用npm install，它会把package.json中dependencies记录的依赖项都下载下来，从而恢复所有依赖的第三方库
 *
 * package-lock.json
 * npm 5以前不会有package-lock.json这个文件，npm 5之后才加入这个文件
 * npm 5之后版本安装包的时候不需要添加--save，会自动保存依赖信息，当在使用npm install安装包的时候，会自动创建或更新package-lock.json
 * package-lock.json保存node_modules中所有包的信息，包括版本、下载地址等，这样的话使用npm install重新安装的时候速度提升
 * package-lock.json用于锁定依赖项版本，防止自动升级
 * 第一次使用npm install jquery@1.11.1安装jquery，此时package.json文件中保存的是"jquery": "^1.11.1"，下载下来的版本为1.11.1版本
 * 此时删除node_modules，没有package-lock.json时，使用npm install重新安装会下载最新版本，此时package.json仍然为"jquery": "^1.11.1"
 * 有package-lock.json文件时，使用npm install重新安装会锁定版本号，不会自动下载最新版本
 * 当package.json文件中版本比package-lock.json版本高时，使用npm install重新下载依赖包的版本为package.json文件中的版本
 * 当package.json文件中版本比package-lock.json版本低时，使用npm install重新下载依赖包的版本为package-lock.json文件中的版本
 */

console.log(exports); //{}
var name = "Lucy";
var exportsB = require('./moduleB.js');
console.log(exportsB); //{ name: 'Ketty', addFunction: [Function] }
console.log(typeof exportsB); //object

console.log(name); //Lucy
console.log(exportsB.name); //Ketty
console.log(exportsB.addFunction(10,20)); //30

// 此时由于已经在moduleB.js中加载moduleC.js，因而不会再次加载moduleC.js，执行其中的代码
var exportsC = require('./moduleC.js');
console.log(exportsC); //[Function: subduction]
console.log(exportsC(20,10)); //10

var exportsD = require('./moduleD.js');
console.log(exportsD);
exportsD.getName();

/*
 * require方法加载规则
 * 1、优先从缓存加载
 * 2、根据名称查找系统模块
 * 3、根据文件路径查找模块
 * 4、查找第三方模块
 * 	  通过npm下载，没有模块标识与核心模块相同的第三方模块
 * 	  	(1) 找到当前文件所在目录的node_modules目录
 * 	  	(2) 找到node_modules/模块标识/目录
 * 	  	(2) 找到node_modules/模块标识/package.json文件
 * 	  	(3) 查看该文件的main属性，该属性中记录该模块的入口模块
 * 	  	如果package.json文件不存在，，则找到index.js文件
 * 	  	如果package.json文件存在，其main属性中指定的入口模块为存在，则找到该入口模块
 * 	  	如果package.json文件存在，其main属性中指定的入口模块为空或者文件不存在，则找到index.js文件，也就是说index.js会作为一个默认备选项
 * 	  	如果以上条件都不满足，则去上一级目录的node_modules按照相同方式查找，直到当前文件磁盘根目录，如果还没找到则报错can not find module xxx
 */
require('testModule'); //module.js文件被加载

/**
 * 在模块加载中，相对路径不能省略./
 * 在文件操作中，相对路径可以省略./
 */
var fsTool = require('../../Tool/fileTool.js');
fsTool.readFile('moduleB.js',function (isSuccess,data) {
	if (isSuccess) {
		console.log(data.toString());
	}
});

/**
 * JavaScript模块化
 * 1、NodeJS中的CommonJS
 * 2、浏览器
 * 	  AMD require.js
 * 	  CMD sea.js
 * 3、EcmaScript官方在EcmaScript 6中添加官方支持
 */

/**
 * path路径操作模块
 * path.basename 获取一个路径的文件名(默认包含拓展名)
 * path.dirname 获取一个路径的目录部分
 * path.extname 获取一个路径的拓展名部分
 * path.parse 把一个路径转化为对象
 * 		root 根路径
 * 		dir 所属目录
 * 		base 包含后缀名的文件名
 * 		ext 后缀名
 * 		name 不包含后缀名的文件名
 * path.join 拼接路径
 * path.isAbsolute 判断一个路径是否为绝对路径
 *
 * 文件操作中的相对路径不是相对于当前文件，而是相对于执行node命令时终端所处的路径
 * 在终端执行node命令时如果终端所处路径不同可能导致文件找不到，因而在文件操作中使用相对路径不可靠，可以使用__dirname和__filename
 * __dirname 动态获取当前文件所属目录的绝对路径
 * __filename 动态获取当前文件的绝对路径
 * 可以使用path.join(__dirname,filename)来动态获取文件的绝对路径，从而避免以上问题
 *
 * 模块中路径标识和文件操作中的相对路径不一样，模块中的路径标识就是相对于当前文件，不受执行node命令时所处路径影响
 */



