package main //表示hello.go文件所在的包为main，在go中，每一个文件都必须归属于一个包
//import "fmt" //表示引入一个包，包名为fmt，引入后就可以使用包中的函数

//引入多个包时可以单行引入，也可以按照下面方式引入
//如果没有用到某个包，编译时会报错，但是又不想删除，可以在前面使用"_"表示忽略
import (
	"fmt"
	"unsafe"
	"strconv"
)

/*
go语言定义过的变量或者import的包，如果没有用到则不能编译通过
go语言严格区分大小写
go语言每个语句之后不需要分号
gofmt -w hello.go 可以格式化文件
*/

/*
方式一：
go build hello.go
./hello

go build -o myhello hello.go
./myhello
方式二：
go run hello.go
*/

//定义全局变量方式一
var m1 = 10
var m2 = "David"

//定义全局变量方式二
var (
	p = 10
	q = "Lucy"
)

/**
* 主要内容：
* 1、数据类型
* 2、数据类型的转换
*/
func main() {
	fmt.Println("Hello world")

	//单个变量声明方式一
	var number int = 10
	fmt.Println("number=",number)	//10

	//单个变量声明方式二
	//整型的默认类型为int，32位系统为4个字节，64位系统为8个字节
	//整型的默认值为0
	var age = 10
	fmt.Println(age)	//10

	//单个变量声明方式三
	count := 10
	fmt.Println(count)	//10

	//多个变量声明方式一
	var n1, n2 int
	fmt.Println(n1 + n2)	//0

	//多个变量声明方式二
	var a, b, c = 1, "hello", 20.0
	fmt.Println(a,b,c)	//1 hello 20

	//多个变量声明方式三
	name, age := "Darren", 18
	fmt.Println(name,age)	//Darren 18
	
	//打印全局变量
	fmt.Println(m1,q)	//10 Lucy

	var x = 10
	//fmt.Printf()可以用于格式化输出，%T可以输出变量的类型
	fmt.Printf("x的类型%T\n",x)		//x的类型int
	fmt.Printf("x占用的字节数%d\n",unsafe.Sizeof(x))	//x占用的字节数8

	//浮点型的默认类型为float64，8位字节，不受32位或64位系统影响
	//浮点型的默认值为0
	var y = 10.5
	fmt.Printf("y的类型%T\n",y)		//y的类型float64
	fmt.Printf("y占用的字节数%d\n",unsafe.Sizeof(y))	//y占用的字节数8

	//go语言中没有字符类型，如果保存的字符在ASCII表中，可以使用byte保存，
	//如果字符对应的码值超过255，则可以使用int保存
	//go语言中的字符使用UTF-8编码,UTF-8编码中英文字母使用一个字节表示，中文使用三个字节表示
	var char1 byte = 'a'
	//直接输出byte值，会输出对应字符的UTF-8编码码值
	fmt.Println(char1)  		//97
	//如果需要输出对应的字符，则需要使用格式化输出
	fmt.Printf("%c\n",char1) 	//'a'
	fmt.Printf("char1占用的字节数%d\n", unsafe.Sizeof(char1))	//1

	/*
	* overflows byte
	var char2 byte = '北'
	fmt.Println(char2)
	fmt.Printf(char2)
	*/

	var char3 int = '北'
	fmt.Println(char3)			//21271
	fmt.Printf("%c\n",char3)	//'北'
	//如果给变量赋值一个数字，然后按照格式化%c输出时，会输出该数字对应的unicode字符
	fmt.Printf("%c\n",21271)	//'北'

	//字符类型可以按照UTF-8编码码值进行计算
	var char4 byte = 'a'
	fmt.Printf("%d\n", char4)	//97
	var result = char4 + 10
	fmt.Println(result)			//107
	

	//bool类型占用1个字节的存储空间
	//bool类型默认值为false
	var m = false
	fmt.Println(m)	//false
	fmt.Printf("%t\n",m)	//false
	fmt.Println(unsafe.Sizeof(m))	//1
	//bool类型只能取true或false，不能使用0或非0的数字代替
	//m = 1

	/**
	* 字符串默认值为""
	* 字符串的两种表示方式
	* 1、双引号，会识别转义字符
	* 2、反引号，会以字符串的原生形式输出，包括换行和特殊字符，可以防止攻击，输出源代码等
	*/
	var str1 string = "hello world"
	fmt.Println(str1)	//hello world

	/*
	var str2 string = `
		package main //表示hello.go文件所在的包为main，在go中，每一个文件都必须归属于一个包
		//import "fmt" //表示引入一个包，包名为fmt，引入后就可以使用包中的函数
		
		//引入多个包时可以单行引入，也可以按照下面方式引入
		import (
			"fmt"
			"unsafe"
		)
	`
	fmt.Println(str2)
	*/

	//字符串拼接
	var str3 string = "How " + "are " + "you?"
	fmt.Println(str3)	//How are you?

	//当字符串很长时，可以分行写，但是需要将"+"号保留在行尾，不能在行首
	var str4 string = "Hello world " + "How are you? " + "Thank you! " +
					  "Hello world " + "How are you? " + "Thank you! " +
					  "Hello world " + "How are you? " + "Thank you! "
	fmt.Println(str4)	//Hello world How are you? Thank you! Hello world How are you? Thank you! Hello world How are you? Thank you! 
	
	//基本数据类型的默认值
	var defaultInt int  //0
	var defaultFloat32 float32  //0
	var defaultFloat64 float64  //0
	var defaultBool bool  //false
	var defaultByte byte  //0
	var defaultString string  //""
	//%v表示按照变量的原值输出
	fmt.Printf("defaultInt=%v\ndefaultFloat32=%v\ndefaultFloat64=%v\ndefaultBool=%v\ndefaultByte=%v\ndefaultString=%v\n",
		defaultInt,defaultFloat32,defaultFloat64,defaultBool,defaultByte,defaultString)
	/*
	defaultInt=0
	defaultFloat32=0
	defaultFloat64=0
	defaultBool=false
	defaultByte=0
	defaultString=
	*/

	/*
	* 基本数据类型的转换
	* go中数据类型不能自动转换，需要显式转换
	* 表达式T(v)就是将变量v转换为类型T
	* 被转换的是变量存储的数据，变量本身的数据类型并没有变化
	* 在转换时，比如将int64转换为int8，编译时不会报错，只是转换的结果按照溢出处理，和希望的结果会不一样
	*/
	var originX int = 10
	var transformY = float64(originX)
	fmt.Println(transformY)		//10
	fmt.Printf("%T\n",transformY)	//float64
	
	var number64 int64 = 999999
	var number8 = int8(number64)
	fmt.Println(number8)	//63

	var testn1 int32 = 12
	var testn2 int8 = int8(testn1) + 127  //编译通过，但是运行时溢出
	//var testn3 int8 = int8(testn1) + 128  //128超过int8范围，编译不通过
	fmt.Println(testn2)		//-117

	//基本数据类型转string
	var basicInt int = 10
	var basicFloat float64 = 10.654
	var basicChar byte = 'a'
	var basicBool bool = true
	var transformStr string

	//方式一：使用fmt.Sprintf()
	transformStr = fmt.Sprintf("%d",basicInt)
	fmt.Printf("type:%T--%q\n",transformStr,transformStr)	//type:string--"10"

	transformStr = fmt.Sprintf("%f",basicFloat)
	fmt.Printf("type:%T--%q\n",transformStr,transformStr)	//type:string--"10.654000"

	transformStr = fmt.Sprintf("%c",basicChar)
	fmt.Printf("type:%T--%q\n",transformStr,transformStr)	//type:string--"a"

	transformStr = fmt.Sprintf("%t",basicBool)
	fmt.Printf("type:%T--%q\n",transformStr,transformStr)	//type:string--"true"

	//方式二：使用strconv包中的函数，10表示转换为10进制int类型
	transformStr = strconv.FormatInt(int64(basicInt),10)
	fmt.Printf("type:%T--%q\n",transformStr,transformStr)	//type:string--"10"

	//此方法也可以将int类型转string
	transformStr = strconv.Itoa(basicInt)
	fmt.Printf("type:%T--%q\n",transformStr,transformStr)	//type:string--"10"

	//'f'表示格式，10表示小数点保留10位，64表示这个数是float64类型
	transformStr = strconv.FormatFloat(basicFloat,'f',10,64)
	fmt.Printf("type:%T--%q\n",transformStr,transformStr)	//type:string--"10.6540000000"

	transformStr = strconv.FormatBool(basicBool)
	fmt.Printf("type:%T--%q\n",transformStr,transformStr)	//type:string--"true"

	//使用%s进行基本的字符串输出。
    fmt.Printf("%s\n", "\"string\"")	//"string"
	//像Go源代码中那样带有双引号的输出，使用%q。
    fmt.Printf("%q\n", "\"string\"")	//"\"string\""

	//string转基本数据类型
	//方式一：使用strconv包中的函数
	var boolStr string = "true"
	var transformBool bool
	//strconv.ParseBool(boolStr)返回两个函数值(value bool, err error)，可以使用_忽略第二个函数返回值
	transformBool, _ = strconv.ParseBool(boolStr)
	fmt.Printf("type:%T--%v\n",transformBool,transformBool)	//type:bool--true

	var intStr string = "1234"
	var transformInt int64
	//10表示转成十进制数，64表示转成64位数，如果为0则表示转成int
	//该函数的返回值为int64，如果需要返回其他整型，则可以再次进行基本数据类型转换
	transformInt, _ = strconv.ParseInt(intStr,10,64)
	fmt.Printf("type:%T--%v\n",transformInt,transformInt)	//type:int64--1234

	var floatStr string = "12.345"
	var transformFloat float64
	//该函数的返回值为float64，即使第二个参数设置为32，如果需要返回其他浮点型，则可以再次进行基本数据类型转换
	transformFloat, _ = strconv.ParseFloat(floatStr,64)
	fmt.Printf("type:%T--%v\n",transformFloat,transformFloat)	//type:float64--12.345

	//string转基本数据类型时要确保可以转成有效的数据，如果不能，则会转成要转换类型的默认值
	var transformString string = "hello"
	var transformIntValue int64
	transformIntValue, _ = strconv.ParseInt(transformString,10,64)
	fmt.Printf("type:%T--%v\n",transformIntValue,transformIntValue)		//type:int64--0

	var transformBoolValue bool = true
	transformBoolValue, _ = strconv.ParseBool(transformString)
	fmt.Printf("type:%T--%v\n",transformBoolValue,transformBoolValue)	//type:bool--false

	var transformFloatValue float64
	transformFloatValue, _ = strconv.ParseFloat(transformString, 64)
	fmt.Printf("type:%T--%v\n",transformFloatValue,transformFloatValue)	//type:float64--0
}