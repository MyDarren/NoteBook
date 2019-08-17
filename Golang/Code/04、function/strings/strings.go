package main

import (
	"fmt"
	"strconv"
	"strings"
)

func main() {

	//字符串函数
	var str1 = "hello world"
	//1、统计字符串的长度，按照字节返回，内建函数
	//golang使用utf-8编码，ASCII字符占一个字节，汉字占三个字节
	fmt.Println("str1-length=", len(str1)) //11
	var str2 = "北京"
	fmt.Println("str2-length=", len(str2)) //6

	var str3 = "hello北京"
	for i := 0; i < len(str3); i++ {
		//fmt.Printf("%c\n", str3[i]) //乱码
	}
	//2、字符串遍历，同时处理中文问题
	str4 := []rune(str3)
	for i := 0; i < len(str4); i++ {
		//fmt.Printf("%c\n", str4[i]) //不会乱码
	}

	//3、字符串转整数
	number, error := strconv.Atoi("12")
	fmt.Printf("number=%v,error=%v\n", number, error) //number=12,error=<nil>

	//4、整数转字符串
	str5 := strconv.Itoa(12345)
	fmt.Printf("str5=%v--%T\n", str5, str5) //str5=12345--string

	//5、字符串转[]bytes
	var bytes = []byte("hello go")
	fmt.Printf("bytes=%v\n", bytes) //bytes=[104 101 108 108 111 32 103 111]

	//6、[]byte转字符串
	str6 := string([]byte{97, 98, 99})
	fmt.Printf("str6=%v\n", str6) //str6=abc
	str6 = string([]byte{'d', 'e', 'f'})
	fmt.Printf("str6=%v\n", str6) //str6=def

	//7、十进制数字转成二进制、八进制等的字符串
	str7 := strconv.FormatInt(25, 16)
	fmt.Printf("str7=%v\n", str7) //str7=19

	//8、查找子串是否在指定的字符串中
	isContain := strings.Contains("hello world", "world")
	fmt.Printf("isContain=%v\n", isContain) //isContain=true

	//9、返回字符串中有几个指定的子串
	count := strings.Count("hello world", "l")
	fmt.Printf("count=%v\n", count) //count=3

	//10、不区分大小写字符串比较
	isEqual := strings.EqualFold("abc", "Abc")
	fmt.Printf("isEqual=%v\n", isEqual) //isEqual=true
	//区分大小写
	isEqual = "abc" == "Abc"
	fmt.Printf("isEqual=%v\n", isEqual) //isEqual=false

	//11、返回子串在字符串中第一次出现的下标，没有返回-1
	index := strings.Index("hello world", "l")
	fmt.Printf("index=%v\n", index) //index=2

	//12、返回子串在字符串中最后一次出现的下标，没有返回-1
	index = strings.LastIndex("hello world", "l")
	fmt.Printf("index=%v\n", index) //index=9

	//13、将字符串中指定的子串替换成另一个子串，n表示要替换的个数，如果为-1则表示全部替换
	str8 := strings.Replace("hello", "l", "~", -1)
	fmt.Printf("str8=%v\n", str8) //str8=he~~o

	//14、按照指定的字符，将字符串拆分为字符串数组
	strArr := strings.Split("hello,world,ok,thanks", ",")
	fmt.Printf("strArr=%v\n", strArr) //strArr=[hello world ok thanks]

	//15、将字符串进行大小写转换
	str9 := strings.ToLower("heLlo")
	fmt.Printf("str9=%v\n", str9) //str9=hello

	str10 := strings.ToUpper("heLlo")
	fmt.Printf("str10=%v\n", str10) //str10=HELLO

	//16、将字符串两边的空格去掉
	str11 := strings.TrimSpace(" Are you ok? ")
	fmt.Printf("str11=%q\n", str11) //str11="Are you ok?"

	//17、将字符串左右两边指定的字符去掉，可以指定多个
	str12 := strings.Trim("~~hello,world~!", "~!")
	fmt.Printf("str12=%v\n", str12) //str12=hello,world

	str13 := strings.TrimLeft("~~hello,world~!", "~")
	fmt.Printf("str13=%v\n", str13) //str13=hello,world~!

	str14 := strings.TrimRight("~~hello,world~!", "!")
	fmt.Printf("str14=%v\n", str14) //str14=~~hello,world~

	//18、判断字符串是否以指定字符串开头
	hasPrefix := strings.HasPrefix("hello world", "hello")
	fmt.Printf("hasPrefix=%v\n", hasPrefix) //hasPrefix=true

	//19、判断字符串是否以指定字符串结尾
	HasSuffix := strings.HasSuffix("hello world", "hello")
	fmt.Printf("HasSuffix=%v\n", HasSuffix) //HasSuffix=false
}
