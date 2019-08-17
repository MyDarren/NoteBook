package abc

//变量名首字母小写，只能被本包文件使用
var number int = 10
var Name string = "Darren"

func MySum(a int, b int) (int) {
	return a + b
}

//函数首字母小写，只能被本包文件使用，其他文件不能使用
func getSum(n1 int, n2 int) int {
	return n1 + n2
}