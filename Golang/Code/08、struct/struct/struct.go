package main

import (
	"fmt"
)

/**Golang语言面向对象编程
1、Golang支持面向对象编程，但是与传统的面向对象编程有区别，并不是纯粹的面向对象语言
   因而说golang支持面向对象编程特性比较准确
2、Golang没有类(class)，Go语言的结构体(struct)和其他编程语言的类(class)有相同的
   地位，可以理解为Golang是基于struct实现面向对象编程特性的
3、Golang面向对象编程非常简洁，去掉了传统面向对象编程语言的继承、方法重载、构造函数
   和析构函数、隐藏的this指针等
4、Golang仍然有面向对象编程的继承、多态和封装的特性，只是实现的方式和其他面向对象编程语言
   不一样，比如继承：Golang没有extends关键字，继承是通过匿名字段来实现的
5、Golang面向对象很优雅，面向对象编程本身就是语言类型系统(type system)的一部分，通过
   接口(interface)关联，耦合性低，非常灵活，因而Golang中面向接口编程是非常重要的特性
6、声明结构体
   type 结构体名称 struct {
      field1 type
      field2 type
   }
6、注意事项
   1) 字段声明语法同变量一样，字段名称 字段类型
   2）字段的类型可以是基本数据类型、数组或引用类型
   3）在创建一个结构体变量后，如果没有给字段赋值，都对应一个默认值
      BOOL类型默认值为false，整型为0，字符串为""
      数组类型的默认值与它的元素类型相关，比如score [3]int为[0,0,0]
      指针、slice、map的默认值为nil，即还没有分配空间
   4）不同结构体变量的字段是独立的，互不影响，一个结构体变量字段的更改，不影响另一个，结构体是值类型
*/

type Cat struct {
	Name   string
	Age    int
	Color  string
	number *int
	slice  []int
	map1   map[string]string
}

func main() {

	var cat1 Cat
	cat1.Name = "小白"
	cat1.Age = 2
	cat1.Color = "白色"
	fmt.Println(cat1)

	//使用结构体中的切片，要先make
	cat1.slice = make([]int, 3)
	cat1.slice[0] = 10

	//使用结构体中的map，要先make
	cat1.map1 = make(map[string]string)
	cat1.map1["type"] = "加菲猫"
	fmt.Println(cat1)

	//结构体是值类型，默认为值拷贝
	cat2 := cat1
	cat2.Name = "小黑"
	fmt.Println(cat1.Name)
	fmt.Println(cat2.Name)
}
