/**
 * onmousemove，该事件会在鼠标在元素中移动时被触发
 * 事件对象
 *    1、当事件的响应函数被触发时，浏览器每次都会将一个事件对象作为实参传递进响应函数
 *       在事件对象中封装了当前事件相关的一切信息
 *    2、在IE8及以下浏览器中，响应函数被触发时，浏览器不会传递事件对象，而是将事件对象作为window对象的属性保存的
 *       可以使用event = event || window.event解决事件对象兼容性问题
 *    3、属性
 *       altKey，"ALT"键是否被按下
 *       button，哪个鼠标按钮被按下
 *       clientX，鼠标指针的水平坐标，用于获取鼠标在当前可见窗口的水平坐标
 *       clientY，鼠标指针的垂直坐标，用于获取鼠标在当前可见窗口的垂直坐标
 *       pageX，鼠标指针的水平坐标，用于获取鼠标在整个页面的水平坐标，不支持IE8及以下浏览器
 *       pageY，鼠标指针的垂直坐标，用于获取鼠标在整个页面的垂直坐标，不支持IE8及以下浏览器
 *       ctrlKey，"CTRL"键是否被按下
 *       metaKey，"metaKey"键是否被按下
 *       relatedTarget，与事件的目标节点相关的节点
 *       screenX，当某个事件被触发时，鼠标指针的水平坐标
 *       screenY，当某个事件被触发时，鼠标指针的垂直坐标
 *       shiftKey，"shift"键是否被按下
 * 事件冒泡(Bubble)：指事件的向上传递，当后代元素的事件被触发时，其祖先元素的相同事件也会被触发
 *     可以通过事件对象取消冒泡，设置event.cancelBubble = true;
 * 事件的委派：指将事件统一绑定给元素共同的祖先元素，这样后代元素事件被触发时，会一直冒泡到祖先元素，从而通过祖先元素的响应函数来处理事件
 *     event的target表示触发事件的对象
 * 事件的绑定
 *     1、使用 对象.事件=函数 的方式绑定响应函数的方式，只能同时为一个元素的一个事件绑定一个响应函数，如果绑定了多个，后面的会覆盖掉前面的
 *     2、使用addEventListener()
 *        可以同时为一个元素的相同事件绑定多个响应函数，其中的this为绑定事件的对象
 *        当事件被触发时，响应函数会按照函数的绑定顺序执行，在IE8及以下浏览器不支持
 *            参数一：事件的字符串，不要on
 *            参数二：回调函数，当事件被触发时函数会被调用
 *            参数三：是否在捕获阶段触发事件，一般为false
 *     3、使用attachEvent()
 *        在IE8及以下浏览器中使用attachEvent()来绑定事件
 *        可以同时为一个元素的相同事件绑定多个响应函数，执行顺序与绑定顺序相反，其中的this为window
 *        可以使用匿名函数作为浏览器的回调函数，然后在匿名函数中使用call方法调用响应函数
 *            参数一：事件的字符串，要on
 *            参数二：回调函数
 * 事件的传播
 *     关于事件的传播网景公司和微软公司有不同的理解
 *     微软公司认为事件应该由内向外传播，也就是当事件触发时，应该先触发当前元素上的事件，然后再向当前元素的祖先元素上传播，也就是说事件在冒泡阶段执行
 *     网景公司认为事件应该由外向内传播，也就是当事件触发时，应该先触发当前元素的最外层的祖先元素的事件，然后再向内传播给后代元素
 *     W3C综合两家公司的方案，将事件传播分为三个阶段
 *        1、捕获阶段
 *           从最外层的祖先元素，向目标元素进行事件的捕获，但是默认此时不会触发事件，在IE8及以下浏览器中没有捕获阶段
 *        2、目标阶段
 *           事件捕获到目标元素，捕获结束开始在目标元素上触发事件
 *        3、冒泡阶段
 *           事件从目标元素向它的祖先元素上传递，依次触发祖先元素上的事件
 *     如果希望在捕获阶段就触发事件，可以将addEventListener()中的第三个参数改为true，一般我们不希望在捕获阶段触发事件，因而一般为false
 * 拖拽
 *     当拖拽网页内容的时候，浏览器会默认到搜索引擎中搜索内容，此时会导致拖拽功能异常，可以通过return false来取消默认行为，对IE8无效
 *     对于IE8可以使用setCapture()捕获所有鼠标按下的事件，使用releaseCapture()取消对事件的捕获
 * 滚动
 *     onmousewheel事件是鼠标滚轮滚动事件，会在鼠标滚轮滚动时触发，但是火狐浏览器不支持
 *        wheelDelta 用于判断鼠标滚动方向，正值向上滚，负值向下滚，不支持火狐浏览器
 *        当滑轮滚动时，如果浏览器有滚动条，滚动条也会随着滚动，可以通过return false来取消默认行为，火狐浏览器不支持
 *     对于火狐浏览器，可以使用addEventListener()
 *        detail 用于判断鼠标滚动方向，负值向上滚，正值向下滚，用于火狐浏览器
 *        当滑轮滚动时，如果浏览器有滚动条，滚动条也会随着滚动，可以通过preventDefault()来取消默认行为，用于火狐浏览器，在IE8中不支持
 * 键盘，一般绑定给可以获取焦点的对象或者document对象
 *    onkeydown，按键被按下，如果一直按住按键，则事件一直会触发
 *      第一次和第二次时间间隔稍微长点，后面的很快，这种设计为了防止误操作
 *      可以通过keycode来获取按键的Unicode编码，从而判断哪个按键被按下
 *      除了keycode，事件对象还提供ctrlKey，altKey，shiftKey用于判断ctrl、alt、shift键是否被按下，按下返回true，否则返回false
 *      在文本框中输入内容，属于onkeydown的默认行为，可以使用return false取消其默认行为，输入的内容不会出现在文本框中
 *    onkeyup，按键被松开
 * */

window.onload = function () {

    /*
    var arreaDiv = document.getElementById("areaDiv");
    var messageDiv = document.getElementById("messageDiv");
    arreaDiv.onmousemove = function (event) {
        event = event || window.event;
        messageDiv.innerHTML = "x:" + event.clientX + " y:" + event.clientY;
    };
    */

    /*
    var redDiv = document.getElementById("redDiv");
    document.onmousemove = function (event) {

        event = event || window.event;
        //方式一 IE8及以下浏览器不支持
        // redDiv.style.left = event.pageX + "px";
        // redDiv.style.top = event.pageY + "px";
        //方式二
        var offsetTop = document.body.scrollTop || document.documentElement.scrollTop;
        var offsetLeft = document.body.scrollLeft || document.documentElement.scrollLeft;
        redDiv.style.top = event.clientY + offsetTop + "px";
        redDiv.style.left = event.clientX + offsetLeft + "px";
    };
    */

    /*
    var spanElement = document.getElementById("spanText");
    spanElement.onclick = function (event) {
        console.log("span单击响应函数");
        event = event || window.event;
        event.cancelBubble = true;
    };

    var contentDiv = document.getElementById("contentDiv");
    contentDiv.onclick = function (event) {
        console.log("div单击响应函数");
        event = event || window.event;
        event.cancelBubble = true;
    };

    document.body.onclick = function (event) {
        console.log("body单击响应函数");
        event = event || window.event;
        event.cancelBubble = true;
    };
    */

    /*
    var listDiv = document.getElementById("listDiv");
    listDiv.onclick = function (event) {
        event = event || window.event;
        var element = event.target;
        if (element.tagName === "A") {
            console.log(element.innerHTML);
        }
    };

    var addButton = document.getElementById("addLink");
    addButton.onclick = function () {
        var ulElement = document.getElementById("linkList");
        var liElement = document.createElement("li");
        liElement.innerHTML = "<li><a href=\"javascript:;\">网易</a></li>";
        ulElement.appendChild(liElement);
    };
    */

    /*
    var bandBtn = document.getElementById("bandBtn");
    bindEvent(bandBtn,"click",function () {
        console.log("click1");
    });
    bindEvent(bandBtn,"click",function () {
        console.log("click2");
    });
    */

    /*
    var deliveDiv1 = document.getElementById("deliveDiv1");
    var deliveDiv2 = document.getElementById("deliveDiv2");
    var deliveDiv3 = document.getElementById("deliveDiv3");
    bindEvent(deliveDiv1,"click",function () {
        console.log("click1");
    });
    bindEvent(deliveDiv2,"click",function () {
        console.log("click2");
    });
    bindEvent(deliveDiv3,"click",function () {
        console.log("click3");
    });
    */

    /*
    var dragDiv = document.getElementById("dragDiv");
    dragElement(dragDiv);
    */

    /*
    var scrollDiv = document.getElementById("scrollDiv");
    scrollElement(scrollDiv);
    */

    /*
    document.onkeydown = function (event) {
        if (event.keyCode === 89){
            console.log("y键被按下");
        }
        if (event.keyCode === 65 && event.altKey){
            console.log("a键和alt键同时被按下");
        }
    };
    document.onkeyup = function (event) {
        // console.log(event);
    };
    */

    /*
    var keyboardDiv = document.getElementById("keyboardDiv");
    document.onkeydown = function (event) {
        event = event || window.event;
        var speed = 300;
        switch (event.keyCode) {
            case 37:
                keyboardDiv.style.left = keyboardDiv.offsetLeft - speed + "px";
                break;
            case 38:
                keyboardDiv.style.top = keyboardDiv.offsetTop - speed + "px";
                break;
            case 39:
                keyboardDiv.style.left = keyboardDiv.offsetLeft + speed + "px";
                break;
            case 40:
                keyboardDiv.style.top = keyboardDiv.offsetTop + speed + "px";
                break;
        }
    };
    */
};

function scrollElement(element) {
    element.onmousewheel = function (scrollEvent) {
        scrollEvent = scrollEvent || window.event;
        if (scrollEvent.wheelDelta > 0 || scrollEvent.detail < 0){
            if (parseInt(element.style.height) <= 30){
                return;
            }
            element.style.height = element.clientHeight - 10 + "px";
        }else {
            if (parseInt(element.style.height) >= 200){
                return;
            }
            element.style.height = element.clientHeight + 10 + "px";
        }
        scrollEvent.preventDefault && scrollEvent.preventDefault();
        return false;
    };
    //为火狐浏览器绑定滚动事件
    element.addEventListener("DOMMouseScroll", element.onmousewheel,false);
}

function dragElement(element) {
    element.onmousedown = function (downEvent) {
        console.log("鼠标按下，开始拖拽");

        element.setCapture && element.setCapture();
        downEvent = downEvent || window.event;
        var mouseOffsetX = downEvent.clientX - element.offsetLeft;
        var mouseOffsetY = downEvent.clientY - element.offsetTop;

        document.onmousemove = function (moveEvent) {
            moveEvent = moveEvent || window.event;
            element.style.left = moveEvent.clientX - mouseOffsetX + "px";
            element.style.top = moveEvent.clientY - mouseOffsetY + "px";
        };

        document.onmouseup = function () {
            console.log("鼠标按下，结束拖拽");
            element.releaseCapture && element.releaseCapture();
            document.onmousemove = null;
            document.onmouseup = null;
        };
        return false;
    };
}

function bindEvent(element, eventStr, callback) {
    if (element.addEventListener){
        element.addEventListener(eventStr,callback,false);
    } else {
        element.attachEvent("on"+eventStr,function () {
            //在匿名函数中调用回调函数
            callback.call(element);
        });
    }
}