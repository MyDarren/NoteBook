package main

import (
	"errors"
	"fmt"
)

/**
go语言追求简洁优雅，所以go语言不支持传统的try...catch...finally这种方式处理
go语言引入的处理方式是：defer, panic, recover
go中可以抛出panic异常，然后在defer中通过recover捕获这个异常，然后正常处理

自定义错误
go程序中，可以自定义错误，使用errors.New和panic内置函数
1）errors.New("错误说明")，会返回一个error类型的值，表示一个错误
2) panic内置函数，接收一个interface{}类型的值作为参数，可以接收error类型的变量，输出错误信息，并退出程序
*/

func test() {
	defer func() {
		err := recover() //recover为内置函数，可以捕获到异常
		if err != nil {
			fmt.Printf("error:%v\n", err)
		}
	}()
	num1 := 10
	num2 := 0
	result := num1 / num2
	fmt.Printf("result=%v", result)
}

func readConfig(name string) (err error) {
	if name == "config.ini" {
		return nil
	} else {
		//返回一个自定义错误
		return errors.New("读取文件错误...")
	}
}

func testFunc() {
	err := readConfig("config.ini")
	if err != nil {
		panic(err)
	}
	fmt.Println("testFunc end")
}

func main() {
	test()
	fmt.Println("test() end")
	testFunc()
}
