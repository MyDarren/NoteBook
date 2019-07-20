

function readFile(filePath,callback) {
	var fs = require('fs');
	fs.readFile(filePath,function (error,data) {
		if (error) {
			callback(false,null);
		}else{
			callback(true,data);
		}
	});
}

// 同步读取
function readFileSync(filePath,options)

function writeFile(filePath,content,callback) {
	var fs = require('fs');
	fs.writeFile(filePath,content,function(error) {
		if (error) {
			callback(false);
		}else{
			callback(true);
		}
	});
}

// 同步写入
function writeSync(filePath,options)

function readDir(dirPath,callback) {
	var fs = require('fs');
	fs.readdir(dirPath,function(error,files){
		if (error) {
			callback(false,files);
		}else{
			callback(true,files);
		}
	});
}

exports.readFile = readFile;
exports.writeFile = writeFile;
exports.readDir = readDir;