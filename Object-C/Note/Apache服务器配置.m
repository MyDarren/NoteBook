配置Apache服务器，目的：有一个自己专属的测试环境
安装Apache （MAC 10.10）

一、目的：
1.	能够有一个测试的服务器，不是所有的特殊网络服务都能找到免费的！

二、为什么是 "Apache"

1.	使用最广的 Web 服务器
2.	Mac自带，只需要修改几个配置就可以，简单，快捷
3.	有些特殊的服务器功能，Apache都能很好的支持

三、	准备工作
1.	设置用户密码

四、 配置服务器

1.  配置服务器的工作
1>  在Finder中创建一个"Sites"的文件夹，直接创建在/Users/apple(当前用户名)目录下
2>  修改配置文件中的"两个路径"，指向刚刚创建的文件夹
3>  拷贝一个文件

2.	配置服务器注意事项
1>  关闭中文输入法
2>	命令和参数之间需要有"空格"
3>	修改系统文件一定记住"sudo"，否则会没有权限
4>  目录要在/Users/apple(当前用户名)

3.	配置服务器
提示：$开头的，可以拷贝，但是不要拷贝$

// 切换工作目录
$cd /etc/apache2

// *** 备份文件，以防不测，只需要执行一次就可以了
$sudo cp httpd.conf httpd.conf.bak

// 提示：如果后续操作出现错误！可以使用以下命令，恢复备份过的 httpd.conf 文件
$ sudo cp httpd.conf.bak httpd.conf

// vim里面只能用键盘，不能用鼠标
// 用vim编辑httpd.conf
$sudo vim httpd.conf
// 查找DocumentRoot
* /DocumentRoot
"键盘方向键控制，将光标移动到首行"
// 进入编辑模式
* i
"修改引号中的路径"
修改两个lib/WebSer/Docume改成我们自己的/Users/liuty/Sites

// 进入命令模式
* ESC
// 查找DocumentRoot
* n
"将光标移动到首行"
// 进入编辑模式
* i
"修改括号中的路径"
// 进入命令模式
* ESC

# 继续向下，按向下键，不要用鼠标

找到
Options FollowSymLinks Multiviews

加一个单词  (注意:10.10以下系统不需要修改此项)

Options Indexes FollowSymLinks Multiviews

// 查找php
* /php
"将光标移动到首行"
// 删除行首注释#

* x
// 保存并退出
* :wq
// 不保存退出!!!!!!!!!
* :q!
// 切换工作目录
$cd /etc
// 拷贝php.ini文件
$sudo cp php.ini.default php.ini
// 重新启动apache服务器
$sudo apachectl -k restart


如果提示以下错误是正常的：
httpd: Could not reliably determine the server's fully qualified domain name, using teacher.local for ServerName
httpd not running, trying to start

测试 Apache 服务器

在浏览器地址栏输入 127.0.0.1

安装过程中，可能出现的问题：

1. 由于不熟悉，vim里面感觉自己做了什么不应该做的，一定不要保存
# 不保存退出
:q!

2. 在输入sudo的时候，会要求输入密码
如果开机没有密码，是不允许使用sudo的

打开“系统偏好”“--》”“更改密码”

3. 如果配置完成之后，提示没有权限访问，绝大多数目录写错了

4. 如果点击“php”，出现“下载”或者显示php的源文件内容
说明php没有配置成功！

－没有打开httpd.conf中php一行的注释
－没有拷贝php.ini

如果以上俩个步骤都完成了，还不行可以将Apache停止一下，然后再启动
# 停止apache服务器
$ sudo apachectl -k stop

# 启动apache服务器
$ sudo apachectl -k start

5. Apache是一个服务器，为了保证用户的安全，每次重新启动计算机Apache不会自动启动
需要进入终端，手动启动一次

# 启动apache服务器
$ sudo apachectl -k start
