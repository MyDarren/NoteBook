
console.log('开始加载C模块');
function subduction(x,y) {
	return x - y;
}

module.exports = subduction;

console.log('C模块加载完毕');