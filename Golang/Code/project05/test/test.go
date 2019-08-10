package abc
import "fmt"

func MyPrint(){
	fmt.Println("hello world!")
	result := getSum(10, number)
	fmt.Println(result)
}

//在同一个包下，不能有相同的函数名和变量名
// var number int = 10
// func MySum(a int, b int) (int) {
// 	return a + b
// }