package main 
import (
	"fmt"
)

func main() {

	/*
	var score int = 70
	if score > 60 {
		fmt.Println("及格")
	}else {
		fmt.Println("不及格")
	}

	var age int = 20
	if (age > 18) {
		fmt.Println("成年人")
	}else {
		fmt.Println("未成年")
	}

	//go语言支持在条件判断语句中直接声明一个变量，这个变量作用域只在该条件逻辑块中
	//另外，即使if语句中只有一行代码，也要添加{}，否则编译不通过，同时else不能换行写
	//if (age > 10) 或者 if age > 10 语法都支持，但是官方写法不带()，推荐使用
	if sex := 1; sex == 1 {
		fmt.Println("男")
	}else {
		fmt.Println("女")
	}
	//fmt.Println(sex)
	*/

	/*
	var b bool = false
	//syntax error: assignment b = true used as value
	//不能编译通过，if的条件表达式不能是赋值语句
	if b = true {
		fmt.Println("a")
	}else if b {
		fmt.Println("b")
	}else if !b {
		fmt.Println("c")
	}else{
		fmt.Println("d")
	}
	*/

	/**
	* switch语句用法
	* case后面表达式可以有多个，使用逗号隔开
	* case后面不需要break，默认情况下程序执行完case语句后退出switch语句
	* case后是一个表达式(即：常量值、变量、一个有返回值的函数都可以)
	* case后各个表达式的值的数据类型，必须和switch表达式的数据类型一致
	* case后的表达式如果是常量值，则要求不能重复
	* default语句不是必须的
	* switch 表达式 {
		case 表达式1, 表达式2:
			语句1
		case 表达式3, 表达式4:
			语句2
		default:
			语句块
	* }
	*/
	var sex int = 1
	switch sex {
		case 1, 3:
			fmt.Println("男")
		case 2 + 2:
			fmt.Println("女")
		default:
			fmt.Println("未知")
	}

	var score int = 70
	switch {
		case score > 90:
			fmt.Println("优秀")
		case score > 70 && score <= 90:
			fmt.Println("良好")
		case score >= 60:
			fmt.Println("及格")
		default:
			fmt.Println("不及格")
	}

	//在switch语句中可以直接声明一个变量，需要以分号结束
	switch grade := 90; {
		case grade > 90:
			fmt.Println("优秀")
		case grade > 70 && grade <= 90:
			fmt.Println("良好")
		case grade >= 60:
			fmt.Println("及格")
		default:
			fmt.Println("不及格")
	}

	//switch穿透，如果在case语句块后添加fallthrough，则不需要判断下一个case表达式而执行下一个case中的语句
	var number int = 10
	switch number {
		case 10:
			fmt.Println("10")
			fallthrough
		case 11: //不需要判断就可以执行此case中的语句
			fmt.Println("11")
		default:
			fmt.Println("unknown")
	}

	//Type switch：switch语句还可以被用于type-switch来判断某一个interface变量中实际指向的变量类型
	var x interface{}
	var y = 10.0
	x = y
	switch i := x.(type){
		case nil:
			fmt.Printf("x的类型%v\n",i)
		case int:
			fmt.Printf("x的类型%v\n",i)
		case float64:
			fmt.Printf("x的类型%v\n",i)
		case func(int) float64:
			fmt.Println("x 是 func(int)型")
		case bool, string:
			fmt.Printf("x的类型%v\n",i)
		default:
			fmt.Println("未知")
	}
}