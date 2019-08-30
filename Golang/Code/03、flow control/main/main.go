package main

import (
	"fmt"
	"math/rand"
	"time"
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
	//男

	//switch后可以不带表达式类似于if--else分支来使用
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
	//及格

	//在switch语句中可以直接声明一个变量，需要以分号结束，不推荐
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
	//良好

	//switch穿透，如果在case语句块后添加fallthrough，则不需要判断下一个case表达式而执行下一个case中的语句
	//默认只能穿透一层
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
	//10
	//11

	//Type switch：switch语句还可以被用于type-switch来判断某一个interface变量中实际指向的变量类型
	var x interface{}
	var y = 10.0
	x = y
	switch i := x.(type) {
	case nil:
		fmt.Printf("x的类型%T\n", i)
	case int:
		fmt.Printf("x的类型%T\n", i)
	case float64:
		fmt.Printf("x的类型%T\n", i)
	case func(int) float64:
		fmt.Println("x 是 func(int)型")
	case bool, string:
		fmt.Printf("x的类型%T\n", i)
	default:
		fmt.Println("未知")
	}
	//x的类型float64

	//for循环
	for i := 0; i < 10; i++ {
		//fmt.Println(i)
	}

	//for循环的第二种方式
	j := 1
	for j < 10 {
		//fmt.Println(j)
		j++
	}

	//for循环的第三种方式
	//go语言中没有while和do...while语法，可以通过下面案例实现while语法
	k := 0
	for { //等价于for ; ;
		if k > 5 {
			break
		} else {
			//fmt.Println(k)
			k++
		}
	}

	//可以通过下面案例实现do...while语法
	l := 0
	for {
		//fmt.Println(k)
		l++
		if l > 5 {
			break
		}
	}

	//字符串遍历方式一
	//如果字符串中含有中文，此方式按照字节来遍历，而一个汉字在utf-8编码中对应三个字节，因而会出现乱码
	//可以通过将字符串转成[]tune切片解决
	var str1 string = "hello北京"
	for i := 0; i < len(str1); i++ {
		//fmt.Printf("%c\n",str1[i])
	}
	str2 := []rune(str1)
	for i := 0; i < len(str2); i++ {
		//fmt.Printf("%d-%c\n",i,str2[i])
	}

	//字符串遍历方式二for-range
	//此方式是按照字符的方式来遍历的，因而不会出现乱码
	// var str3 string = "hello上海"
	// for index, val := range str3 {
	// 	fmt.Printf("index=%d,val=%c\n",index,val)
	// }

	//生成[1,100]的随机数
	rand.Seed(time.Now().UnixNano()) //返回时间戳，Unix()单位s，UnixNano()单位纳秒
	//rand.Intn(n) [0,n)
	var randNumber = rand.Intn(100) + 1
	fmt.Println(randNumber)

	//可以使用标签和break指明要跳出哪一层循环
label1:
	for i := 0; i < 4; i++ {
		// label2:
		for j := 0; j < 3; j++ {
			if j == 1 {
				/**
				i = 0,j = 0
				i = 1,j = 0
				i = 2,j = 0
				i = 3,j = 0
				*/
				//break

				/**
				i = 0,j = 0
				*/
				break label1

				/**
				i = 0,j = 0
				i = 1,j = 0
				i = 2,j = 0
				i = 3,j = 0
				*/
				//break label2
			}
			//fmt.Printf("i = %d,j = %d\n", i,j)
		}
	}

	//可以使用标签和continue指明要跳过哪一层循环
	// label3:
	for i := 0; i < 4; i++ {
	label4:
		for j := 0; j < 3; j++ {
			if j == 1 {
				/**
				i = 0,j = 0
				i = 0,j = 2
				i = 1,j = 0
				i = 1,j = 2
				i = 2,j = 0
				i = 2,j = 2
				i = 3,j = 0
				i = 3,j = 2
				*/
				// continue

				/**
				i = 0,j = 0
				i = 1,j = 0
				i = 2,j = 0
				i = 3,j = 0
				*/
				// continue label3

				/**
				i = 0,j = 0
				i = 0,j = 2
				i = 1,j = 0
				i = 1,j = 2
				i = 2,j = 0
				i = 2,j = 2
				i = 3,j = 0
				i = 3,j = 2
				*/
				continue label4
			}
			//fmt.Printf("i = %d,j = %d\n", i,j)
		}
	}

	//跳转控制语句goto
	//go语言中goto语句可以无条件转移到程序中指定的行
	//go语句通常与条件语句配合使用，可用于实现条件转移，跳出循环体等功能
	//在go语言中一般不主张使用goto语句，以免造成程序流程的混乱

	for i := 0; i < 5; i++ {
		if i == 3 {
			goto label5
		}
		//fmt.Printf("i = %d\n", i)
	}
label5:
	/**
	i = 0
	i = 1
	i = 2
	ok
	*/
	//fmt.Println("ok")
}
