package main
import (
	"fmt"
	"../utils"
	"strings"
)

/**
init函数
每一个源文件都可以包含一个init函数，该函数会在main函数执行前，被Go运行框架调用
1、如果一个文件同时包含全局变量定义，init函数和main函数，则执行流程是全部变量定义->init函数->main函数
2、init函数最主要的作用是完成一些初始化的工作
*/

/**
匿名函数
golang支持匿名函数
使用方式一：在定义匿名函数时直接调用，这种方式匿名函数只能调用一次
使用方式二：将匿名函数赋值给一个全局变量，再通过该变量来调用匿名函数
*/
var (
	age = test()
	//全局匿名函数
	Func = func (n1 int, n2 int) int {
		return n1 + n2
	}
)

func test() int {
	fmt.Println("test()...")
	return 80
}

func init() {
	fmt.Println("init()...")
}

/**
闭包就是一个函数和与其相关的引用环境组合的一个整体
1、AddUpper是一个函数，返回的数据类型是 fun (int) int
2、返回的是一个匿名函数, 但是这个匿名函数引用到函数外的count
   因此这个匿名函数就和n形成一个整体，构成闭包
3、反复调用addFunc函数时，操作的是同一个闭包，
   因为count是初始化一次，因此每调用一次就进行累计；
   如果反复使用AddUpper()(1)，AddUpper()(2)调用时，
   操作的不是同一个闭包，count每次都初始化。因而不会累计
4、搞清楚闭包的关键，就是要分析出返回的函数所引用到哪些变量
   因为函数和它引用到的变量共同构成闭包
5、
*/
func AddUpper() func (int) int {
	var count int = 10
	return func (n int) int {
		count = count + n
		return count
	}
}

//返回的匿名函数和makeSuffix(suffix string)的suffix变量组合成一个闭包
//因为返回的函数引用到suffix这个变量
func makeSuffix(suffix string) func (name string) string{
	return func (name string) string {
		if !strings.HasSuffix(name, suffix) {
			return name + suffix
		}
		return name
	}
}

/**
1、当go执行到defer时，暂时不执行，会将defer后面的语句压入栈中
2、当函数执行完毕后，再从栈中按照先入后出的方式出栈，然后执行
3、在defer将语句压入栈中，会将相关的值拷贝同时入栈
*/
func deferSum(n1 int, n2 int) int {
	
	defer fmt.Printf("ok1 n1=%v\n", n1)
	defer fmt.Printf("ok2 n2=%v\n", n2)

	n1++
	n2++
	result := n1 + n2
	fmt.Printf("ok3 result=%v n1=%v\n", result, n1)
	return result
}

func main()  {
	fmt.Println("main()...age=", age)
	fmt.Printf("age=%v, name=%v\n", utils.Age, utils.Name)

	//匿名函数使用方式一
	result := func (n1 int, n2 int) int{
		return n1 + n2
	}(10, 20)
	fmt.Println("result=",result)

	//匿名函数使用方式二
	myFunc := func (n1 int, n2 int) int {
		return n1 - n2
	}
	fmt.Printf("result=%v\n",myFunc(50,30))
	fmt.Printf("result=%v\n",myFunc(10,30))
	fmt.Printf("result=%v\n",Func(60,30))

	addFunc := AddUpper()
	result1 := addFunc(1)
	fmt.Printf("result1=%v\n",result1)
	result1 = addFunc(2)
	fmt.Printf("result1=%v\n",result1)
	result1 = addFunc(3)
	fmt.Printf("result1=%v\n",result1)

	result2 := AddUpper()(1)
	fmt.Printf("result2=%v\n",result2)
	result2 = AddUpper()(2)
	fmt.Printf("result2=%v\n",result2)
	result2 = AddUpper()(3)
	fmt.Printf("result2=%v\n",result2)

	suffixFunc := makeSuffix(".jpg")
	result3 := suffixFunc("winter")
	fmt.Printf("result3=%v\n",result3)
	result3 = suffixFunc("bird.jpg")
	fmt.Printf("result3=%v\n",result3)

	result4 := deferSum(10, 20)
	fmt.Printf("result4=%v\n", result4)

	//127
}