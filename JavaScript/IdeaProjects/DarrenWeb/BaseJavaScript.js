// alert("外部js文件代码");
// console.log("打印一下");

/**
 * 1、JS中严格区分大小写
 * 2、JS中每一条语句以分号;结束
 *    如果不写分号，浏览器会自动添加，但会消耗一定的系统资源，而且有的时候浏览器会添加错分号
 * 3、JS中会忽略多个空格和换行，可以利用空格和换行格式化代码
 * */

/**
 * 字面量，都是一些不可改变的值，字面量都是可以直接使用的，但是我们一般不会直接使用
 * 变量，可以用于保存字面量，并且变量的值可以任意改变，可以通过变量对字面量进行描述，变量可以更方便的使用，
 * 在开发中都是通过变量保存一个字面量，而很少直接使用字面量
 * JS中使用var关键字声明一个变量
 * */

/*
var a;
a = 123;
var age = 18;
console.log(a);
console.log(age);
*/

/**
 * 标识符需要遵守如下规则：
 * 1、标识符可以包含数字、字母、下划线、$
 * 2、标识符不能以数字开头
 * 3、标识符不能是ES中的关键字和保留字
 * 4、标识符一般采用驼峰命名法
 * JS底层保存标识符时实际上采用的是Unicode编码，所以理论上讲所有的UTF-8中的内容都可以作为标识符
 * */

/**
 * 在JS中一共有6中数据类型
 * string    字符串
 * number    数字
 * boolean   布尔
 * null      空值
 * undefined 未定义
 * Object    对象
 * 其中string、number、boolean、null、undefined属于基本数据类型，而Object属于引用数据类型
 * */

/**
 * string字符串
 * 在JS中字符串使用引号引起来
 * 使用双引号和单引号，但是不要混着用
 * 引号不能嵌套
 * 在字符串中可以使用\作为转义字符
 * 在EcmaScript 6中可以使用反引号`引起来，可以支持换行和拼接变量
 * */

/*
var str1 = '我说："吃饭啦"';
var str2 = "他说：'好的'";
var str3 = "我说：\"好开心\"";

console.log(str1);
console.log(str2);
console.log(str3);
console.log(typeof str1);
*/

/**
 * 在JS中所有的数值都是number类型，包括整数和浮点数
 * 可以使用运算符typeof来检查变量的类型，语法：typeof 变量，typeof是一个运算符，它会将变量的类型以字符串的方式返回
 * Number.MAX_VALUE -> 1.7976931348623157e+308，表示最大的正值
 * Number.MIN_VALUE -> 5e-324，表示最小正值
 * JS中使用Infinity，表示正无穷，使用-Infinity表示负无穷，它是一个字面量，使用typeof检查Infinity类型也会返回number
 * NaN，是一个特殊的数字，表示Not A Number，是一个字面量，使用typeof检查Infinity类型也会返回number
 * 在JS中整数的运算基本可以保证正确，如果使用JS进行浮点数运算，可能得到一个不精确的结果
 * */

/*
var a = 123;
var b = "123";
var c = Infinity;
var d = "abc" * "bcd";
var e = NaN;
console.log(a);
console.log(typeof a);
console.log(b);
console.log(typeof b);
console.log(Number.MAX_VALUE);
console.log(typeof c);
console.log(d);
console.log(typeof e);
console.log(Number.MIN_VALUE);
console.log(0.1 + 0.2); //0.30000000000000004
var variable = 123;
var result = typeof variable;
console.log(result);
console.log(typeof result);
*/

/**
 * boolean 布尔值
 * true、false
 * */

/*
var bool = false;
console.log(bool);
console.log(typeof bool);
*/

/**
 * null 空值
 * null类型的值只有null一个，表示空对象
 * 使用typeof检查null类型的变量时返回object
 * */

/*
var a = null;
console.log(a);
console.log(typeof a);//object
*/

/**
 * undefined 未定义
 * undefined类型的值只有undefined一个
 * 当声明一个变量，但是并不给变量赋值时，它的值就是undefined
 * 使用typeof检查undefined类型的变量时返回undefined
 * */

/*
var a = undefined;
var b;
console.log(a);
console.log(typeof a);
console.log(b);
console.log(typeof b);
*/

/**
 * 强制类型转换
 * 1、转换为string类型
 *      (1) 调用被转换数据类型的toString()方法，该方法不会影响原变量，会将转换的结果返回
 *          number类型数据调用toString()方法直接转换为对应的字符串
 *          boolean类型数据调用toString()方法返回值对应的字符串，true -> "true"，false -> "false"
 *          null和undefined类型没有toString()方法，如果调用会报错
 *      (2) 调用String()函数，将被转换的数据作为参数传递给函数，该方法不会影响原变量，会将转换的结果返回
 *          使用String()函数做强制转换时，对于number和boolean类型数据来说实际上就是调用toString()方法
 *          对于null类型数据来说直接返回"null"，对于undefined类型数据来说直接返回"undefined"
 * 2、转换为number类型
 *      (1) 调用Number()函数
 *          <1> string转number
 *              如果是纯数字的字符串，则将其直接转换为数字；
 *              如果字符串中有非数字内容，则将其转换为NaN；
 *              如果字符串是一个空字符串或者是一个全是空格的字符串，则转换为数字0
 *          <2> boolean转number
 *              true  ->  1
 *              false ->  0
 *          <3> null转number
 *              null  ->  0
 *          <4> undefined转number
 *              undefined -> NaN
 *      (2) parseInt()、parseFloat()
 *          对字符串使用parseInt()、parseFloat()方法可以将字符串中的有效的整数和小数内容取出来
 *          对非字符串使用parseInt()、parseFloat()方法先将其转换为string，然后再操作
 * 3、转换为boolean类型
 *      (1) 使用Boolean()函数
 *          <1> number转boolean，除了0转换为false，其余都为true
 *          <2> string转boolean，除了空字符串为false，其余都为true
 *          <3> null、undefined都会转换为false
 *          <4> object也会转换为true
 *      (2) 隐士类型转换
 *          为任意数据类型进行两次逻辑非运算，将其转换为boolean值
 * */

/*
var number1 = 123;
var number2 = number1.toString();
console.log(number2); //"123"
console.log(typeof number2); //string

var flag1 = true;
var flag2 = flag1.toString()
console.log(flag2); //"true"
console.log(typeof flag2); //string

var null1 = null;
var null2 = null1.toString(); //Uncaught TypeError: Cannot read property 'toString' of null
console.log(typeof null1); //object
console.log(typeof null2);

var undefined1 = undefined;
var undefined2 = undefined1.toString(); //Uncaught TypeError: Cannot read property 'toString' of undefined
console.log(typeof undefined1); //undefined
console.log(typeof undefined2);

var strNumber = 123;
var string = String(strNumber);
console.log(string); //"123"
console.log(typeof string); //"string"

var nullFlag = null;
var nullString = String(nullFlag);
console.log(nullString); //"null"
console.log(typeof nullFlag); //object
console.log(typeof nullString); //string

var undefined3 = undefined;
var undefinedStr = String(undefined3);
console.log(undefinedStr); //"undefined"
console.log(typeof undefined3); //undefined
console.log(typeof undefinedStr); //string

var numberStr = "123";
var number1 = Number(numberStr);
console.log(typeof number1); //number

var charStr = "abc";
var number2 = Number(charStr);
console.log(number2); //NaN
console.log(typeof number2); //number

var blankStr = "";
var number3 = Number(blankStr);
console.log(number3); //0
console.log(typeof number3); //number

var spaceStr = "  ";
var number4 = Number(spaceStr);
console.log(number4); //0
console.log(typeof number4); //number

var null3 = null;
var number5 = Number(null3);
console.log(number5); //0
console.log(typeof number5); //number

var undefined4 = undefined;
var undefineNumber = Number(undefined4);
console.log(undefineNumber); //NaN
console.log(typeof undefineNumber); //number

var parseStr1 = "90px";
var parseNumber1 = parseInt(parseStr1);
console.log(parseNumber1); //90
console.log(typeof parseNumber1); //number

var parseStr2 = "123px321";
var parseNumber2 = parseInt(parseStr2);
console.log(parseNumber2); //123
console.log(typeof parseNumber2); //number

var parseStr3 = "a123p321";
var parseNumber3 = parseInt(parseStr3);
console.log(parseNumber3); //NaN
console.log(typeof parseNumber3); //number

var parseStr4 = "123.456p321";
var parseNumber4 = parseInt(parseStr4);
console.log(parseNumber4); //123
console.log(typeof parseNumber4); //number

var parseStr5 = "123.456p321";
var parseNumber5 = parseFloat(parseStr5);
console.log(parseNumber5); //123.456
console.log(typeof parseNumber5); //number

var parseStr6 = "123.456.321";
var parseNumber6 = parseFloat(parseStr6);
console.log(parseNumber6); //123.456
console.log(typeof parseNumber6); //number

var parseBoolean = true;
var parseNumber7 = parseInt(parseBoolean);
console.log(parseNumber7); //NaN
console.log(typeof parseNumber7); //number

var parseNull = null;
var parseNumber7 = parseInt(parseNull);
console.log(parseNumber7); //NaN
console.log(typeof parseNumber7); //number

var parseUndefined = undefined;
var parseNumber8 = parseInt(parseUndefined);
console.log(parseNumber8); //NaN
console.log(typeof parseNumber8); //number

var numberVariable1 = 123;
var boolVariable1 = Boolean(numberVariable1);
console.log(boolVariable1); //true
console.log(typeof boolVariable1); //boolean

var numberVariable2 = -123;
var boolVariable2 = Boolean(numberVariable2);
console.log(boolVariable2); //true
console.log(typeof boolVariable2); //boolean

var numberVariable3 = 0;
var boolVariable3 = Boolean(numberVariable3);
console.log(boolVariable3); //false
console.log(typeof boolVariable3); //boolean

var numberVariable4 = Infinity;
var boolVariable4 = Boolean(numberVariable4);
console.log(boolVariable4); //true
console.log(typeof boolVariable4); //boolean

var numberVariable5 = -Infinity;
var boolVariable5 = Boolean(numberVariable5);
console.log(boolVariable5); //true
console.log(typeof boolVariable5); //boolean

var stringVariable1 = "hello";
var boolVariable8 = Boolean(stringVariable1);
console.log(boolVariable8); //true
console.log(typeof boolVariable8); //boolean

var stringVariable2 = "";
var boolVariable9 = Boolean(stringVariable2);
console.log(boolVariable9); //false
console.log(typeof boolVariable9); //boolean

var stringVariable3 = " ";
var boolVariable10 = Boolean(stringVariable3);
console.log(boolVariable10); //true
console.log(typeof boolVariable10); //boolean

var nullVariable1 = null;
var boolVariable11 = Boolean(nullVariable1);
console.log(boolVariable11); //false
console.log(typeof boolVariable11); //boolean

var undefinedVariable1 = undefined;
var boolVariable12 = Boolean(undefinedVariable1);
console.log(boolVariable12); //false
console.log(typeof boolVariable12); //boolean
*/

/**
 * 在JS中，如果需要表示16进制的数字，需要以0x开头；
 *        如果需要表示8进制的数字，需要以0开头；
 *        如果需要表示2进制的数字，需要以0b开头，但是不是所有的浏览器支持
 * 像"070"这种字符串，有些浏览器会当作8进制解析，有些浏览器会当作10进制解析
 *
 * */

/*
var parseStr = "070";
var parsed8Number = parseInt(parseStr,8);
var parsed10Number = parseInt(parseStr,10);
console.log(parsed8Number); //56
console.log(parsed10Number); //70
*/

/**
 * 算术运算符
 * 1、做-、*、/运算时，都会将值转换为number再进行运算
 *    可以将任意数据类型通过- 0、* 1、/ 1三种方式将其转换为数字类型，和使用Number()函数类似
 * 2、做+运算时
 *    (1) 任何值与字符串进行"+"运算时，字符串拼接，包括NaN、undefined、true、false
 *        可以将任意数据类型通过+""转换为字符串，这是一种隐士类型转换，和使用String()函数类似
 *    (2) 任何值与NaN进行运算，都返回NaN，NaN与string进行"+"运算除外
 *    (3) 当对非number类型的值进行运算时，会将这些值转换为number再进行运算
 *
 * 一元运算符+，-
 * 对于非number类型的值，先转换为number，再进行运算，可以对非number类型的值前面使用+，将其转换为number。和使用Number()类似
 *
 * 自增、自减
 * 1、a++的值等于原变量的值，++a的值等于变量自增后的值，两种方式都会使原变量的值自增1
 * 2、a--的值等于原变量的值，--a的值等于变量自减后的值，两种方式都会使原变量的值自减1
 *
 * 逻辑运算符
 * 1、逻辑非！
 *    如果对非boolean值进行逻辑非运算，会将其转换为boolean值，在进行取反
 *    可以对任意类型数据进行两次取反，将其转换为boolean类型，和使用Boolean()函数类似
 * 2、逻辑与&&
 *    两个值中只要有一个值为false，就会返回false，如果第一个值为false，则不会检查第二个值
 *    如果第一个值为true，则返回第二个值，如果第一个值为false，则返回第一个值
 * 3、逻辑或||
 *    两个值中只要有一个值为true，就会返回true，如果第一个值为true，则不会检查第二个值
 *    如果第一个值为true，则返回第一个值，如果第一个值为false，则返回第二个值
 *
 * 关系型运算符
 * 1、关系成立返回true，关系不成立返回false
 * 2、任何值与NaN比较都是false
 * 3、对于非number类型进行比较，会将其转换为number再进行比较，
 * 4、如果符号两端都是字符串时，不会将其转换为number进行比较，而是逐个比较字符串中字符的Unicode编码
 *    可以用来对英文进行排序
 *    注意：如果比较两个字符串型的数字时，可能会得到不可预期的结果，一定要转型，可以在变量前使用+转型
 *    在JS中，字符串中使用转义字符输入Unicode编码，\u 后跟四位16进制编码
 *    在网页中使用&#编码:输入Unicode编码，其中编码为10进制
 * 5、相等运算符==
 *    如果比较的两个值类型不同，则会自动进行类型转换，转换为相同的类型，再进行比较
 *    NaN不和任何值相等，包括它本身，可以通过isNaN()来判断一个值是否为NaN
 *    注意：true=="1"、true==1、null==null、undefined==undefined、undefined==null成立
 *         NaN==NaN、null==0不成立
 * 6、不等运算符!=
 *    如果比较的两个值类型不同，则会自动进行类型转换，转换为相同的类型，再进行比较
 * 7、全等运算符===
 *    用来判断两个值是否全等，它与==运算符类型，不同的是它不会进行类型转换，如果两个值的类型不同，直接返回false
 * 8、不全等运算符!==
 *    用来判断两个值是否不全等，它与!=运算符类似，不同的是它不会进行类型转换，如果两个值的类型不同，直接返回false
 * 9、条件运算符
 *    条件表达式?语句1:语句2
 *    条件运算符在执行时，首先对条件表达式的值进行判断，
 *    如果该值为true，则执行语句1，并返回执行结果
 *    如果该值为false，则执行语句2，并返回执行结果
 *    如果条件表达式的结果为非boolean值，则会转换为boolean值
 *
 * */

/*
var nullVariable = NaN;
var variables1 = 1;
variables1 = undefined;
variables1 = true;
variables1 = null;
variables1 = "abc";
console.log(nullVariable % variables1);
console.log(nullVariable + variables1); //"NaNabc"
console.log(typeof (nullVariable + variables1)); //string
console.log(typeof nullVariable + variables1); //"numberabc"

var stringVariable1 = "123";
var variables2 = 10;
console.log(stringVariable1 + variables2); //"12310"
console.log(stringVariable1 - variables2); //113

var variable3 = "hello";
console.log(+variable3); //NaN

var varable4 = !! "hello";
console.log(varable4); //true
console.log(typeof varable4); //boolean

var result1 = 3 && 5;
console.log(result1); //5
var result2 = 5 && "hello";

console.log(result2); //"hello"
console.log(typeof result2); //string

var result3 = NaN && 3;
console.log(result3); //NaN
console.log(typeof result3); //number

var result4 = null && 1;
console.log(result4); //null
console.log(typeof result4); //object

var result5 = undefined && 1;
console.log(result5); //undefined
console.log(typeof result5); //undefined

var result6 = 3 || 5;
console.log(result6); //3

var result7 = 5 || "hello";
console.log(result7); //5
console.log(typeof result7); //number

var result8 = NaN || 3;
console.log(result8); //3
console.log(typeof result8); //number

var result9 = null || -1;
console.log(result9); //-1
console.log(typeof result9); //number

var result10 = undefined || "1";
console.log(result10); //"1"
console.log(typeof result10); //string

console.log(1 >= true); //true
console.log(1 < false); //false
console.log(1 > "0"); //true
console.log(1 > null); //true
console.log(1 < "hello"); //false
console.log(1 >= "hello"); //false
console.log("a" > "b"); //false
console.log("a" < "A"); //true
console.log("ad" < "abc") //false
console.log("123" < "5"); //true
console.log("123" < +"5"); //false
console.log(+"123" < "5"); //false
console.log("\u2620");
console.log(NaN == NaN); //false
console.log(null == null); //true
console.log(undefined == undefined); //true
console.log("1" == 1); //true
console.log(true == "1"); //true
console.log(true == 1); //true
console.log(null == 0); //false
console.log(undefined == null); //true
console.log(NaN == 0); //false
console.log(isNaN(NaN)); //true
console.log("1" === 1); //false
console.log(null === undefined); //false
console.log(true === "1"); //false
console.log(true === 1); //false

var varable5 = 30;
var varable6 = 20;
var result11 = varable6 > varable5 ? varable6 : varable5;
console.log(result11);
"hello" ? console.log("hello") : console.log("blank"); //"hello"
"" ? console.log("blank") : console.log("hello"); //"hello"
" " ? console.log("blank") : console.log("hello"); //"blank"
*/

/**
 * 在JS中使用{}来为语句进行分组，{}中的语句也叫代码块
 * 在JS中{}只具有分组的作用
 * */

/*
{
    var variable7 = "hello";
}
console.log(variable7); //"hello"
*/

/**
 * prompt()函数可以弹出一个提示框，该提示框中带有一个文本框
 * 用户输入的内容会作为函数的返回值返回，类型为string
 * */

/*
var score = prompt("请输入成绩");
console.log(score);
*/

/**
 * switch...case...case语句，在执行的过程中会将switch后表达式的值与case后表达式的值进行全等比较
 * 如果比较结果为true，则从当前case处开始执行代码，当前case后所有的代码都会被执行，可以在case后面跟break退出switch语句
 * 如果比较结果为false，则会继续向下比较
 *
 * */

/*
var switchVarious = 1;
switch (switchVarious) {
    case 1:
        console.log("一");
    case 2:
        console.log("二");
    case 3:
        console.log("三");
    default:
        console.log("~~");
}
// "一"
// "二"
// "三"
// "~~"

var scoreNumber = 70;
switch (true) {
    case scoreNumber > 60:
        console.log("合格");
        break
    default:
        console.log("不合格");
        break;
}
*/

/**
 * break关键字可以用于退出switch和循环语句，不能在if语句中使用break和continue，break关键字退出离它最近的循环语句
 * 可以为循环语句创建一个标签，使用break关键字时，可以在break后面跟着循环的标签，从而可以使break退出指定循环
 * continue关键字可以用来跳过当次循环，默认只会对离它最近的循环起作用
 * 可以为循环语句创建一个标签，使用continue关键字时，可以在continue后面跟着循环的标签，从而可以使continue退出指定循环当次循环
 * */

/*
for (var i = 0; i < 3; i++){
    console.log("外层循环");
    for (var j = 0; j < 2; j++){
        break;
        console.log("内层循环");
    }
}
// 外层循环
// 外层循环
// 外层循环

outer:
for (var i = 0; i < 3; i++){
    console.log("外层循环");
    for (var j = 0; j < 3; j++){
        break outer;
        console.log("内层循环");
    }
}
//外层循环

for (var i = 0; i < 3; i++){
    console.log("外层循环"+i);
    for (var j = 0; j < 3; j++){
        if (j == 1){
            continue;
        }
        console.log("内层循环"+j);
    }
}
// 外层循环0
// 内层循环0
// 内层循环2
// 外层循环1
// 内层循环0
// 内层循环2
// 外层循环2
// 内层循环0
// 内层循环2

outer:
for (var i = 0; i < 3; i++){
    console.log("外层循环"+i);
    for (var j = 0; j < 3; j++){
        if (j == 1){
            continue outer;
        }
        console.log("内层循环"+j);
    }
}
// 外层循环0
// 内层循环0
// 外层循环1
// 内层循环0
// 外层循环2
// 内层循环0
*/

/**
 * console.time()可以用于开启一个计时器，字符串参数用于标记计时器
 * console.timeEnd()可以用于停止一个计时器，字符串参数用于标记暂停哪个计时器
 * 可以通过Math.sqrt()对一个数进行开方
 * */
/*
console.time("time");
console.timeEnd("time");
console.log(Math.sqrt(36));
*/