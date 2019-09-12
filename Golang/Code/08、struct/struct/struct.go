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
      BOOL类型默认值为false，数值类型为0，字符串为""
      数组类型的默认值与它的元素类型相关，比如score [3]int为[0,0,0]
      指针、slice、map的默认值为nil，即还没有分配空间
   4）不同结构体变量的字段是独立的，互不影响，一个结构体变量字段的更改，不影响另一个，结构体是值类型
7、创建结构体变量
   方式一: var 结构体变量名 结构体名称
		  var cat Cat
   方式二：var 结构体变量名 结构体名称 = 结构体名称{}
		  var cat Cat = Cat{}
   方式三：var 结构体变量指针 *结构体名称 = new(结构体名称)
		  var cat *Cat = new(Cat)
   方式四：var 结构体变量指针 *结构体名称 = &结构体名称{}
		  var cat *Cat = &Cat{}
8、使用细节
   1）结构体的所有字段在内存中是连续的
   2）结构体是用户单独定义的类型，和其他类型进行转换时需要有完全相同的字段(名字、类型、个数)
   3）结构体进行type重新定义(相当于取别名)，golang认为是新的数据类型，但是相互间可以强转
*/

type Cat struct {
	Name   string
	Age    int
	Color  string
	number *int
	slice  []int
	map1   map[string]string
}

type Student struct {
	Name string
	Age  int
}

type Point struct {
	x int
	y int
}

type Rect struct {
	left  Point
	right Point
}

type Rect2 struct {
	left  *Point
	right *Point
}

type A struct {
	name string
	age  int
}

type B struct {
	name string
	age  int
}

type C B

func main() {

	var cat1 Cat
	cat1.Name = "小白"
	cat1.Age = 2
	cat1.Color = "白色"
	fmt.Println(cat1)
	fmt.Printf("%p--%p\n", &cat1, &cat1.Name)

	if cat1.number == nil {
		fmt.Printf("cat1.number == nil\n")
	}

	//使用结构体中的切片，要先make
	if cat1.slice == nil {
		fmt.Printf("cat1.slice == nil\n")
	}
	cat1.slice = make([]int, 3)
	cat1.slice[0] = 10

	if cat1.map1 == nil {
		fmt.Printf("cat1.map1 == nil\n")
	}
	//使用结构体中的map，要先make
	cat1.map1 = make(map[string]string)
	cat1.map1["type"] = "加菲猫"
	fmt.Println(cat1)

	//结构体是值类型，默认为值拷贝
	cat2 := cat1
	cat2.Name = "小黑"
	fmt.Println(cat1.Name)
	fmt.Println(cat2.Name)

	//创建结构体变量方式一
	// var student Student

	//创建结构体变量方式二
	// var student Student = Student{}
	// student.Name = "Lucy"
	// student.Age = 2
	//或者
	//var student Student = Student{"Lucy", 2}

	//创建结构体变量方式三
	var student *Student = new(Student)
	//因为student是一个指针，因此下面是标准的给字段赋值方式
	(*student).Name = "Lucy"
	(*student).Age = 10
	//以上的写法也可以这样写
	//原因：Golang的设计者为了程序员使用方便，golang编译器底层会对student.Name = "Lucy"进行处理
	//会对student加上取值运算，(*student).Name = "Lucy"
	student.Name = "David"
	student.Age = 20
	fmt.Println(*student)

	//创建结构体变量方式四
	var student2 *Student = &Student{}
	student2.Name = "Ketty"
	student2.Age = 10
	fmt.Println(*student2)

	var student3 *Student = &Student{"Smith", 18}
	fmt.Println(*student3)

	var student4 = Student{"Lucy", 10}
	var student5 = &student4
	fmt.Println((*student5).Name)
	fmt.Println(student5.Name)

	student5.Name = "Marry"
	fmt.Printf("student4.Name=%v\nstudent5.Name=%v\n", student4.Name, student5.Name)
	//不能这样写，因为.运算符优先级比*高
	//fmt.Printf("%p", *student5.Age)

	var rect = Rect{Point{10, 20}, Point{20, 50}}
	fmt.Printf("rect.left.x的地址%p\nrect.left.y的地址%p\nrect.right.x的地址%p\nrect.right.x的地址%p\n",
		&rect.left.x, &rect.left.y, &rect.right.x, &rect.right.y)

	//Rect2有两个*Point类型，这两个*Point类型本身的地址是连续的，但是他们所指向的地址不一定是连续的
	var rect2 = Rect2{&Point{10, 20}, &Point{20, 50}}
	fmt.Printf("rect2.left的地址=%p\nrect2.right的地址=%p\nrect2.left的值=%p\nrect2.right的值=%p\n",
		&rect2.left, &rect2.right, rect2.left, rect2.right)

	var a A
	var b B
	b = B(a)

	var c C
	//错误，因为golang认为是新的数据类型，可以进行强转
	//c = b
	c = C(b)
	fmt.Println(c)

	//190
}
