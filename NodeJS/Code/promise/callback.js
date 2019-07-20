
var fs = require('fs');
fs.readFile('./file1.txt',function (error,data) {
	if (error) {
		return console.log('file1.txt读取失败');
	}
	console.log(data.toString());
	fs.readFile('./file2.txt',function (error,data) {
		if (error) {
			return console.log('file2.txt读取失败');
		}
		console.log(data.toString());
		fs.readFile('./file3.txt',function (error,data) {
			if (error) {
				return console.log('file3.txt读取失败');
		}
			console.log(data.toString());
		});
	});
});