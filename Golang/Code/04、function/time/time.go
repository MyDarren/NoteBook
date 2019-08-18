package main

import (
	"fmt"
	"time"
)

/**
time.Time类型
*/

func main() {
	//1、获取当前时间 time.Now()
	now := time.Now()
	fmt.Printf("now:%v--type:%T\n", now, now)

	//2、通过now获取年月日，时分秒
	fmt.Printf("年:%v\n", now.Year())
	fmt.Printf("月:%v\n", now.Month())
	fmt.Printf("日:%v\n", now.Day())
	fmt.Printf("时:%v\n", now.Hour())
	fmt.Printf("分:%v\n", now.Minute())
	fmt.Printf("秒:%v\n", now.Second())

	//3、格式化时间
	//方式一
	dateStr := fmt.Sprintf("当前时间%02d-%02d-%02d %02d:%02d:%02d", now.Year(), now.Month(),
		now.Day(), now.Hour(), now.Minute(), now.Second())
	fmt.Println(dateStr)
	//方式二
	//"2006/01/02 15:04:05"这个字符串的各个数字是固定的，必须这样写，各个数字可以自由组合
	fmt.Printf("当前时间%v\n", now.Format("2006/01/02 15:04:05"))

	/**4、时间相关的常量
	const (
		Nanosecond Duration = 1 //纳秒
		Microsecond = 1000 * Nanosecond //微秒
		Millisecond = 1000 * Microsecond //毫秒
		Second = 1000 * Millisecond //秒
		Minute = 60 * Second //分钟
		Hour = 60 * Minute //小时
	)
	常量的作用：在程序中可用于获取指定时间单位的时间，比如想得到100毫秒 100 * time.Millisecond
	*/
	for i := 0; i < 5; i++ {
		// fmt.Printf("%v--%v\n", i, time.Now().Second())
		// time.Sleep(1 * time.Second) //休眠
	}

	//5、时间戳
	fmt.Printf("时间戳%v秒--%v纳秒\n", now.Unix(), now.UnixNano())
}
