package main

import (
	"fmt"
)

func main() {

	//1、len：用来求长度，比如string、array、slice、map、channel

	num1 := 10
	//num1的类型:int--值:10--地址0xc000082000
	fmt.Printf("num1的类型:%T--值:%v--地址%v\n", num1, num1, &num1)

	//2、new：用来分配内存，主要用来分配值类型，比如int、float32、struct，返回的是指针
	num2 := new(int)
	//num2的类型:*int--值:0xc000082018--地址0xc00007a020
	fmt.Printf("num2的类型:%T--值:%v--地址%v\n", num2, num2, &num2)

	//3、make：用来分配内存，主要用来分配引用类型，比如channel、map、slice
}
