package main 
import (
	"fmt"
)

func main() {

	//要求：可以在控制台接收用户信息，【姓名：年龄：体重：是否通过考试】
	//方式一：fmt.ScanIn()
	/*
	var name string
	var age int
	var weight float32
	var isPass bool
	
	fmt.Println("请输入姓名：")
	fmt.Scanln(&name)
	fmt.Println("请输入年龄：")
	fmt.Scanln(&age)
	fmt.Println("请输入体重：")
	fmt.Scanln(&weight)
	fmt.Println("请输入是否通过考试：")
	fmt.Scanln(&isPass)
	fmt.Printf("姓名：%v 年龄：%v 体重：%v 是否通过考试：%v\n",name,age,weight,isPass)

	//方式二：fmt.Scanf()，可以按照指定的格式输入
	fmt.Println("请输入姓名、年龄、体重、是否通过考试，使用空格隔开")
	fmt.Scanf("%s %d %f %t",&name,&age,&weight,&isPass)
	fmt.Printf("姓名：%v 年龄：%v 体重：%v 是否通过考试：%v\n",name,age,weight,isPass)
	*/

	/*
	var number1 int = 10
	//以二进制方式输出
	fmt.Printf("%b\n",number1)		//1010

	//八进制以0开头
	var number2 int = 011
	fmt.Printf("%d\n",number2)		//9

	//十六进制
	var number3 int = 0x11
	fmt.Printf("%d\n",number3)		//17
	*/

	//对于有符号的数而言，二进制的最高位是符号位，0表示正数，1表示负数
	//正数的原码、反码、补码都一样
	//负数的反码等于它的原码符号位不变，其他位取反
	//负数的补码等于它的反码+1
	//0的反码、补码都是0
	//在计算机运算的时候，都是以补码的方式进行运算

	/**
	* 位运算符
	* 按位与&运算符：两位都为1，结果为1，否则为0
	* 按位或|运算符：两位都为0，结果为0，否则为1
	* 按位异或^运算符：两位一个为1，一个为0，结果为1，否则为0（两位不同才为1，否则为0）
	* 计算2&3、2|3、2^3
	* 2的补码 0000 0010
	* 3的补码 0000 0011
	* 2&3    0000 0010 ------> 2
	* 2|3    0000 0011 ------> 3
	* 2^3    0000 0001 ------> 1
	
	* 计算-2&-3、-2|-3、-2^-3
	* -2的原码 1000 0010
	* -2的反码 1111 1101
	
	* -3的原码 1000 0011
	* -3的反码 1111 1100

	* -2的补码 1111 1110
	* -3的补码 1111 1101
	* -2&-3   1111 1100(补码) ------>1111 1011(反码) ------>1000 0100(原码) ------> -4
	* -2|-3   1111 1111(补码) ------>1111 1110(反码) ------>1000 0001(原码) ------> -1
	* -2^-3   0000 0011(补码) ------>0000 0011(反码) ------>0000 0011(原码) ------> 3
	
	* 计算2+3 
	* 2的补码  0000 0010
	* 3的补码  0000 0011
	* 2+3	  0000 0101(补码) ------>0000 0101(反码) ------>0000 0101(原码) ------> 5

	* 计算2-3 = 2 + (-3)
	* 2的补码  0000 0010
	* -3的补码 1111 1101
	* 2-3     1111 1111(补码) ------>1111 1110(反码) ------>1000 0001(原码) ------> -1
	*/

	/*
	fmt.Println(2&3)
	fmt.Println(2|3)
	fmt.Println(2^3)

	fmt.Println(-2&-3)
	fmt.Println(-2|-3)
	fmt.Println(-2^-3)
	*/

	/**
	* 右移运算符>>：低位溢出，符号位不变，并用符号位补溢出的高位
	* 左移运算符<<：符号位不变，低位补0

	* 计算32>>2 
	* 32的补码 0010 0000 ------>00001 0000(补码) ------>00001 0000(反码) ------>00001 0000(原码) ------> 8
	
	* 计算-32>>2
	* -32的原码 1010 0000
	* -32的反码 1101 1111
	* -32的补码 1110 0000 ------>1111 1000(补码) ------>1111 0111(反码) ------>10000 1000(原码) ------> -8

	* 计算32<<2
	* 32的补码 0010 0000 ------>0010 0000 00(补码) ------>0010 0000 00(反码) ------>0010 0000 00(原码) ------> 128

	* 计算-32<<2
	* -32的补码 1110 0000 ------>1110 0000 00(补码) ------>1101 1111 11(反码) ------>1010 0000 00(原码) ------> -128
	*/

	/*
	fmt.Println(32>>2)
	fmt.Println(32<<2)
	fmt.Println(-32>>2)
	fmt.Println(-32<<2)
	*/
}