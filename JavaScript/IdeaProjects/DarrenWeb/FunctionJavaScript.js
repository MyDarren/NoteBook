/**
 * 函数也是一个对象
 * 1、创建函数
 *    (1) 使用new关键字调用构造函数，可以把封装的代码以字符串的形式传递给构造函数，在开发中很少使用
 *    (2) 使用函数声明创建函数
 *        语法:
 *            function 函数名(形参1,形参2...){
 *                语句...
 *            }
 *    (3) 使用函数表达式创建函数，即创建一个匿名函数，然后赋值给变量
 *        var 函数名=function(形参1,形参2...){
 *            语句...
 *        };
 * 2、调用函数
 *    函数对象();，调用函数时，函数中的对象按照顺序执行
 * 3、函数参数
 *    (1) 可以在函数()中指定一个或多个形参，形参之间使用,隔开，相当于在函数内部声明了对应的变量，但并不赋值
 *        在调用函数时，可以在()中指定实参，实参将会赋值给函数中对应的形参
 *    (2) 调用函数时，解析器不会检查实参的类型，也不会检查实参的数量，函数的实参可以是任意数据类型
 *        多余的实参不会赋值，如果实参数量少于形参数量，则没有对应实参的形参为undefined
 *    (3) 实参可以任意类型的数据，也可以是一个对象，当参数过多时，可以将参数封装到一个对象中，然后通过对象传递
 *        实参也可以是一个函数，实参中传递函数名表示传递函数对象，传递函数名()相当于传递函数返回值
 * 4、函数返回值
 *    (1) 函数中return后面的代码不会执行，如果函数中return后面不跟任何值就相当于返回undefined
 *        如果函数中不写return，则也会返回undefined
 *    (2) 返回值可以是任意类型，可以是对象，也可以是函数
 * 5、立即执行函数
 *    函数定义完，立即被调用，这种函数叫做立即执行函数，立即执行函数只会执行一次
 * */

/*
var function1 = new Function();
console.log(function1);
console.log(typeof function1); //function

var function2 = new Function("console.log('hello world');");
function2.age = 18;
console.log(function2);
console.log(function2.age);
function2();

function testFunction() {
    console.log("First Function");
    return;
}

testFunction();
console.log(testFunction()); //undefined

var function3 = function () {
    console.log("匿名函数");
    return undefined;
};

var function4 = function() {
    console.log("hello world");
}

function3();
console.log(function3()); //undefined
console.log(function4()); //undefined

var person = {
    name:"Lucy",
    age:18,
    sex:"女"
};

function function5(obj){
    console.log(obj.name);
    console.log(obj.age);
    console.log(obj.sex);
}

function5(person);

function function6(testFunc) {
    console.log(testFunc);
}

function6(function5); //function5函数对象
function6(function5(person)); //function5()调用函数

function function7() {
    return {
        name:"David",
        age:18,
        sex:"男"
    };
}
console.log(function7().name);

function function8(width) {
    function includeFunction(width) {
        console.log(width * width * 3.14);
    }
    includeFunction(width);
}

function8(10);

function function9() {
    function includeFunction() {
        console.log("includeFunction");
    }
    return includeFunction;
}

console.log(function9());
var function10 = function9();
function10();
function9()();

//立即执行函数
(function () {
    console.log("匿名函数");
})();

(function (width,height) {
    console.log("面积为:" + width * height);
})(10,20);
*/

/**
 * 变量的声明提前
 *     使用var关键字声明的变量，会在所有的代码执行之前被声明
 *     如果在声明变量时没有使用var关键字，变量不会被声明提前
 * 函数的声明提前
 *     使用函数声明形式创建的函数function 函数名(){}会在所有的代码执行之前被创建，因而可以在声明函数之前调用函数
 *     使用函数表达式创建的函数，不会被提前创建，因而不能在声明前调用
 * */

/*
// 相当于
// var variable1;
// console.log(variable1);
// variable1 = 10;

console.log(variable1); //undefined
var variable1 = 10;

console.log(variable2);
// variable2 = 10; //Uncaught ReferenceError: variable2 is not defined


function function11() {
    console.log("function11");
}
function11(); //function11

var function12 = function(){
    console.log("function12");
};
function12(); //function12


function13(); //function13
function function13() {
    console.log("function13");
}

// function14(); //Uncaught TypeError: function14 is not a function
var function14 = function () {
    console.log("function14");
};
*/

/**
 * 作用域
 *    1、全局作用域
 *       (1) 直接编写在script标签中的JS代码，都在全局作用域中
 *       (2) 全局作用域在页面打开时创建，在页面关闭时销毁
 *       (3) 在全局作用域中用一个全局对象window，代表浏览器的窗口，由浏览器创建，可以直接使用
 *           在全局作用域中创建的变量都会作为window对象的属性保存
 *           在全局作用域中创建的函数都会作为window对象的方法保存
 *       (4) 全局作用域中的变量都是全局变量，在页面的任意部分都可以访问到
 *    2、函数作用域
 *       (1) 函数作用域在调用函数时创建，在函数执行结束后销毁
 *           每调用一次函数就会创建一个新的函数作用域，他们之间是相互独立的
 *       (2) 在函数作用域中可以访问到全局作用域中的变量，在全局作用域中无法访问函数作用域中的变量
 *           具体来说全局作用域中无法访问函数作用域中使用var声明的变量，不使用var声明的变量可以访问
 *       (3) 在函数作用域中操作变量时，会先在自身作用域中寻找，如果有就直接使用
 *           如果没有就往上一级作用域中寻找，直到找到全局作用域中，如果依然没有找到，则会报错ReferenceError
 *           在函数作用域中想访问全局作用域中的变量，可以使用window对象
 *       (4) 在函数作用域中也有声明提前的特性
 *           在函数中，使用var关键字声明的变量，会在函数中所有代码执行之前被声明
 *           在函数中，不使用var关键字声明的变量，不会在函数中所有代码执行之前被声明，此变量会变为全局变量
 *           使用函数声明形式创建的函数会在函数中所有的代码执行之前被创建，因而可以在声明函数之前调用函数
 *           使用函数表达式创建的函数，不会被提前创建，因而不能在声明前调用
 *
 * */

/*
console.log(window);
var variable3 = 10;
console.log(window.variable3);

function function15() {
    console.log("function");
}

window.function15();

var variable4 = 10;
function function16() {
    var variable5 = 20;
    console.log(variable4);
}

function16(); //10
// console.log(variable5); //Uncaught ReferenceError: variable5 is not defined

var variable6 = 20;
function function17() {
    var variable6 = "hello";
    console.log(variable6);
}

function17();
console.log(variable6);

var variable8 = 30;
function function18() {
    var variable8 = "hello";
    function innerFunction(){
        console.log(variable8); //"hello"
        console.log(window.variable8); //30
    }
    innerFunction();
}
function18();

var variable9 = 10;
function function19() {
    console.log(variable9); //undefined
    var variable9 = 20;
}
function19();


var variable10 = 10;
function function20() {
    console.log(variable11); //undefined
    var variable11 = 20;
}
function20();

function function21() {
    // console.log(variable12); //Uncaught ReferenceError: variable12 is not defined
    variable12 = 20;
}
function21();
console.log(variable12); //20

function function22() {
    innerFunction(); //innerFunction
    function innerFunction() {
        console.log("innerFunction");
    }
}
function22();

function function23() {
    // innerFunction(); //Uncaught TypeError: innerFunction is not a function
    var innerFunction = function () {
        console.log("innerFunction");
    }
}
function23();

//定义形参相当于在函数作用域中声明变量
var variable11 = 10;
function function24(variable11) {
    console.log(variable11); //undefined
}
function24();

var variable12 = 10;
function function25() {
    console.log(variable12); //10
    variable12 = 20;
}
function25();
console.log(variable12); //20

var variable13 = 10;
function function26(variable13) {
    console.log(variable13); //undefined
    variable13 = 20;
}
function26();
console.log(variable13); //10

var variable14 = 10;
function function26(variable14) {
    console.log(variable14); //undefined
    variable14 = 20;
}
function26(variable14);
console.log(variable14); //10
*/

/**
 * 解析器在调用函数时每次都会向函数传递一个隐形参数this
 * this指向一个对象，这个对象为函数执行的上下文对象
 * 函数的调用方式不同，this会指向不同的对象
 *     1、以函数的方式调用时，this指向window
 *     2、以对象方法的方式调用时，this指向调用方法的对象
 *     3、当以构造函数的方式调用时，this指向新创建的对象
 * */

/*
function function27() {
    console.log(this);
}
function27(); //window

function function28() {
    console.log(this);
}

var people = {
    name:"David",
    function:function28
};

console.log(people.function == function28);
people.function(); //object
function28(); //window

var studentName = "Lucy";
function function29() {
    console.log(this.studentName);
}

var student1 = {
    studentName:"David",
    function:function29
};

var student2 = {
    studentName:"Marry",
    function:function29
};

student1.function(); //"David"
student2.function(); //"Marry"
function29(); //Lucy
*/

/**
 * 函数对象方法
 * 调用function()、function.call()、function.apply()都会调用函数执行
 *     (1) 在调用call()和apply()时，可以将一个对象指定为第一个参数，此时这个对象称为函数执行时的this
 *     (2) call()方法可以将实参在对象之后依次传递，apply()方法需要将实参封装在数组中统一传递
 *
 * this使用总结
 * 1、以函数方式调用时，this永远都是window；
 * 2、以方法方式调用时，this是调用方法的对象
 * 3、以构造函数方式调用时，this是新创建的对象
 * 4、以call()、apply()方式调用时，this是指定的那个对象
 * 5、以事件响应函数的方式被触发时，this是绑定事件响应函数的元素
 * */

/*
var object1 = {
    name:"Lucy",
    getName:function () {
        console.log(this.name);
    }
};

var object2 = {
    name:"David"
};

function function30() {
    console.log(this);
}
function30();
function30.call(); //window
function30.call(object1); //{name: "Lucy", getName: ƒ}
function30.apply(object1); //{name: "Lucy", getName: ƒ}
object1.getName(); //Lucy
object1.getName.apply(object2); //David

function function31(value1,value2) {
    console.log(value1);
    console.log(value2);
    console.log(this);
}

function31.call(object2); //undefined undefined {name: "David"}
function31.call(object2,10,20); //10 20 {name: "David"}
function31.apply(object2); //undefined undefined {name: "David"}
// function31.apply(object2,10,20); //Uncaught TypeError: CreateListFromArrayLike called on non-object
function31.apply(object2,[10,20]); //10 20 {name: "David"}
*/

/**
 * 在调用函数时，浏览器每次都会传递两个隐含的参数
 * 1、函数的上下文对象this；
 * 2、封装实参的对象arguments
 *    arguments是一个类数组对象，可以通过索引操作数据，
 *    在调用函数时，传递的实参都会在arguments中保存
 *    可以获取arguments.length获取实参长度
 *    即使不定义形参，也可以通过arguments来获取实参，即使定义形参，arguments.length表示传递的实参个数，而不管定义的形参个数
 *    arguments.callee()对应当前正在执行的函数对象
 * */

/*
function function32() {
    // console.log(arguments);
    // console.log(arguments instanceof Array); //false
    // console.log(Array.isArray(arguments)); //false
    console.log("length:"+arguments.length+"---"+arguments[1]);
}

function32(10,20); //length:2---20
function32(10); //length:1---undefined

function function33(value1,value2,value3) {
    console.log(arguments.callee == function33); //true
    console.log("length:"+arguments.length+"---"+arguments[1]);
}

function33(); //length:0---undefined
function33(10); //length:1---undefined
*/