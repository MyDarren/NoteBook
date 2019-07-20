/**
 * BOM，浏览器对象模型，为我们提供来一组对象，可以通过JS操作浏览器
 * 1、BOM对象
 *    (1) Window
 *        代表的是整个浏览器的窗口，同时window也是网页的全局对象
 *          属性：
 *              closed，返回窗口是否已经被关闭
 *              defaultStatus，设置或返回窗口状态栏中的默认文本
 *              document，对document对象的只读引用
 *              history，对history对象的只读引用
 *              innerHeight，返回窗口的文档显示区的高度
 *              innerWidth，返回窗口的文档显示区的宽度
 *              length，设置或返回窗口的框架数量
 *              location，对location对象的只读引用
 *              name，设置或返回窗口的名称
 *              navigator，对navigator对象的只读引用
 *              opener，返回对创建此窗口的窗口的引用
 *              outerHeight，返回窗口的外部高度
 *              outerWidth，返回窗口的外部宽度
 *              pageXOffset，设置或返回当前页面相对于窗口显示区左上角的X位置
 *              pageYOffset，设置或返回当前页面相对于窗口显示区左上角的Y位置
 *              parent，返回父窗口
 *              screen，对screen对象的只读引用
 *              screenLeft、screenTop、screenX、screenY，只读参数，声明了窗口的左上角在屏幕上的的 x 坐标和 y 坐标。
 *                      IE、Safari 和 Opera 支持 screenLeft 和 screenTop，而 Firefox 和 Safari 支持 screenX 和 screenY
 *
 *          方法：
 *              alert()，显示带有一段消息和一个确认按钮的警告框
 *              blur()，把键盘焦点从顶层窗口移开
 *              setInterval()，定时调用，按照指定的周期（以毫秒计）来调用函数或计算表达式
 *                  参数一：回调函数
 *                  参数二：时间间隔，单位毫秒
 *                  返回一个number类型数据，这个数字作为定时器的唯一标识
 *              setTimeout()，延时调用，在指定的毫秒数后调用函数或计算表达式
 *              clearInterval()，取消由setInterval()设置的timeout
 *                  用于关闭定时器，参数为定时器的标识
 *                  可以接受任意参数，如果参数是一个有效的定时器标识，则停止对应的定时器，如果不是有效的标识则什么都不做
 *              clearTimeout()，取消由setTimeout()设置的timeout
 *              close()，关闭浏览器窗口
 *              confirm()，显示带有一段消息和一个确认按钮以及取消按钮的对话框
 *              focus()，把键盘焦点给予某一个窗口
 *              moveBy()，可相对窗口的当前坐标把它移动指定的像素
 *              moveTo()，把窗口的左上角移动到一个指定的坐标
 *              open()，打开一个新的浏览器窗口或查找一个已命名的窗口
 *              print()，打印当前窗口的内容
 *              prompt()，显示可提示用户输入的对话框
 *              resizeBy()，	按照指定的像素调整窗口的大小
 *              resizeTo()，把窗口的大小调整到指定的宽度和高度
 *              scrollBy()，按照指定的像素值来滚动内容
 *              scrollTo()，把内容滚动到指定的坐标
 *
 *    (2) Navigator
 *        代表当前浏览器的信息，通过该对象可以识别不同的浏览器
 *          属性：
 *              appCodeName 浏览器的代码名
 *              appName 浏览器的名称
 *              appVersion 浏览器的平台和版本信息
 *              cookieEnabled 浏览器中是否启用cookie
 *              onLine 系统是否处于脱机模式
 *              platform 运行浏览器的操作系统平台
 *              systemLanguage 操作系统使用的默认语言
 *              userAgent 客户端发送给服务器的user-Agent头部的值
 *              userLanguage 操作系统的自然语言设置
 *        由于历史原因，Navigator对象中的大部分属性已经不能用于识别浏览器，
 *        使用userAgent判断浏览器信息，但由于在IE11中已经将微软和IE相关的表示去除，因而无法使用userAgent判断浏览器是否为IE
 *        可以通过一些浏览器中特有的对象判断浏览器信息，比如ActiveXObject，
 *        使用window.ActiveXObject在IE11中无效，因而使用"ActiveXObject" in window判断
 *    (3) Location
 *        代表当前浏览器的地址栏信息，通过Location可以获取地址栏信息，或者操作浏览器页面跳转
 *        如果直接将location属性修改为一个完整的路径或者相对路径，则页面会跳转到该页面，并且会生成相应的历史记录
 *          属性：
 *              hash，设置或返回从#号开始的URL
 *              host，设置或返回主机名和当前URL的端口号
 *              hostname，设置或返回当前URL的主机名
 *              href，设置或返回完整的URL
 *              pathname，设置或返回当前URL的路径部分
 *              port，设置或返回当前URL的端口号
 *              protocol，设置或返回当前URL的协议
 *              search，设置或返回从?号开始的URL(查询部分)
 *          方法：
 *              assign()，加载新的文档，作用和直接修改location一样，会生成相应的历史记录
 *              reload()，重新加载当前文档，如果在方法中传递true作为参数，则会强制清空缓存刷新页面
 *              replace()，用新的文档替换新的文档，不会生成相应的历史记录，不能使用回退按钮回退
 *    (4) History
 *        代表浏览器的历史记录，可以通过该对象操作浏览器的历史记录
 *        由于隐私的原因，该对象不能获取到具体的历史记录，只能操作浏览器向前和向后翻页，而且该操作只能在当次访问时有效
 *          属性：
 *              length，返回浏览器历史列表中的URL数量
 *          方法：
 *          back()，加载history列表中前一个URL
 *          forward()，加载history列表中下一个URL
 *          go()，加载history列表中某一个具体页面
 *              1：表示加载history列表中的下一个URL，相当于forward()
 *              2：表示加载history列表中的下两个URL
 *              -1：表示加载history列表中的前一个URL，相当于back()
 *              -2：表示加载history列表中的前两个URL
 *    (5) Screen
 *        代表用户的屏幕信息，通过该对象可以获取到用户的显示器的相关信息
 *          属性；
 *              height，返回显示屏幕的高度
 *              width，返回显示屏幕的宽度
 *              availHeight，返回显示屏幕的高度(除windows任务栏之外)
 *              availWidth，返回显示屏幕的宽度(除windows任务栏之外)
 *              bufferDepth，设置或返回调色板的比特深度
 *              colorDepth，返回目标设备或缓冲期上调色板的比特深度
 *              deviceXDPI，返回显示屏幕每英寸水平点数
 *              deviceYDPI，返回显示屏幕每英寸垂直点数
 *              logicalXDPI，返回显示屏幕每英寸的水平方向的常规点数
 *              logicalYDPI，返回显示屏幕每英寸的垂直方向的常规点数
 *              fontSmoothingEnabled，返回用户是否在显示控制面板中启用字体平滑
 *              pixelDepth，返回显示屏幕的颜色分辨率(比特每像素)
 *
 *    这些对象在浏览器中都是作为window对象的属性保存的，可以通过window对象来使用，也可以直接使用
 * */

/*
var userAgent = navigator.userAgent;
if (/firefox/i.test(userAgent)){
    console.log("Firefox");
}else if (/chrome/i.test(userAgent)){
    console.log("Chrome");
}else if (/safari/i.test(userAgent)){
    console.log("Safari");
}else if (/msie/i.test(userAgent)){
    console.log("IE");
}else if ("ActiveXObject" in window){
    console.log("IE11");
}
*/


window.onload = function () {

    /*
    var countLabel = document.getElementById("count");
    var number = 0;
    var timer = window.setInterval(function () {
        if (number >= 60){
            window.clearInterval(timer);
        }
        countLabel.innerHTML = number++;
    },1000);
    */

    /*
    var button = document.getElementById("btn");
    button.onclick = function () {
        console.log(history.length);
        history.back();
        history.forward();
        history.go(-2);

        console.log(location);
        location = "https://www.baidu.com";
        location.assign("https://www.baidu.com");
        location.reload();
        location.replace("https://www.baidu.com");

        setTimeout(function () {
            console.log(window.innerWidth);
        },3000);
    };
    */
};