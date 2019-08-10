package utils

var Number int = 10

//为了让其他包使用sum函数，需要将函数首字母大写，相当于其他语言的public，表示该函数可导出
func Sum(a int, b int) (int) {
	return a + b
}