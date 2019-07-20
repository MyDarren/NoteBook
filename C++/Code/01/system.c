#include <stdio.h>
#include <stdlib.h>

/**
 * C代码编译成可执行程序四步：
 * 1、预处理：宏定义展开、头文件展开、条件编译，删除代码中的注释，不进行语法检查
 * 2、编译：检查语法，将预处理后的文件编译成汇编文件
 * 3、汇编：将汇编文件生成目标文件(二进制文件)
 * 4、链接：将程序执行需要依赖的库链接到可执行程序中，通过ldd查看程序执行需要的依赖库
 * 
 * gcc system.c -o system 经过预处理、编译、汇编、链接过程
 * 预处理 gcc -E system.c -o system.i
 * 编译   gcc -S system.i -o system.s
 * 汇编   gcc -c system.s -o system.o
 * 链接： gcc system.o system
 * 
 * -E：只进行预处理
 * -S：只进行预处理和编译
 * -c：只进行预处理、编译和汇编
 * -o file：指定生成的输出文件名为file
 * 
 * .c：C语言源文件
 * .i：预处理后的C语言文件
 * .s：编译后的汇编文件
 * .o：汇编后的目标文件
*/

// #define _CRT_SECURE_NO_WARNINGS
// #pragma warning(disable:4996)

int main (int argc,char *avgv[]){
    //调用外部程序
    system("cal");
    return 0;
}