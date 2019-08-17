package utils

import "fmt"

var Age int
var Name string

func init() {
	Age = 20
	Name = "Darren"
	fmt.Println("utils--init")
}
