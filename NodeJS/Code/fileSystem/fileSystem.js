
/**
 * 1、在NodeJS中，采用EcmaScript编码，没有DOM、BOM，和浏览器中的JavaScript不一样。
 * 2、浏览器中的JavaScript没有文件操作的能力，但是Node中有
 */

/**
 * fs是文件系统的简写，在Node中要想进行文件操作，必须引入fs核心模块，在这个模块中提供了所有文件操作的API
 */

// 使用require方法加载fs文件模块
var fs = require('fs');

/**
 * 写入文件
 * 参数一：文件路径
 * 参数二：写入内容
 * 参数三：回调函数
 * 		写入成功
 * 			error null
 * 		写入失败
 * 			error 错误对象
 */
fs.writeFile('./test.txt','hello world!',function (error) {
	if (error) {
		console.log("写入失败");
	}else{
		console.log("写入成功");
	}
});

/**
 * 读取文件
 * 参数一：文件路径
 * 参数二：可选，传入utf8将读取到的文件直接utf8编码，不选可以使用toString方法转换
 * 参数三：回调函数
 * 		读取成功
 * 			data 数据
 * 			error null
 * 		读取失败
 * 			data undefined
 * 			error 错误对象
 */
fs.readFile('./test.txt','utf8',function (error,data) {
	if (error) {
		console.log("读取失败");
	}else{
		// console.log(data.toString());
		// 第二个参数不为名时，这样也可以
		console.log(data);
	}
});

