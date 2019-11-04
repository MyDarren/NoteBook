package main

import (
	"fmt"

	"../model"
)

/**
使用工厂模式实现跨包创建结构体实例
1、如果model包中结构体变量首字母大写，引入后直接使用没有问题
2、如果model包中结构体变量首字母小写，引入后不能直接使用，可以使用工厂模式解决
*/

func main() {
	var student = model.Student{
		Name: "Lucy",
		Age:  10,
	}
	fmt.Println(student)
	student.SetScore(60)
	fmt.Println(student.GetScore())

	var teacher = model.NewTeacher("tom", 20)
	fmt.Println(*teacher)
	fmt.Println(teacher.GetName())

}
