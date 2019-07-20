
console.log('开始加载B模块');
var name = "Ketty";
console.log(exports); //{}
exports.name = name;
console.log(exports); //{ name: 'Ketty' }

exports.addFunction = function (x,y) {
	return x + y;
};

require('./moduleC.js');

console.log('B模块加载完毕');