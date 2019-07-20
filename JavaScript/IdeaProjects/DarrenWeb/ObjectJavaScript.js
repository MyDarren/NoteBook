/**
 * 对象属于一种复合的数据类型，在对象中可以保存多个不同数据类型的属性
 * 对象的分类：
 *    1、内建对象
 *       由ES标准中定义的对象，在任何ES的实现中都可以使用，如Math、String、Number、Boolean、Function、Object、、、
 *    2、宿主对象
 *       由JS运行环境提供的对象，主要指浏览器提供的对象，如BOM(浏览器对象模型)、DOM(文档对象模型)
 *    3、自定义对象
 *
 * 创建对象
 *    1、使用new关键字调用的函数，是构造函数constructor，构造函数是专门用来创建对象的函数
 *    2、向对象中添加属性，对象.属性名=属性值
 *       对象的属性名不强制要求遵守标识符的规范，但是还是尽量按照标识符的规范命名
 *       如果要使用特殊字符的属性名，不能使用.属性名的方式，而是使用 属性["属性名"] 的方式
 *       使用["属性名"]的方式去操作属性，更加灵活，在[]中可以传递一个变量，这样变量值是多少就会读取那个属性
 *    3、读取对象属性，对象.属性名，如果读取对象中没有的属性，不会报错而是返回undefined
 *    4、修改对象属性值，对象.属性名=属性值
 *       JS对象的属性值可以是任意的数据类型
 *       in运算符可以检查一个对象中是否有指定的属性，如果有则返回true，如果没有则返回false，语法：属性名 in 对象
 *    5、删除对象属性，delete 对象.属性名
 *
 * 基本数据类型和引用数据类型
 *    1、JS中的变量都是保存在栈中的
 *    2、基本数据类型的值都是直接在栈内存中存储，值与值之间相互独立，修改一个变量的值不会影响其他变量的值
 *       当比较基本数据类型的值时，比较的是变量的值
 *    3、对象是存储在堆内存中的，每创建一个对象都会在堆内存中开辟一个新的空间，而变量保存的是对象的内存地址，即保存对象的引用
 *       如果两个变量保存的是同一个对象地址，通过一个变量修改对象属性时，另外一个也会受影响，
 *       可以通过设置变量的值为nul来取消引用，不影响其他变量对该对象的引用
 *       当比较引用数据类型的值时，比较的是对象的内存地址，如果两个对象一模一样但是内存地址不同，返回false
 *
 * 对象字面量
 *    1、通过对象字面量创建对象，使用对象字面量创建对象时，可以直接指定对象的属性
 *       语法：{属性名:属性值,属性名:属性值...}
 *       对象字面量的属性名可以加引号，也可以不加，建议不加，如果要使用一些特殊的属性名，必须加引号
 * */

/*
var obj1 = new Object();
var variable1 = "123";
obj1.name = "Lucy";
obj1.gender = "男";
obj1.age = 18;
obj1["123"]=20;
delete obj1.gender;
console.log(obj1);
console.log(typeof obj1); //object
console.log(obj1.name);
console.log(obj1.gender);
console.log(obj1["123"]);
console.log(obj1[variable1]);
console.log("sex" in obj1);

var variable2 = variable1;
variable1 = "456";
console.log(variable1); //456
console.log(variable2); //123

var obj2 = obj1;
obj1.age = 20;
console.log(obj1.age); //20
console.log(obj2.age); //20
obj2 = null;
console.log(obj1); //Object
console.log(obj2); //null

var variable3 = 10;
var variable4 = 10;
console.log(variable3 == variable4); //true

var obj3 = new Object();
var obj4 = new Object();
console.log(obj3 == obj4); //false

var obj5 = {};
obj5.name = "David";
console.log(obj5); //Object
console.log(typeof obj5); //object
console.log(obj5.name); //David

var obj6 = {"name":"Ketty","age":20,"sex":"男",score:100};
console.log(obj6);
console.log(obj6.name);
console.log(obj6.score);
*/

/**
 * 对象的属性值可以是任意数据类型，也可以是函数
 * 函数可以作为对象的属性，如果将一个函数作为对象的属性保存，则将这个函数称为对象的方法，调用这个函数即为调用函数的方法
 * 可以使用for...in语句枚举对象的属性
 */

/*
var student = {
    name:"Ketty",
    age:20,
    sex:"女"
};

student.getName = function () {
    console.log(student.name);
};

console.log(student.getName);
student.getName();

for (var variable in student){
    console.log(variable);
    console.log(student[variable]);
}
*/

/**
 * 使用工厂方法创建对象
 * 使用工厂方法创建的对象，使用的构造函数都是object，创建的对象都是object类型，导致无法区分不同类型的对象
 * */

/*
function createPeople(name) {
    return {
        name:name,
        getType:function () {
            console.log(this);
            console.log(typeof this);
        }
    };
}

var person1 = createPeople("Lucy");
person1.getType(); //{name: "Lucy", getType: ƒ} object

function createDog(name) {
    return {
        name:name,
        getType:function () {
            console.log(this);
            console.log(typeof this);
        }
    };
}

var dog1 = createDog("Kitty");
dog1.getType(); //{name: "Kitty", getType: ƒ} object
*/

/**
 * 1、构造函数，专门用来创建对象
 *    构造函数习惯上首字母大写
 *    构造函数和普通方式的调用方式不同，普通函数是直接调用，构造函数需要使用new关键字来调用
 * 2、构造函数的执行流程
 *     (1) 创建一个新的对象
 *     (2) 将新建的对象设置为函数的this，在构造函数中可以使用this引用新建的对象
 *     (3) 逐行执行函数中的代码
 *     (4) 将新建的对象作为返回值返回
 * 3、使用同一个构造函数创建的对象，称为一类对象
 *    使用instanceof检查一个对象是否是一个类的实例，如果是返回true，如果不是返回false，任何对象都是object子代
 * 4、构造函数中对象的方法如果在构造函数内部创建，构造函数每执行一次就会创建一次对象的方法，每个对象的方法都是唯一
 *    可以在构造函数外创建一个函数，并在构造函数中对象的方法指向该方法，从而使该类的对象共享同一个方法
 *    但是将函数定义在全局作用域，污染全局作用域的命名空间
 * */

/*
function Student(name) {
    this.name = name;
    this.getType = function () {
        console.log(this);
        console.log(typeof this);
    }
}

var student3 = Student("Lucy");
console.log(student3); //undefined
var student4 = new Student("David");
student4.getType(); //Student {name: "David", getType: ƒ} object
console.log(student3 instanceof Student); //false
console.log(student4 instanceof Student); //true

function run() {
    console.log("running...");
}

function Dog(name){
    this.name = name;
    this.getType = function () {
        console.log(this);
        console.log(typeof this);
    }
    this.run = run;
}

var dog2 = new Dog("Ketty");
dog2.getType(); //Dog {name: "Ketty", getType: ƒ} object
var dog3 = new Dog("Kitty");
console.log(dog2.getType == dog3.getType); //false
console.log(dog2.run == dog3.run); //true
*/

/**
 * 原型prototype
 * 1、每创建一个函数(包括普通函数和构造函数)，解析器都会向函数对象中添加一个prototype属性，这个属性指向函数的原型对象
 * 2、当函数以普通函数调用时，prototype没有什么作用
 *    当函数以构造函数方式调用时，它所构造的对象都有一个隐形的属性__proto__指向构造函数的原型对象
 * 3、所有同一个类的实例都可以访问构造函数原型对象
 *    可以将对象中共有的方法和属性设置在原型对象中，这样不用为每一个对象添加方法和属性，也不影响全局作用域
 *    使用in检查对象中是否含有某个属性时，如果对象中没有，原型中有，也会返回true
 *    可以使用对象的hasOwnProperty()检查对象本身是否含有某个属性
 * 4、原型对象也是对象，它也有原型，object对象原型为null
 *    当访问对象的方法和属性时，会在对象自身中寻找，如果有就直接使用，
 *    如果没有就会去原型对象中寻找，如果原型对象中有就直接使用，
 *    如果原型对象中也没有，则去原型对象的原型中寻找，直到找到object对象的原型，如果在object对象的原型中依然没有找到则返回undefined
 * */

/*
function testFunction() {

}
console.log(testFunction.prototype); //{constructor: ƒ}

function Food() {

}
console.log(Food.prototype); //{constructor: ƒ}
var food1 = new Food();
var food2 = new Food();
console.log(food1.__proto__); //{constructor: ƒ}
console.log(food1.__proto__ == Food.prototype); //true
console.log(food2.__proto__ == Food.prototype); //true
Food.prototype.name = "面包";
Food.prototype.getType = function (){
    console.log(this);
}
food1.name = "油条";
food1.getType(); //Food {name: "油条"}
console.log(food1.name); //"油条"
console.log(food2.name); //"面包"
console.log(food2.__proto__.name); //"面包"
console.log(food2.age); //undefined
food2.getType(); //Food {}
console.log("name" in food2); //true
console.log(food2.hasOwnProperty("name")); //false
console.log(food2.hasOwnProperty("hasOwnProperty")); //false
console.log(food2.__proto__.hasOwnProperty("hasOwnProperty")); //false
console.log(food2.__proto__.__proto__.hasOwnProperty("hasOwnProperty")); //true
console.log(food2.__proto__.__proto__.__proto__); //null

var milk = new Object();
console.log(milk.__proto__); //{constructor: ƒ, hasOwnProperty: ƒ, __lookupGetter__: ƒ, …}
console.log(milk.__proto__.__proto__); //null
*/

/**
 * 垃圾回收
 * 当一个对象没有变量或属性引用时，无法操作该对象，这个对象就是一个内存垃圾，内存垃圾会占用内存空间，导致程序变慢，必须进行清理
 * 在JS中拥有自动垃圾回收机制，会自动将这些垃圾对象从内存中销毁，不需要也不能进行垃圾回收的操作，只需要将不在使用的对象设置为null
 * */

/**
 * Date对象
 * 1、直接使用构造函数创建一个Date对象，表示代码执行的时间
 * 2、创建一个指定的时间，需要在构造函数中传递一个表示当前时间的字符串作为参数
 *    时间格式：月/日/年 时:分:秒
 * 3、getDate()获取日期对象是几日 (1 - 31)
 *    getDay()获取日期对象是周几 (0 - 6)，0表示周日
 *    getMonth()获取日期对象的月份 (0 - 11)，0表示一月，11表示十二月
 *    getFullYear()获取日期对象的完整年份
 *    getTime()获取从1970年1月1日至日期对象日期的毫秒数
 * */

/*
var date1 = new Date();
console.log(date1); //Wed Sep 26 2018 20:54:49 GMT+0800 (中国标准时间)
var date2 = new Date("9/26/2018 21:00:00");
console.log(date2);
console.log(date2.getDate()); //26
console.log(date2.getDay()); //3
console.log(date2.getFullYear()); //2018
console.log(date2.getTime()); //1537966800000
console.log(Date.now()); //获取当前时间的时间戳
*/

/**
 * Math和其他对象不同，不是一个构造函数，它属于工具类，不用创建对象，里面封装了数学运算相关的属性和方法
 * 1、Math对象的属性
 *     Math.PI 表示圆周率
 *     Math.E 表示算数常量e，即自然对数的底数(约等于2.718)
 *     Math.LI2 表示2的自然对数(约等于0.693)
 *     Math.LI10 表示10的自然对数(约等于2.302)
 *     Math.LOG2E 表示以2为底的e的对数(约等于1.414)
 *     Math.LOG10E 表示以10为底的e的对数(约等于0.434)
 *     Math.SQRT2 表示2的平方根(约等于1.414)
 *     Math.SQRT1_2 表示2的平方根的倒数(约等于0.707)
 * 2、Math对象的方法
 *     Math.abs(x) 表示数的绝对值
 *     Math.acos(x) 表示数的反余弦值
 *     Math.asin(x) 表示数的反正弦值
 *     Math.atan(x) 表示以介于-PI/2与PI/2弧度之间的数值来返回x的反正切值
 *     Math.cos(x) 表示数的余弦值
 *     Math.sin(x) 表示数的正弦值
 *     Math.tan(x) 表示数的正切值
 *     Math.exp(x) 表示e的指数
 *     Math.ceil(x) 表示向上舍入，向上取整
 *     Math.floor(x) 表示向下舍入，向下取整
 *     Math.round(x) 表示数四舍五入最接近的整数
 *     Math.random() 表示0～1的随机数 (0,1)
 *         生成0~x的随机数 Math.round(Math.random() * x)  [0,x]
 *         生成x~y的随机数 Math.round(Math.random() * (y - x) + x)  [x,y]
 *     Math.log(x) 表示数的自然对数(底为e)
 *     Math.max(x,y...) 表示多个数的最大值
 *     Math.min(x,y...) 表示多个数的最小值
 *     Math.pow(x,y) 表示x的y次幂
 *     Math.sqrt(x) 表示数的平方根
 * */

/*
console.log(Math.PI); //3.141592653589793
console.log(Math.SQRT1_2); //0.7071067811865476
console.log(Math.ceil(1.5)); //2
console.log(Math.floor(1.5)); //1
console.log(Math.round(Math.random() * 10));
console.log(Math.round(Math.random() * 99 + 1));
*/

/**
 * JS中为我们提供了三个包装类，通过这三个包装类可以将基本数据类型转换为对象
 * 1、String()，可以将基本数据类型字符串转换为String对象
 * 2、Number()，可以将基本数据类型的数字转换为Number对象
 * 3、Boolean()，可以将基本数据类型的布尔值转换为Boolean对象
 * 在实际开发中不会使用基本数据类型的对象，如果使用的话在进行一些比较的时候会带来一些不可预期的结果
 * 方法和属性只能添加给对象，不能添加给基本数据类型
 * 当使用基本数据类型调用属性和方法时，浏览器会使用包装类将其转换为对象，然后调用对象的属性和方法，调用完成以后再转换为基本数据类型
 * */

/*
var number1 = new Number(10);
console.log(typeof number1); //object
console.log(number1);

var number2 = 123;
console.log(typeof number2.toString());
console.log(number2.toString());
console.log(number2);
*/

/**
 * 字符串的相关方法
 * length获取字符串长度
 * charAt()返回指定位置的字符
 * charCodeAt()返回指定位置字符的Unicode编码
 * concat()连接字符串
 * indexOf()检索字符串，用于检查字符串中是否有指定内容，如果字符串中有该内容，则返回第一次出现的索引，如果没有返回-1
 *     可以使用第二个参数指定开始查找的位置
 * lastIndexOf()从后向前搜索字符串，可以使用第二个参数指定开始查找的位置
 * fromCharCode()根据字符编码获取字符
 * slice()从字符串中截取，不会影响原字符串，而是将截取的字符串返回
 *    参数一：开始截取的位置的索引，包括开始位置
 *    参数二：结束截取的位置的索引，不包括结束位置
 *           如果省略第二个参数，则从开始位置截取后面所有字符串，如果是负数，则从字符串尾部开始位置算起
 * substring()用于截取字符串
 *    参数一：开始截取的位置的索引，包括开始位置
 *    参数二：结束截取的位置的索引，不包括结束位置
 *           如果省略第二个参数，则从开始位置截取后面所有字符串；
 *           不能使用负值作为参数，如果是负数，则默认为0，并且如果第二个参数小于第一个参数，则两个参数交换
 * substr()用于截取字符串
 *    参数一：开始截取位置的索引，包括开始位置
 *    参数二：截取字符串的长度
 * toLowerCase()将字符串转换为小写
 * toUpperCase()将字符串转换为大写
 * splice()可以将字符串拆分为数组
 *    需要一个字符串作为参数，根据字符串去拆分成数组，如果参数为空字符串，则会把每个字符拆分为数组中的每一个元素
 * */

/*
var string1 = "Hello world";
console.log(string1.length); //
console.log(string1.charAt(6)); //"w"
console.log(string1.charCodeAt(6)); //119
console.log(String.fromCharCode(20035)); //"乃"
console.log(String.fromCharCode(0x2692)); //"⚒"
console.log(string1.concat("How are you?")); //"Hello worldHow are you?"
console.log(string1.indexOf("o")); //4
console.log(string1.indexOf("o",2)); //4
console.log(string1.indexOf("o",5)); //7
console.log(string1.lastIndexOf("o")); //7
console.log(string1.lastIndexOf("o",6)); //4
console.log(string1.indexOf("x")); //-1
console.log(string1.slice(0,5)); //"Hello"
console.log(string1.slice(0,-1)); //"Hello worl"
console.log(string1.substring(0,5)); //"Hello"
console.log(string1.substring(2,-1)); //"He"
console.log(string1.substring(2,0)); //"He"
console.log(string1.substring(-1,2)); //"He"
console.log(string1.substring(0,2)); //"He"
console.log(string1.substr(2,3)); //"llo"
console.log(string1.toLowerCase()); //"hello world"
console.log(string1.toUpperCase()); //"HELLO WORLD"

var string2 = "asb;123wds;909eu-q;ncw";
console.log(string2.split(";")); //["asb", "123wds", "909eu-q", "ncw"]
console.log("hello".split("")); //["h", "e", "l", "l", "o"]
*/