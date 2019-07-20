/**
 * 数组Array
 * 1、数组也是一个对象，使用typeof检查一个数组时，返回object
 * 2、创建数组
 *    (1) 使用构造函数创建数组，可以同时添加元素，将要添加的元素作为构造函数的参数传递
 *    (2) 使用字面量创建数组，可以在创建时指定数组元素
 * 3、向数组中添加元素
 *    数组[索引] = 值
 * 4、读取数组中的元素，如果读取不存在的索引，不会报错，返回undefined
 *    数组[索引]
 * 5、获取数组长度
 *    数组.length
 *    对于连续的数组，使用length可以获取数组的长度(元素的个数)
 *    对于非连续的数组，使用length会获取数组最大的索引+1
 * 6、修改数组长度
 *    数组.length = 长度
 *    如果修改的长度大于原长度，则多处部分会空出来
 *    如果修改的长度小于原长度，则多出的元素会被删除
 *    向数组的最后一个位置添加元素，数组[数组.length] = 值
 * 7、数组的数据可以是任意的数据类型，可以是对象和函数
 * 8、数组方法
 *    push()，向数组的末尾添加一个或多个元素，并返回数组长度
 *    pop()，删除并返回数组的最后一个元素
 *    unshift()，向数组的开头添加一个或多个元素，并返回数组长度
 *    shift()，删除并返回数组的第一个元素
 *    slice()，从数组中提取返回选定元素，array.slice(start,end)
 *       不会改变原数组，返回一个新的数组，包含start到end(不包含该元素)的元素
 *       start，开始选取位置的索引，如果是负数，则从数组尾部开始位置算起
 *       end，可选，结束选取位置的索引，省略的话表示截取从开始位置之后的所有元素
 *    splice()，删除元素，并向数组中添加新元素，array.splice(start,number,value...)
 *       使用splice()会影响原数组，从原数组中删除元素并返回
 *       start，表示开始位置的索引
 *       number，表示删除元素的个数
 *       value...，表示要添加的元素，这些元素会添加到开始索引对应元素的前面
 *    concat()，连接一个或多个数组，并将新的数组返回，array.concat(array1,array2,element1,element2)
 *       不会改变原数组，参数可以是数组，也可以是单个元素
 *    join()，将数组中所有元素放入字符串，元素通过指定的分隔符分隔，该方法不会改变原数组，参数用于指定分隔符，默认为逗号","
 *    reverse()，颠倒数组中元素顺序，该方法会改变原数组
 *    sort()，可以用于数组排序，该方法会改变原数组，默认按照Unicode编码排序
 *       按照默认方式对纯数字数组进行排序时，可能会得到错误的结果
 *       可以在sort()中添加一个回调函数，用于指定排序规则
 *       回调函数中需要定义两个形参，浏览器会将数组中的元素以实参的形式传递进回调函数
 *       传递给回调函数的两个值在数组中的位置value1一定在value2前面，
 *       浏览器会根据回调函数的返回值决定元素的顺序，
 *           如果返回值大于0，则元素交换位置
 *           如果返回值小于等于0，则元素位置不变
 *           如果需要升序排列，返回value1 - value2
 *           如果需要降序排列，返回value2 - value1
 * */

/*
var array1 = new Array();
console.log(typeof array1); //object
console.log(array1);
array1[0] = 10;
array1[1] = 20;
console.log(array1);
console.log(array1[0]); //10
console.log(array1[5]); //undefined
console.log(array1.length); //2
array1[10] = 30;
console.log(array1.length); //11
array1[5] = 40;
console.log(array1.length); //11
console.log(array1);
array1.length = 5;
console.log(array1);
array1[array1.length] = 15;

var array2 = [];
console.log(typeof array2); //object

var array3 = [1,2,3,,,6];
console.log(array3);
console.log(array3.length); //6

var array4 = [10]; //创建一个数组，数组中只有一个元素
console.log(array4); //[10]
console.log(array4.length); //1

var array5 = new Array(10); //创建一个长度为10的数组
console.log(array5); //[empty * 10]
console.log(array5.length); //10

var array6 = new Array(10,20);
console.log(array6); //[10,20]
console.log(array6.length); //2

var array7 = [10,"hello",null,undefined,{name:"lisi"},function(){console.log("world")}];
console.log(array7); //[10, "hello", null, undefined, {…}, ƒ]
console.log(array7[2]);
array7[5]();

var array8 = [10,"hello"];
array8.push("Lucy");
console.log(array8); //[10, "hello", "Lucy"]
console.log(array8.push(10,"world")); //5
console.log(array8.pop()); //"world"

var array9 = [20,"Lucy"];
console.log(array9.shift()); //20
console.log(array9.unshift("David","Ketty")); //3
console.log(array9); //["David", "Ketty", "Lucy"]
console.log(array9.slice(0,2)); //["David", "Ketty"]
console.log(array9.splice(0,2,"July"));
console.log(array9);

var array10 = ["Lucy","ketty"];
var array11 = ["David","Smith"];
var array12 = array10.concat(array11);
console.log(array12); //["Lucy", "ketty", "David", "Smith"]
console.log(array12.concat("July")); //["Lucy", "ketty", "David", "Smith", "July"]
console.log(array12.join(";"));
console.log(array12.reverse()); //["Smith", "David", "ketty", "Lucy"]
console.log(array12.sort()); //["David", "Lucy", "Smith", "ketty"]

var array13 = [2,5,3,11,8];
console.log(array13.sort()); //[11, 2, 3, 5, 8]
array13.sort(function (value1,value2) {
    return value1 - value2;
});
console.log(array13);
*/

/**
 * 遍历数组
 * 1、使用for循环遍历数组
 * 2、使用forEach()遍历数组，该方法只支持IE8以上浏览器，forEach()方法需要函数作为参数，
 *    数组中有几个元素函数就会调用几次，每次执行时，浏览器会将遍历到的元素以实参的形式传递进函数，可以定义形参来读取数据
 *    浏览器会在回调函数中传递三个参数：
 *    (1)第一个参数表示当前正在遍历的元素
 *    (2)第二个参数表示当前正在遍历元素的索引
 *    (3)第三个元素表示当前正在遍历的数组
 * */

/*
var array14 = ["David","Lucy","Ketty"];
for (var i = 0; i < array14.length; i++){
    console.log(array14[i]);
}

array14.forEach(function (value,index,obj) {console.log(value), console.log(index), console.log(obj), console.log(this)});
*/