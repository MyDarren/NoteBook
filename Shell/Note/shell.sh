#!/bin/bash

#age=5
#readonly age
#age=7
#uname name
#$echo $name

# $0表示脚本文件名称，参数下标从1开始
# $?表示上一条命令执行状态返回值,0表示执行成功
# $#表示获取脚本输入参数个数
# $$表示获取当前进程PID
# $!表示上一条指令PID
# $*表示参数列表，将所有参数组成一个字符串
# $@表示参数列表，每个参数都是分开的
#name="zhangsan"
#echo ${name}abchh
#unset name
#echo $name
#echo "姓名：$1,年龄：$2,性别：$3"
#echo "参数个数:$#"
#echo "上一条命令返回状态:$?"
#echo "当前进程PID:$$"
#echo "参数列表$*"
#echo "参数列表$@"
#echo "$0$1"
#echo "$0$name"

#string="I have a dream"
# 获取字符串长度
#str=${#string}
# 从下标为1开始截取，长度为2
#str=${string:1:2}
# 从下标为2开始截取
#str=${string:2}
# 从右边开始算起第7个字符开始截取，长度为4
#str=${string:0-7:4}
# 从右边开始算起第5个字符开始截取
#str=${string:0-5}
# 从左边开始查找，查找到第一个出现该字符的位置，并删除该字符（包含该字符）前面所有的字符
#str=${string#*a}
# 从右边开始查找，查找到第一个出现该字符的位置，并删除该字符（包含该字符）前面所有的字符
#str=${string##*a}
# 从右边开始匹配，查找到第一次出现该字符的位置，并删除该字符（包含该字符）后面所有的字符
#str=${string%a*}
# 从右边开始匹配，查找到第一次出现该字符的位置，并删除该字符（包含该字符）后面所有的字符
#str=${string%%a*}
#echo $str

#var=http://www.baidu.com/index.html
# #*// 表示从左边开始删除第一个 / 号及左边的所有字符，即删除http:/
#echo ${var#*/}  # /www.baidu.com/index.html
# ##*/ 表示从左边开始删除最后（最右边）一个 / 号及左边的所有字符，即删除http://www.baidu.com/
#echo ${var##*/} # index.html
# %/* 表示从右边开始删除第一个 / 号及右边的所有字符，即删除/index.html
#echo ${var%/*}  # http://www.baidu.com
# %%/* 表示从右边开始，删除最后（最左边）一个 / 号及右边的所有字符，即删除//www.baidu.com/index.html
#echo ${var%%/*} # http:


#echo hello world
#echo "hello world"
#不换行
#echo "hello\nworld"
# -e开启转义功能，换行
#echo -e "hello\nworld"

#两行会换行
#echo "hello"
#echo "world"

#两行不会换行
# -e开启转义功能，\c表示不换行
#echo -e "hello \c"
#echo "world"

#显示执行命令
#echo `date`
#echo $(date)

#names=("zhangsan" "lisi" "wangwu")
#默认输出数组第一个数据
#echo $names
#echo ${names[1]}
#输出数组所有数据，将所有元素组成一个字符串"zhangsan lisi wangwu"
#echo ${names[*]}
#输出数组所有数据，每个元素分开"zhangsan" "lisi" "wangwu"
#echo ${names[@]}
#获取数组元素个数
#echo ${#names[@]}
#获取数组元素个数
#echo ${#names[*]}
#获取数组单个元素字符个数
#echo ${#names[0]}

#a=100
#b=50

#################### 算术运算符 ####################
#加法
#c=`expr $a + $b`
#c=$(expr $a + $b)
#c=$[$a + $b]
#c=$(echo "$a + $b" | bc)
#c=$(echo "scale=7;355/113" | bc)
#c=$(bc << FG
#    x=$a * $b
#    y=$a + $b
#    x * y
#FG)
#减法
#c=`expr $a - $b`
#乘法
#c=`expr $a \* $b`
#除法
#c=`expr $a / $b`
#取余
#c=`expr $a % $b`
#赋值
#c=$a
#相等
#if [ $a == $b ]
#then
#    echo "a等于b"
#else
#    echo "a不等于b"
#fi
#不相等
#if [ $a != $b ]
#then
#    echo "a等于b"
#else
#    echo "a不等于b"
#fi

#################### 关系运算符 ####################
#括号和运算符两边必须有空格
#关系运算符只支持数字，不支持字符串，除非字符串的值是数字
#等于
#if [ $a -eq $b ]
#then
#    echo "a等于b"
#else
#    echo "a不等于b"
#fi

#不等于
#if [ $a -ne $b ]
#then
#    echo "a不等于b"
#else
#    echo "a等于b"
#fi

#大于
#if [ $a -gt $b ]
#then
#    echo "a大于b"
#else
#    echo "a不大于b"
#fi

#大于等于
#if [ $a -ge $b ]
#then
#    echo "a大于等于b"
#else
#    echo "a不大于等于b"
#fi

#小于
#if [ $a -lt $b ]
#then
#    echo "a小于b"
#else
#    echo "a不小于b"
#fi

#小于等于
#if [ $a -le $b ]
#then
#    echo "a小于等于b"
#else
#    echo "a不小于等于b"
#fi

#################### 布尔运算符 ####################
#或运算
#if [ $a -gt 10 -o $b -eq 50 ]
#then
#echo "成立"
#else
#echo "不成立"
#fi

#与运算
#if [ $a -gt 10 -a $b -eq 50 ]
#then
#    echo "成立"
#else
#    echo "不成立"
#fi

#非运算
#if [ $a != $b ]
#then
#    echo "a不等于b"
#else
#    echo "a等于b"
#fi

#################### 逻辑运算符 ####################
#逻辑或
#if [ $a -gt 10 ] || [ $b -eq 50 ]
#then
#    echo "成立"
#else
#    echo "不成立"
#fi

#逻辑与
#if [ $a -gt 10 ] && [ $b -eq 50 ]
#then
#    echo "成立"
#else
#    echo "不成立"
#fi

#################### 字符串运算符 ####################
#name1="zhangsan"
#name2="lisi"
#字符串是否相等
#if [ $name1 = $name2 ]
#then
#    echo "相等"
#else
#    echo "不相等"
#fi

#字符串是否不相等
#if [ $name1 != $name2 ]
#then
#   echo "不相等"
#else
#   echo "相等"
#fi

#字符串长度是否为0
#if [ -z $name1 ]
#then
#    echo "长度为0"
#else
#    echo "长度不为0"
#fi

#字符串长度是否不为0
#if [ -n "$name1" ]
#then
#    echo "长度不为0"
#else
#    echo "长度为0"
#fi

#字符串是否不为空
#if [ $name1 ]
#then
#    echo "字符串不为空"
#else
#    echo "字符串为空"
#fi

#pwd=`pwd`
#name=$0
#file=$pwd${name:1}
#################### 文件测试运算符 ####################
#是否为块设备文件
#if [ -b $file ]
#then
#    echo "块设备文件"
#else
#    echo "不为块设备文件"
#fi

#是否为字符设备文件
#if [ -c $file ]
#then
#    echo "字符设备文件"
#else
#    echo "不为字符设备文件"
#fi

#是否为目录
#if [ -d $file ]
#then
#    echo "目录文件"
#else
#    echo "不为目录文件"
#fi

#是否为普通文件
#if [ -f $file ]
#then
#    echo "普通文件"
#else
#    echo "不为普通文件"
#fi

#文件是否可读
#if [ -r $file ]
#then
#    echo "文件可读"
#else
#    echo "文件不可读"
#fi

#文件是否可写
#if [ -w $file ]
#then
#    echo "文件可写"
#else
#    echo "文件不可写"
#fi

#文件是否可执行
#if [ -x $file ]
#then
#    echo "文件可执行"
#else
#    echo "文件不可执行"
#fi

#文件是否不为空
#文件存在，但里面没有内容
#if [ -s $file ]
#then
#    echo "文件不为空"
#else
#    echo "文件为空"
#fi

#文件目录是否存在
#if [ -e $file ]
#then
#    echo "文件存在"
#else
#    echo "文件不存在"
#fi

#################### 流程控制 ####################
#if语句
#name1="zhangsan"
#name2="lisi"
#if [ $name1 = $name2 ]
#then
#    echo "名字相同"
#elif [ $name1 != $name2 ]
#then
#    echo "名字不同"
#else
#    echo "~~~~"
#fi

#for语句
#for name in "zhangsan" "lisi" "wangwu"
#do
#    echo $name
#done

#for name in "I do not know"
#do
#    echo $name
#done

#for name in I do not know
#do
#echo $name
#done

#names=("zhangsan" "lisi" "wangwu")
#for name in ${names[*]}
#do
#    echo $name
#done

#for file in `ls`
#do
#    echo $file
#done

#for (( i = 0; i < 5; i++ ))
#do
#    echo $i
#done

#break 后面数字表示退出几层循环，默认为1
#for (( i = 0; i < 5; i++ ))
#do
#    for (( j = 0; j< 5; j++ ))
#    do
#        result=`expr $i \* $j`
#        echo ${result}
#        if [ $j -eq 2 ]
#        then
#            echo "...."
#            break 2
#        fi
#    done
#done

#age=10
#while ((${age}>0))
#do
#    age=`expr $age - 1`
#    echo $age
#done

#age=10
#while [ $age -gt 0 ]
#do
#    age=`expr $age - 1`
#    echo $age
#done

#while true
#do
#    echo "hello"
#done

#age=10
#until (($age<1))
#do
#    age=`expr $age - 1`
#    echo $age
#    if [ $age = 5 ]
#    then
#        echo "exit..."
#        break
#    fi
#done

#read -p "请输入数字" number
#case $number in
#1)
#    echo "等于1"
#    ;;
#2)
#    echo "等于2"
#    ;;
#3)
#    echo "等于3"
#    ;;
#*)
#    echo "错误"
#esac

#################### 文件包含 ####################
#语法一：./filename
#文件A->fileA.sh
#脚本内容
#!/bin/bash
#echo "我是文件A"

#文件B->fileB.sh
#脚本内容
#!/bin/bash
#文件B包含文件A
#./fileA.sh
#echo "我是文件B"
#执行脚本命令
#./fileB.sh

#语法二：source filename.sh
#注意：source是一个关键字
#文件A->fileA.sh
#脚本内容
#!/bin/bash
#echo "我是文件A"

#文件B->fileB.sh
#脚本内容
##!/bin/bash
##文件B包含文件A
#source ./fileA.sh
#echo "我是文件B"
#执行脚本命令
#./fileB.sh

#################### 键盘输入 ####################
#echo "请输入你的名字:"
#read name
#echo "你的名字为：$name"

#read -p "请输入你的名字:" name
#echo "你的名字为：$name"

#if read -t 10 -p "请输入你的名字:" name
#then
#    echo "你的名字为:$name"
#else
#    name="zhangsan"
#    echo "超时了"
#fi

#read -s -p "请输入密码:" pwd
#echo "你的密码为:$pwd"

#cat /etc/profile | while read line
#do
#    echo $line
#done

#################### 屏幕输出 ####################
#echo与printf区别
#区别一
# echo自动换行，printf不换行
#区别二
# echo用于标准化输出，printf用于格式化输出
# %-10s表示左对齐,宽度为10个字符
#printf "%-15s%-10s%-10s\n" 姓名 性别 体重kg
#printf "%-15s%-10s%-10s\n" zhangsan 男 50
#printf "%-15s%-10s%-10s\n" lisi 男 60
#printf "%-15s%-10s%-10s\n" wangwu 男 65
#printf "%-15s%-10s%-10s\n" Andy 女 55

#################### 函数 ####################
#function testFunc() {
#    echo "$0"
#    echo "$1"
#    echo "$2"
#    return 100
#}

#testFunc "zhangsan" "lisi"
#testFunc $1 $2
#echo $?

#################### 输入输出重定向 ####################
#读取三个信息
#第一个文本行数，第二个文本词数，第三个文本字节数
#wc $0

#输入重定向
#cat < $0

#替换
#echo "Hello world" > test.sh
#追加
#echo "$0" >> test.sh

#假设1.txt存在，2.txt不存在
#将错误信息重定向到error.txt
#ls -la 1.txt 2.txt 2> error.txt
#将数据信息重定向到1.txt，将错误信息重定向到error.txt
#ls -la 1.txt 2.txt 1>> 1.txt 2>> error.txt
#将数据信息和错误信息同时定向到total.txt
#ls -la 1.txt 2.txt &> total.txt

#临时重定向
#脚本内容
#echo "Hello world" >&2
#echo $(whoami)
#执行命令：./shell.sh 2> error.txt
#终端显示：
    #test
#error.txt内容：
    #Hello world

#永久重定向
#exec 1> 1.txt
#echo "Hello world"
#echo $(whoami)
#执行命令：
    #./shell.sh
#终端显示：
#1.txt内容：
    #Hello world
    #test

#exec 1> 1.txt
#exec 2> error.txt
#ls -l 1.txt 2.txt
#echo $(whoami)
#执行命令：./shell.sh
#终端显示：
#1.txt内容：
    #-rw-r--r--@ 1 test  staff  0  8 20 23:08 1.txt
    #test
#error.txt内容：
    #ls: 2.txt: No such file or directory

#exec 0< /etc/profile
#count=1
#while read line
#do
#    echo "$count:$line"
#    count=$[ $count + 1 ]
#done
#执行命令：./shell.sh
#终端显示：
    #1:# System-wide .profile for sh(1)
    #2:
    #3:if [ -x /usr/libexec/path_helper ]; then
    #4:eval `/usr/libexec/path_helper -s`
    #5:fi
    #6:
    #7:if [ "${BASH-no}" != "no" ]; then
    #8:[ -r /etc/bashrc ] && . /etc/bashrc
    #9:fi

#自定义重定向
#自定义文件描述符
#exec 5> 1.txt
#echo "Hello world" >&5
#echo $(pwd)
#执行命令：./shell.sh
#终端显示：
    #/Users/test/Desktop
#1.txt内容：
    #Hello world

#清空文件
#cat /dev/null > 1.txt

#创建本地临时文件
#fileName=$(mktemp test.XXXX)
#echo $fileName

#在系统临时目录创建临时文件
#/var/folders/9c/141nq7hj48v0xxrl8pr832y00000gp/T/file.XXXXX.L0gkyamK
#fileName=$(mktemp -t file.XXXXX)
#echo $fileName

#创建临时目录
#dictName=$(mktemp -d dict.XXXXX)
#cd $dictName
#tempfile1=$(umask 022;mktemp file.XXXX)
#tempfile2=$(umask 022;mktemp file.XXXX)
#exec 7> $tempfile1
#exec 8> $tempfile2
#echo "好帅啊" >&7
#echo "天才" >&8

#将输出同时发送的显示器和日志文件
#date | tee 1.txt
#追加
#date | tee -a 1.txt

#必须使用>>
#两个EOF都要换行
#EOF为开始和结束标记，可以使用其他名称作为开始和结束标记，第二个标记必须在行首
#[root@localhost]# cat > 1.txt << EOF
#> insert into test_table (name,sex,age) values("zhangsan","男",18);
#> EOF
#1.txt文件内容：insert into test_table (name,sex,age) values("zhangsan","男",18)

#outfile="test.sql"
#IFS=','
#while read name sex age
#do
#    cat >> $outfile << EOF
#    insert into student(name,age,sex) values("$name","$age","$sex");
#EOF
#done < $1
#执行命令：./shell.sh test.csv
#test.sql文件内容
#insert into student_table(name,age,sex) values("张三","18","男");
#insert into student_table(name,age,sex) values("李四","20","男");
#insert into student_table(name,age,sex) values("Lucy","25","女");
#insert into student_table(name,age,sex) values("Ketty","26","女");
#insert into student_table(name,age,sex) values("David","28","男");

#MYSQL=$(which mysql)
#mysql -u root -p
#-e执行的操作
#$MYSQL -u root -p -e "show databases;"
#直接登录数据库，密码为cyk654321
#$MYSQL -u root -pcyk654321 -e "show databases;"
#指定数据库mysql，-D可选
#$MYSQL -u root -p mysql -e "select * from student;"
#$MYSQL -u root -pcyk654321 -D mysql -e "select * from student;"

#重定向查询数据库
#增删改查sql语句之后要加分号;
#$MYSQL -u root -p -D mysql << EOF
#select * from student;
#insert into student(name,age,sex) values("赵六",25,"男");
#EOF

#if [ $# -ne 3 ]
#then
#    echo "参数错误"
#else
#    $MYSQL -u root -p mysql << EOF
#    insert into student(name,age,sex) values("$1",$2,"$3");
#    update student set age=23 where name="李四";
#EOF
#    if [ $? -eq 0 ]
#    then
#        echo "操作成功"
#    else
#        echo "操作失败"
#    fi
#fi

#插入数据库
#IFS=","
#while read name sex age
#do
#    $MYSQL -uroot mysql << EOF
#    insert into student(name,sex,age) values("$name","$sex",$age);
#EOF
#done < $1
#执行命令：./shell.sh test.csv

#命令who
#参数一：用户名
#参数二：用户所在终端
#参数三：用户登录时间
#终端显示
#test     console  Aug 26 14:55
#test     ttys000  Aug 26 14:55
#test     ttys001  Aug 26 15:37

#命令who -T
#参数一：用户名
#参数二：+表示开启发消息的功能，-表示没有发消息的功能
#参数三：用户所在终端
#参数四：用户登录时间
#终端显示
#test     - console  Aug 26 14:55
#test     + ttys000  Aug 26 14:55
#test     + ttys001  Aug 26 15:37

#命令mesg
#is y表示开启发消息的功能
#终端显示
#is y

#命令mesg y或者mesg n开启和关闭发消息的功能

#在test用户使用的ttys000终端上使用命令write test ttys001可以给test用户使用的ttys000终端上发消息，同时在test ttys001收到test ttys000发送过来的消息后可以使用write test ttys000给test ttys000发送消息，从而实现相互发送消息

#source="ffmpeg-4.0.2"
#if [ ! -r $source ]
#then
#    curl -O https://ffmpeg.org/releases/$source.tar.bz2
#fi

#通过ulimit -a命令查看栈空间大小，Linux系统默认栈空间大小为8M



