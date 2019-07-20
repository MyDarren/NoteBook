/**
 * 处理异步函数时，通常通过回调函数嵌套的方式保证函数顺序执行，造成回调地狱嵌套问题
 * 在EcmaScript 6中新增Promise构造函数用于解决回调地狱嵌套问题
 * Promise容器存放异步任务，该任务有三种状态：pending、resolved、rejected
 * 对象的状态不受外界影响，只有异步操作的结果，可以决定当前是哪一种状态，任何其他操作都无法改变这个状态
 * 一旦状态改变就不会再变，promise对象的状态改变只有两种可能：从pending变为resolved，从pending变为rejected
 * Promise构造函数接收一个函数作为参数，该函数的两个参数分别是resolve和reject，他们是两个函数，由Javascript引擎提供
 * resolve函数的作用是，将promise对象的状态从pending变为resolved，在异步操作成功时调用，并将异步操作的结果，作为参数传递出去
 * reject函数的作用是，将Promise对象的状态从pending变为rejected，在异步操作失败时调用，并将异步操作报出的错误，作为参数传递出去
 * promise实例生成以后，可以用then方法分别指定resolved状态和rejected状态的回调函数
 * 第一个回调函数是promise对象的状态变为resolved时调用，第二个回调函数是promise对象的状态变为rejected时调用，第二个函数是可选的，
 * 这两个函数都接受promise对象传出的值作为参数
 * then方法返回的是一个新的Promise实例（不是原来那个Promise实例），因此可以采用链式写法，即then方法后面再调用另一个then方法
 */

function promiseReadFile(filePath) {
	// console.log(1);
	// 创建Promise容器
	// Promise容器一旦创建，就开始执行里面的代码
	// Promise本身不是异步，但是其内部封装的往往是一个异步任务
	// 打印顺序1、2、4、3、5
	// resolve和reject二者只会执行第一个出现的状态对应的then中的回调，后面不执行
	// resolve和reject只能向该状态对应的then中的回调中传递一个参数，写多个参数时只会传第一个参数过去
	return new Promise(function (resolve,reject) {
		// console.log(2);
		var fs = require('fs');
		fs.readFile(filePath,function (error,data) {
			// console.log(3);
			if (error) {
				// 把容器状态改为Rejected
				// resolve(data.toString());
				reject(error);
			}else{
				// 把容器状态改为Resolved
				resolve(data.toString());
			}
		});
	})
}

var promise = promiseReadFile('./file1.txt');
// console.log(4);
promise
	.then(function(data) {
		// console.log(5);
		console.log(data);
		return promiseReadFile('./file12.txt');
	})
	// 内部报错的时候回调，比如使用不存在的方法
	// .catch(function(error){
	// 	console.log(error);
	// })
	.then(function(data) {
		console.log(data);
		return promiseReadFile('./file3.txt');
	})
	.then(function(data) {
		console.log(data);
	})

// 调用resolve或reject并不会终结 Promise 的参数函数的执行
// 一般来说，调用resolve或reject以后，Promise 的使命就完成了，后继操作应该放到then方法里面，而不应该直接写在resolve或reject的后面
// new Promise((resolve, reject) => {
//   resolve(1);
//   console.log(2);
// }).then(r => {
//   console.log(r);
// });
// 2
// 1

// p1和p2都是 Promise 的实例，但是p2的resolve方法将p1作为参数，即一个异步操作的结果是返回另一个异步操作。
// 这时p1的状态就会传递给p2，p1的状态决定了p2的状态。如果p1的状态是pending，那么p2的回调函数就会等待p1的状态改变；
// 如果p1的状态已经是resolved或者rejected，那么p2的回调函数将会立刻执行
// var p1 = new Promise(function (resolve, reject) {
//   // ...
// });

// var p2 = new Promise(function (resolve, reject) {
//   // ...
//   resolve(p1);
// })



