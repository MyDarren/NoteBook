package main

import (
	"fmt"
	"unsafe"
)

/**
数组可以存放多个同一类型的数据，数组也是一种数据类型，在Go中，数组是值类型
数组的定义：var 数组名[数组大小]数据类型  var ages[5]int
赋初值：ages[0] = 20 ages[1] = 18...
访问数组的元素：数组名[下标]
1、数组的地址可以通过数组名获得 &Arr
2、数组的第一个元素的地址，就是数组的首地址

四种初始化数组的方式：
var numArr01[6]int = [3]int{1, 2, 3}
var numArr02 = [3]int{4, 5, 6}
var numArr03 = [...]int{7, 8, 9}
var numArr04 = [...]int{1: 50, 0: 10, 2: 35}

数组的遍历
1、常规遍历
2、for-range遍历
   for index,value := range array {
	   ...
   }
  说明：
  1）第一个返回值index是数组的下标
  2）第二个返回值value是数组中该下标位置的值
  3）index、value是在for循环内部的局部变量
  4）遍历数组元素的时候，如果不想使用下标index，可以直接把下标index换成下划线_
  5）index和value名称不固定

注意事项：
1、数组是多个相同类型数据的集合，数组一旦声明/定义，其长度是固定的，不能动态变化
2、var array []int，此时array是一个slice切片
3、数组中的元素可以是任何数据类型，包括值类型和引用类型，但是不能混用
4、数组创建后，如果没有赋值，会有默认值
   数值类型数组，默认值为0
   字符串类型数组，默认为""
   bool类型数组，默认为false
5、数组下标从0开始，下标必须在指定范围内，否则报panic，数组越界
6、golang中的数组属于值类型，在默认情况下是值传递，因此会进行值拷贝，数组间不会相互影响
7、如果想在函数中，改变原来的数组，可以使用引用传递
8、长度是数组类型的一部分，在传递函数参数时，需要考虑数组的长度
*/

func arrayFunc01(array [3]int) {
	array[0] = 10
}

func arrayFunc02(array *[3]int) {
	// array[0] = 10
	(*array)[0] = 10
}

func arrayFunc03(array []int) {
	array[0] = 10
}

func arrayFunc04(array [4]int) {
	array[0] = 10
}

func arrayFunc05(array [3]int) {
	array[0] = 10
}

//冒泡排序
func bubbleSort(arr *[5]int) {
	tmp := 0
	for i := 0; i < len(*arr)-1; i++ {
		for j := 0; j < len(*arr)-1-i; j++ {
			if (*arr)[j] < (*arr)[j+1] {
				tmp = (*arr)[j]
				(*arr)[j] = (*arr)[j+1]
				(*arr)[j+1] = tmp
			}
		}
	}
}

//数组升序
func binarySearch(arr *[5]int, startIndex int, endIndex int, value int) int {
	if startIndex > endIndex {
		return -1
	}
	middle := (startIndex + endIndex) / 2
	if (*arr)[middle] > value {
		return binarySearch(arr, startIndex, middle-1, value)
	} else if (*arr)[middle] < value {
		return binarySearch(arr, middle+1, endIndex, value)
	} else {
		return middle
	}
}

func main() {

	var hens [6]float64
	hens[0] = 3.0
	hens[1] = 2.5
	hens[2] = 1
	hens[3] = 3.2
	hens[4] = 5
	hens[5] = 4.3

	sumWeight := 0.0
	for i := 0; i < len(hens); i++ {
		sumWeight += hens[i]
	}
	avgWeight := sumWeight / float64(len(hens))
	fmt.Printf("sumWeight=%v,avgWeight=%v\n", sumWeight, avgWeight)
	fmt.Printf("数组的地址:%p\nhens[0]的地址:%p\nhens[0]的地址:%p\n",
		&hens, &hens[0], &hens[1])

	//方式一
	var numArr01 [3]int = [3]int{1, 2, 3}
	fmt.Printf("numArr01:%v\n", numArr01) //numArr01:[1 2 3]

	//方式二
	var numArr02 = [3]int{4, 5, 6}
	fmt.Printf("numArr02:%v\n", numArr02) //numArr02:[4 5 6]

	//方式三
	var numArr03 = [...]int{7, 8, 9}
	fmt.Printf("numArr03:%v\n", numArr03) //numArr03:[7 8 9]

	//方式四
	var numArr04 = [...]int{1: 50, 0: 10, 2: 35}
	fmt.Printf("numArr04:%v\n", numArr04) //numArr04:[10 50 35]

	for index, value := range numArr04 {
		fmt.Printf("index=%v,value=%v\n", index, value)
	}

	var array01 [3]int
	var array02 [3]string
	var array03 [3]bool
	fmt.Printf("array01=%v\narray02=%v\narray03=%v\n", array01, array02, array03)

	var array04 = [...]int{5, 6, 7}
	fmt.Printf("array04=%v\n", array04)
	arrayFunc01(array04)
	fmt.Printf("array04=%v\n", array04)
	arrayFunc02(&array04)
	fmt.Printf("array04=%v\n", array04)

	// var array05 = [...]int{1, 2}
	// arrayFunc03(array05) //编译错误，不能把[3]int传递给[]int切片

	// var array06 = [...]int{4, 5, 6}
	// arrayFunc04(array06)	//编译错误，不能把[3]int传递给[4]int

	var array07 = [3]int{1, 3, 5}
	arrayFunc05(array07) //编译通过

	//冒泡排序
	var array08 = [5]int{10, 20, 50, 15, 5}
	fmt.Printf("排序前array08=%v\n", array08)
	bubbleSort(&array08)
	fmt.Printf("排序后array08=%v\n", array08)

	var array09 = [5]int{10, 15, 20, 35, 50}
	index := binarySearch(&array09, 0, len(array09)-1, 50)
	fmt.Printf("下标为%v\n", index)

	//二维数组
	//使用方式一：先声明/定义，后赋值
	var arr10 [4][6]int
	arr10[1][2] = 1
	arr10[2][3] = 3
	arr10[3][0] = 5

	var arr11 [2][3]int
	arr11[0][2] = 1
	arr11[1][1] = 3
	fmt.Printf("arr11[0]的地址%p\n", &arr11[0])
	fmt.Printf("arr11[1]的地址%p\n", &arr11[1])
	fmt.Printf("arr11[0][0]的地址%p\n", &arr11[0][0])
	fmt.Printf("arr11[0][0]的地址%p\n", &arr11[0][0])
	fmt.Printf("arr11的大小%d\n", unsafe.Sizeof(arr11))

	//使用方式二：直接初始化，然后赋值
	//二维数组在声明定义时也对应有四种写法
	//var 数组名 [大小][大小]类型 = [大小][大小]类型{{初值...},{初值...}}
	//var 数组名 [大小][大小]类型 = [...][大小]类型{{初值...},{初值...}}
	//var 数组名 = [大小][大小]类型{{初值...},{初值...}}
	//var 数组名 = [...][大小]类型{{初值...},{初值...}}
	var arr12 = [2][3]int{{1, 2, 3}, {5, 4, 2}}
	fmt.Println(arr12)

	//二维数组的遍历
	//for循环
	for i := 0; i < len(arr12); i++ {
		for j := 0; j < len(arr12[i]); j++ {
			fmt.Printf("%v ", arr12[i][j])
		}
		fmt.Printf("\n")
	}

	for _, value1 := range arr12 {
		for _, value2 := range value1 {
			fmt.Printf("%v ", value2)
		}
		fmt.Printf("\n")
	}
}
