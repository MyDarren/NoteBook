package main

import (
	"fmt"

	myAlias "../alias" //给包取别名
	abc "../test"
	"../utils"
)

/**
 包的作用：
 1、区分相同的函数、变量等标识符
 2、当程序文件很多时，可以很好的管理项目
 3、控制函数、变量的访问范围，即作用域

 包的本质是创建不同的文件夹，来存放程序文件
 go语言中的每一个文件都是属于一个包的，go语言以包的形式管理文件和项目目录结构

 打包基本语法：
 package 包名

 引入包的基本语法
 import "包的路径"

 调用包中函数语法
 包名.函数名

 包的注意事项：
 1、在给一个文件打包时，该包对应一个文件夹，文件的包名通常和文件所在的文件夹名一致，一般为小写字母
	如果包名与文件夹名不一致，则引入包时还是按照路径引入文件夹，但是在调用时则要用包名调用函数
	例如test.go文件位于test文件夹中，但是包名为abc，则引入方式为"../test"，调用方式为abc.函数名
	同一个文件夹下面的文件名不同，但是文件包名必须一致，例如test文件夹下面的abc.go和test.go的包名必须一致
 2、当一个文件要使用其他包函数或变量时，需要先引入对应的包
	引入方式一：import "包名"
	引入方式二：import (
				"包名"
			  )
 3、package指令在文件第一行，然后是import指令
 4、在import包时，路径从$GOPATH工作目录开始
 5、为了让其他包的文件，可以访问本包的函数，则该函数名的首字母需要大写，类似其他语言的public，表示该函数可导出,这样才能跨包访问
	如果想让其他包中的文件可以访问本包的变量，则该变量名首字母需要大写
 6、在访问其他包函数时，其语法是包名.函数名，访问其他包变量时，其语法是包名.变量名
 7、如果包名较长，Go支持给包取别名，取别名之后，原来的包名就不能使用了
	例如给"../alias"取别名myAlias，无论其下面的文件包名是什么，都要用myAlias访问变量和函数
	取别名其实是给对应路径的文件夹下的文件的包名取别名
 8、在同一个包下，不能有相同的函数名和全局变量名
 9、如果想要编译成可执行程序，则需要将包声明为main，即package main，这是一个语法规范，如果是写一个库，包名可以自定义
	编译时需要编译main包所在的文件夹，编译后会生成一个有默认名的可执行程序
	切换到main包所在的文件夹之后编译指令:
	go build -o bin/project.bin ./
	使用./bin/project.bin进行执行
*/

func sum(a int, b int) int {
	return a + b
}

func main() {
	fmt.Println("hello")
	number1 := sum(10, 20)
	fmt.Println(number1)

	number2 := utils.Sum(10, 20)
	fmt.Println(number2)

	number3 := abc.MySum(10, 20)
	fmt.Println(number3)
	abc.MyPrint()
	fmt.Println(abc.Name)

	fmt.Println(utils.Number)
	//fmt.Println(alias.Name)
	fmt.Println(myAlias.Name) //给包取别名之后，原来的包名就不能使用了
	myAlias.AliasPrint()
}
