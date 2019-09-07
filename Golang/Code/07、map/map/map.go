package main

import (
	"fmt"
	"sort"
)

/**
map是key-value数据结构，又称为字段或者关联数组，类似于其他编程语言的集合
1、基本语法：
   var map名 map[keyType]valueType
   map声明的示例：
   		var map1 map[int]string
		var map2 map[string]string
		var map3 map[string]int
		var map4 map[string]map[string][string]
   map在声明的时候不会分配内存，而数组声明之后会分配内存，map初始化需要make，分配内存后才能赋值和使用
2、golang中map的key可以是多种类型，比如bool、数字、string、指针、channel，还可以是只包含前面几种类型的接口、结构体、数组，通常为int、string
   注意：slice、map还有function不可以，因为这几个没法通过==来判断
3、map的value类型和key基本一样，通常为数字(整数、浮点数)、string、map、struct
4、map的key不能重复，如果重复了，则以最后一个值为准，map的key-value是无序的
5、map的使用方式
   方式一：先声明，后make
		  var map1 map[string]string
		  map1 = make(map[string]string,5)
   方式二：声明时直接使用make
		  var map2 = make(map[string]string,5)
   方式三：声明并直接赋值
		  var map3 map[string]string = map[string]string{
			  "name":"Lucy"
		  }
6、map的增删改查
   1) 新增和修改：map[key]=value，如果key不存在就是增加操作，如果存在则是修改操作
   2) 删除：delete(map,"key")，delete是一个内置函数，如果key存在，则删除该key-value，如果map为nil或者key不存在，则不做操作，也不会报错
	  如果要删除map的所有key，没有一个专门的方法一次删除，可以遍历所有的key，逐个删除
	  或者map = make(...)，make一个新的，让原来的成为垃圾，被gc回收
   3) 查找：value, result := map名[key]，如果map中存在对应的key值，则result会返回true，否则返回false
   4) map的遍历使用for-range的结构遍历
7、map的长度
   func len(v Type) int
   内建函数len返回v的长度，取决于v的类型
   数组：数组v中元素的个数
   数组指针：*v中元素的个数(v为nil时panic)
   切片、map：v中元素的个数，若v为nil，len(v)即为0
   字符串：v中字节的个数
   通道：通道缓存中队列(未读取)元素的数量；若v为nil，len(v)为0
8、map切片
   切片的数据类型如果是map，则成为slice of map，map切片，这样使用map的个数可以动态变化
9、map使用细节
   1、map是引用类型，遵守引用类型传递机制，在一个函数中接收map，修改后，会直接修改原来的map
   2、map的容量达到后，再添加元素，会自动扩容，不会发生panic，也就是说map能动态增长键值对
   3、map的value经常使用struce类型，更适合管理复杂的数据
*/

type teacher struct {
	Name string
	Age  int
}

func mapFunc(testMap map[string]int) {
	testMap["age"] = 20
}

func main() {

	var arr1 [6]int
	arr1[0] = 10
	fmt.Println(arr1)

	//方式一
	var map1 map[string]string
	//panic: assignment to entry in nil map
	//map1["name"] = "Lucy"
	fmt.Println(map1)
	//在使用map前，需要先make，make的作用是给map分配内存空间
	map1 = make(map[string]string, 10)
	map1["name"] = "David"
	fmt.Printf("map1=%v\n", map1)

	//方式二
	var map2 = make(map[string]string)
	map2["city"] = "上海"
	map2["country"] = "China"
	fmt.Printf("map2=%v\n", map2)

	//方式三
	var map3 = map[string]string{
		"name": "Lucy",
	}
	map3["age"] = "18"
	fmt.Printf("map3=%v\n", map3)

	var students = make(map[int]map[string]string)
	students[1] = map[string]string{
		"name": "Lucy",
		"age":  "20",
	}
	students[2] = map[string]string{
		"name": "David",
		"age":  "25",
	}
	fmt.Printf("students=%v\n", students)
	fmt.Printf("students[1]=%v\n", students[1])

	delete(students, 1)
	fmt.Printf("students=%v\n", students)
	delete(map3, "score")
	fmt.Printf("map3=%v\n", map3)

	students = make(map[int]map[string]string)
	fmt.Printf("students=%v\n", students)

	value, result := map2["city"]
	if result {
		fmt.Printf("找到了,值为%v\n", value)
	} else {
		fmt.Printf("没找到\n")
	}

	for key, value := range map2 {
		fmt.Printf("%v:%v\n", key, value)
	}

	//map切片
	var monsters = make([]map[string]string, 1)
	monsters[0] = map[string]string{
		"name": "牛魔王",
	}
	fmt.Printf("monsters=%v\n", monsters)
	//一下写法越界
	/*
		monsters[1] = map[string]string{
			"name": "蜘蛛精",
		}
	*/
	var monster = map[string]string{
		"name": "蜘蛛精",
	}
	monsters = append(monsters, monster)
	fmt.Printf("monsters=%v\n", monsters)

	//map排序
	var numberMap = make(map[int]int, 10)
	numberMap[10] = 10
	numberMap[1] = 5
	numberMap[4] = 6
	numberMap[8] = 13
	fmt.Printf("numberMap=%v\n", numberMap)

	//1、将map中的key放入切片中
	var keySlice = make([]int, 0)
	for key, _ := range numberMap {
		keySlice = append(keySlice, key)
	}
	fmt.Println(keySlice)

	//2、对切片排序
	sort.Ints(keySlice)
	fmt.Println(keySlice)

	//遍历切片，然后按照key来输出map的值
	for _, value := range keySlice {
		fmt.Printf("numberMap[%v]=%v\n", value, numberMap[value])
	}

	var modifyMap = map[string]int{
		"age": 10,
	}
	fmt.Printf("修改前modifyMap=%v\n", modifyMap)
	mapFunc(modifyMap)
	fmt.Printf("修改后modifyMap=%v\n", modifyMap)

	var teachers = make(map[int]teacher, 2)
	teachers[0] = teacher{
		Name: "Lucy",
		Age:  10,
	}
	teachers[1] = teacher{
		Name: "David",
		Age:  10,
	}
	fmt.Println(teachers)

	for key, value := range teachers {
		fmt.Printf("编号:%v，名字:%v，年龄:%v\n", key, value.Name, value.Age)
	}
}
