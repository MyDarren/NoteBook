package main
import "fmt"

/**
函数基本语法

 func 函数名 (形参列表) (返回值类型列表) {
	 执行语句...
	 return 返回值列表
 }

 go函数支持返回多个值
 1、如果返回多个值时，在接收时，希望忽略某个返回值，则使用_符号表示占位忽略
 	如果返回值只有一个，返回值类型列表可以不写()
 2、函数的命名遵循标识符命名规范，首字母不能是数字
 	首字母大写该函数可以被本包文件和其他包文件使用，类似public
 	首字母小写，只能被本包文件使用，其他文件不能使用，类似private
 3、函数中的变量是局部的，函数外不生效
 	基本数据类型和数组都是默认值传递的，即进行值拷贝，在函数内修改，不会影响到原来的值
 	如果希望函数内的变量能修改函数外的变量，可以传入变量的地址&，函数内以指针的方式操作变量
 4、golang函数不支持重载
 5、在golang中，函数也是一种数据类型
 	可以将函数赋值给一个变量，则该变量是一个函数类型的变量，通过该变量可以对函数进行调用
 	在golang中，函数可以作为形参并且调用
 5、golang支持自定义数据类型
 	基本语法：type 自定义数据类型 数据类型
	 例如：type myInt int
	 type myFunc func(int,int) int
 6、golang支持对函数返回值命名
 7、golang支持可变参数
	 //支持0到多个参数
	 func sum(args... int) int {

	 }
	 //支持1到多个参数
	 func sum(n1 int, args... int) int {

	 }
	//可变参数名称args可以用其他代替
	//如果一个函数的形参列表有可变参数，则可变参数需要放在形参列表最后
*/

type MyInt int
type myFuncType func(int, int) int

func getSumAndSub(n1 int, n2 int) (int, int){
	sum := n1 + n2
	sub := n1 - n2
	return sum, sub
}

func test01(number int) {
	number = number + 10;
	fmt.Println("test01:number =", number)
}

/*golang不支持重载
func test01(n1 int, n2 int) {
	number = n1 + n2;
	fmt.Println("test01:number =", number)
}
*/

func test02(number *int) {
	*number = *number + 10;
	fmt.Println("test02:number =", *number)
}

func testFunc(n1 int ,n2 int) int {
	return n1 + n2
}

func myFunc(funvar func(int,int) int, num1 int, num2 int) int {
	return funvar(num1, num2)
}

func myFunc2(funvar myFuncType, num1 int, num2 int) int {
	return funvar(num1, num2)
}

//支持对函数返回值命名
func cal(n1 int, n2 int) (sum int, sub int) {
	sum = n1 + n2
	sub = n1 - n2
	//不用写result sum, sub，顺序无关
	return
}

//可变参数
func mySum(n1 int, args... int) int {
	sum := n1
	for i := 0; i < len(args); i++ {
		sum += args[i]
	}
	return sum
}

//形参列表中如果前面的参数数据类型和后面的一样，则前面的参数类型可以省略
func myTest(n1, n2 int, n3 float32) float32 {
	fmt.Printf("n1的类型:%T\nn2的类型:%T\nn3的类型:%T\n", n1, n2, n3)
	return float32(n1) + float32(n2) + n3
}

func swap(n1 *int, n2 *int) {
	tmp := *n1
	*n1 = *n2
	*n2 = tmp
}

func main()  {
	n1 := 20
	n2 := 5
	result1, result2 := getSumAndSub(n1, n2)
	fmt.Printf("result1=%v\nresult2=%v\n", result1, result2)

	sum, _ := getSumAndSub(10, 5)
	fmt.Printf("sum=%v\n", sum)

	_, sub := getSumAndSub(10, 5)
	fmt.Printf("sub=%v\n", sub)

	number := 10
	test01(number)
	fmt.Println("main:number=", number)

	test02(&number)
	fmt.Println("main:number=", number)

	a := testFunc
	fmt.Printf("a的类型%T，testFunc的类型%T\n",a, testFunc)

	result3 := a(10, 20)
	fmt.Printf("result3=%v\n",result3)

	result4 := myFunc(testFunc, 50, 60)
	fmt.Printf("result4=%v\n",result4)

	var num1 MyInt = 10
	var num2 int = 20
	fmt.Printf("num1:%T\nnum2:%T\n",num1,num2)//num1:main.MyInt num2:int
	//需要做类型转换，golang认为MyInt和int是两种类型的数据
	num2 = int(num1)

	result5 := myFunc2(testFunc, 80, 60)
	fmt.Printf("result5=%v\n",result5)

	result6, result7 := cal(30, 20)
	fmt.Printf("result6=%v\nresult7=%v\n",result6,result7)

	result8 := mySum(10, 20, 30)
	fmt.Println("result8 =", result8)

	myTest(10, 20, 30)

	var number1 int = 10
	var number2 int = 30
	swap(&number1, &number2)
	fmt.Printf("number1=%v\nnumber2=%v\n", number1, number2)
}