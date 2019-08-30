package main

import (
	"fmt"
)

/**
1、切片是数组的一个引用，因此切片是引用类型，在进行传递时，遵守引用传递机制
2、切片的使用和数组类似，遍历切片、访问切片的元素、求切片长度len(slice)都一样
3、切片的长度是可以变化的，因此切片是一个可以动态变化数组
4、基本语法：
   var 切片名[]数据类型，比如var a[]int
5、切片从底层来说，其实是一个数据结构(struce结构体)
   type slice struct{
	   ptr *[2]int //ptr指针根据切片指向的数组类型而不同
	   len int
	   cap int
   }
6、切片的使用方式
   方式一：定义一个切片，然后让切片去引用一个已经创建好的数组
		   基本语法：var slice = arr[startIndex:endIndex]
		   切片初始化时，仍然不能越界，范围在[0,len(arr))之间，但是可以动态增长
		   var slice = arr[0:endIndex]可以简写为var slice = arr[:endIndex]
		   var slice = arr[startIndex:len(arr)]可以简写为var slice = arr[startIndex:]
		   var slice = arr[0:len(arr)]可以简写为var slice = arr[:]
   方式二：通过make来创建切片
		基本语法：var 切片名[]type = make([]type,len,[cap])
		参数说明：type表示数据类型；len表示大小；cap指定切片容量，可选，如果指定了cap，则要求cap>=len
		如果没有给切片的各个元素赋值，则会使用默认值(int和float默认值为0，string默认值为空字符串""，bool的默认值为false)
		通过make方式创建的切片对应的数组由make底层维护，对外不可见，只能通过slice访问各个元素
	方式三：定义切片时直接指定具体数组，使用原理类似make的方式
*/

func testSlice(slice []int) {
	slice[0] = 10
}

func main() {

	var intArr = [...]int{10, 20, 25}
	//slice1 表示切片名
	//intArr[1:3]表示slice1引用intArr数组，起始下标为1，结束下标为3(不包含下标为3的元素)，包头不包尾
	//切片使用方式一
	slice1 := intArr[1:3]
	fmt.Println("interArr=", intArr)
	fmt.Println("slice1的元素=", slice1)
	fmt.Println("slice1元素个数=", len(slice1))
	/**
	func cap(v Type) int
	cap函数是一个内建函数，返回v的容量，取决于数据类型
	数组：v中元素的个数，和len(v)相同
	数组指针：*v中元素的个数，与len(v)相同
	切片：切片的容量(底层数组的长度)；若v为nil，cap(v)为零
	信道：按照元素的单元，相同信道缓存的数量；若v为nil，cap(v)为零
	*/
	fmt.Println("slice1的容量=", cap(slice1)) //切片的容量可以动态变化

	fmt.Printf("intArr[1]地址=%p\n", &intArr[1])
	fmt.Printf("slice1[0]地址=%p，值=%v\n", &slice1[0], slice1[0])

	slice1[1] = 30
	fmt.Println("interArr=", intArr)
	fmt.Println("slice1的元素=", slice1)

	//切片使用方式二
	var slice2 []int = make([]int, 2, 5)
	slice2[0] = 10
	slice2[1] = 15
	fmt.Println("slice2的元素=", slice2)

	//切片使用方式三
	var slice3 []string = []string{"tom", "jack", "marry"}
	fmt.Println("slice3的元素=", slice3)

	//切片的遍历
	// for i := 0; i < len(slice3); i++ {
	// 	//fmt.Printf("slice3[%d]=%v\n", i, slice3[i])
	// }

	// for index, value := range slice3 {
	// 	fmt.Printf("index=%v,value=%v\n", index, value)
	// }

	//切片还可以继续切片
	var slice4 = slice3[1:3]
	fmt.Println("slice4的元素=", slice4)

	slice4[0] = "lucy"
	fmt.Println("slice3的元素=", slice3)
	fmt.Println("slice4的元素=", slice4)

	/**
	用append内置函数，可以对切片进行动态追加
	底层原理：
	1、切片append操作的本质是对数组扩容
	2、go底层会创建一个新的数组newArr(按照扩容后的大小)
	3、将slice原来包含的元素拷贝到新的数组newArr
	4、newArr是底层维护的，对外不可见
	*/
	var slice5 = []int{10, 20, 30}
	var slice6 = append(slice5, 5, 25)
	slice6 = append(slice6, slice2...)
	fmt.Println("slice5的元素=", slice5)
	fmt.Println("slice6的元素=", slice6)

	/**
	使用内置函数copy可以完成对切片的拷贝
	copy(para1,para2)，其中para1和para2都是切片类型，两个切片数据相互独立，互不影响
	如果para1的长度比para2小，不会报错，只会拷贝para2的部分数据
	*/
	var slice7 = []int{1, 2, 3, 4, 5}
	var slice8 = make([]int, 10)
	fmt.Println("slice8的元素=", slice8)
	copy(slice8, slice7)
	slice7[0] = 10
	fmt.Println("slice7的元素=", slice7)
	fmt.Println("slice8的元素=", slice8)

	var slice9 = []int{1, 3, 5, 8}
	fmt.Println("slice9的元素=", slice9)

	//切片是引用类型，在传递时，遵守引用传递机制
	testSlice(slice9)
	fmt.Println("slice9的元素=", slice9)

	/**
	string底层是一个byte数组，因此string也可以进行切片处理
	*/
	var str1 string = "hello world"
	slice10 := str1[:5]
	fmt.Println("slice10的元素=", slice10)

	//string是不可变的，因而不能通过str1[0]='z'的方式来修改字符串
	//str1[0] = 'a' //cannot assign

	//如果需要修改字符串，可以先将string转换成[]byte切片或者[]rune切片，修改完成之后在重新转成字符串
	var str2 = "world"
	byteSlice := []byte(str2)
	byteSlice[0] = 'a'
	str2 = string(byteSlice)
	fmt.Println("str2=", str2)

	var str3 = "北京"
	runeSlice := []rune(str3)
	runeSlice[0] = 'A'
	str3 = string(runeSlice)
	fmt.Println("str3=", str3)

	//162
}
