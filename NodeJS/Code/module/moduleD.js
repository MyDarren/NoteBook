
console.log(exports === module.exports);

exports.name = 'zhangsan';
exports.getName = function () {
	return this.name;
}
module.exports.age = 18;

exports = {
	sex:'male'
}

module.exports.sex = 'female';

// 以下修改都无效
// return module.exports;
// return exports;