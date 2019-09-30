package main

import (
	"fmt"
)

/**
1、Golang中的方法是作用在指定数据类型上的，即和指定的数据类型绑定，
   因此自定义数据类型，都可以有方法，而不仅仅是struct，比如int，float32等类型都可以有方法
2、方法的调用和传参机制和函数基本一样，不同的是方法调用时，会将调用方法的变量当作参数传递给方法
   如果变量是值类型，则进行值拷贝，如果是引用类型，则进行地址拷贝
3、方法的声明
   func (receiver type) methodName (参数列表) 返回值列表{
	   方法体
	   return 返回值
   }

   1）receiver type表示这个方法和type这个类型进行绑定，或者说该方法作用于type类型
   2）receiver type这个type可以是结构体，也可以是其他的自定义类型
   3）receiver表示type类型的一个实例
   4）参数列表表示方法输入
   5）返回值列表表示返回的值，可以是多个
   6）方法主体表示为了实现某一功能代码块
   7）return语句不是必须的
4、如果希望在方法中，修改结构体变量的值，可以通过结构体指针的方式来处理
5、方法的访问控制范围和函数一样，如果方法名首字母小写，只能在本包内访问，如果方法名首字母大写，则可以在本包和其他包访问
6、如果一个类型实现了String()方法，那么fmt.Println()默认会调用这个变量的String()进行输出
7、方法与函数的区别
   1）调用方式不同
	  函数调用方式：函数名(实参列表)
	  方法调用方式：变量.方法名(实参列表)
   2）对于函数，如果接收者是值类型，不能将指针类型的数据直接传递，反之亦然
   	  对于方法，如果接收者是值类型，可以直接用指针类型的变量，反过来同样也可以，最终取决于接收者的类型

*/

type Student struct {
	Name string
	Age  int
}

//表示Student类型有一个方法，方法名称为test
//func (student Student) test()体现test方法是和Student类型绑定的
//test方法只能通过Student类型的变量来调用，而不能直接调用，也不能使用其他类型的变量来调用
//func (student Student) test()中student表示哪个Student变量调用，这个student就是该变量的副本，这与函数传参类似
func (student Student) test() {
	student.Name = "David"
	fmt.Printf("student.Name=%v\n", student.Name)
}

//为了提高效率，通常方法与结构体指针类型进行绑定
func (student *Student) test2() {
	//因为student是指针类型，因此标准的访问其字段的方式是(*student).Age
	//(*student).Age = 10
	//编译器做了优化，(*student).Age = 10等价于student.Age = 10
	student.Age = 10
}

func (student *Student) String() string {
	str := fmt.Sprintf("Name=%v--Age=%v", student.Name, student.Age)
	return str
}

type integer int

func (number integer) print() {
	fmt.Printf("number=%v\n", number)
}

func (number *integer) change() {
	*number = *number + 1
}

func func01(student Student) {
	fmt.Println(student.Name)
}

func func02(student *Student) {
	fmt.Println(student.Name)
}

func (student Student) method01() {
	student.Name = "David"
	fmt.Printf("method01--student.Name=%v\n", student.Name)
}

func (student *Student) method02() {
	student.Name = "David"
	fmt.Printf("method02--student.Name=%v\n", student.Name)
}

func (student *Student) method03() {
	student.Name = "Marry"
	fmt.Printf("method03--student.Name=%v\n", student.Name)
}

func main() {
	student := Student{"Lucy", 20}
	student.test()
	fmt.Printf("student.Name=%v\n", student.Name)
	//(&student).test2()
	//底层编译器做了优化，(&student).test2()等价于student.test2()，编译器自动加上&
	student.test2()
	fmt.Printf("student.Age=%v\n", student.Age)

	fmt.Println(&student)

	var number integer = 10
	number.print()
	number.change()
	fmt.Printf("number=%v\n", number)

	func01(student)
	func02(&student)
	//函数如果接受者是值类型，则不能将指针类型的数据直接传递
	//如果接收者是指针类型，不能将值类型的数据直接传递
	//func01(&student)
	//func02(student)

	//对于方法，如果接收者是值类型，可以将指针类型和值类型进行传递
	//如果接收者是指针类型，也可以将指针类型和值类型进行传递
	//不管调用方式如何，真正决定是值拷贝还是值拷贝，取决于方法与哪种类型绑定
	fmt.Printf("main--student.Name=%v\n", student.Name) //Lucy
	student.method01()
	fmt.Printf("main--student.Name=%v\n", student.Name) //Lucy
	//从形式上传入地址，但是本质上仍然是值拷贝
	(&student).method01()
	fmt.Printf("main--student.Name=%v\n", student.Name) //Lucy

	(&student).method02()
	fmt.Printf("main--student.Name=%v\n", student.Name) //David
	student.method03()
	fmt.Printf("main--student.Name=%v\n", student.Name) //Marry

	//201
}
