/**
 * 1、修改元素样式
 *    元素.style.样式名=样式值
 *    如果样式名中含有"-"，比如background-color，这种名称在JS中不合法，需要将样式名修改为驼峰命名法，去掉"-"，然后将"-"后的字母大写
 *    通过style属性设置的样式为内联样式，而内联样式有较高的优先级，通过JS修改后往往会立即显示
 *    在样式中使用!important，此时样式具有最高的优先级，即使通过JS修改也不能覆盖该样式，导致JS修改失效，尽量不要在样式中使用!important
 *
 * 2、读取元素样式
 *    (1) 元素.style.样式名
 *        通过style属性读取的样式为内联样式，通过样式表设置的样式读取不到，包括外部样式表和内部样式表
 *
 *    (2) 元素.currentStyle.样式名
 *        可以用来获取当前正在显示的样式，该属性只兼容IE和Opera,不兼容火狐和谷歌
 *        读取到的样式是只读的，不能修改，要修改的话必须使用style方式
 *        如果元素获取的样式没有设置，则返回该样式的默认值，如没有设置width，则返回auto
 *
 *    (3) window.getComputedStyle(ele,null)
 *        该方法在IE8及以下浏览器中不支持
 *        读取到的样式是只读的，不能修改，要修改的话必须使用style方式
 *        第一个参数为原获取样式的元素，第二个参数可以传递一个伪元素，一般为null
 *        返回一个对象，该对象中封装元素的样式，可以通过该对象.样式名来读取样式
 *        如果元素获取的样式没有设置，则会读取到真实的值，而不是默认值，如没有设置width，则返回具体px值
 *
 *    (4) clientHeight、clientWidth 获取元素的可见高度和宽度，返回的是数字，包括内容区和内边距，不包括边框和外边距，只读
 *        offsetHeight、offsetWidth 获取元素的高度和宽度，返回的是数字，包括内容区、内边距和边框，不包括外边距，只读
 *        offsetParent 获取当前元素的定位父元素，即离当前元素最近并开启定位的祖先元素，如果所有的祖先元素都没有开启定位，则返回body
 *        offsetLeft 获取当前元素相对于其定位父元素的水平偏移量，返回的是数字
 *        offsetTop 获取当前元素相对于其定位父元素的垂直偏移量，返回的是数字
 *        scrollHeight 获取元素的整体高度，父元素是否设置overflow不影响返回值，只会影响效果
 *        scrollWidth 获取元素的整体宽度，父元素是否设置overflow不影响返回值，只会影响效果
 *        scrollLeft 获取元素左边缘与视图之间的距离，可以获取水平滚动条滚动的距离
 *        scrollTop 获取元素上边缘与视图之间的距离，可以获取垂直滚动条滚动的距离
 *        当满足scrollHeight - scrollTop == clientHeight时，说明垂直滚动条滚动到底
 *        当满足scrollWidth - scrollLeft == clientWidth时，说明水平滚动条滚动到底
 * */

window.onload = function (ev) {

    var btn1 = document.getElementById("btn1");
    btn1.onclick = function (ev1) {
        var box1 = document.getElementById("box1");
        box1.style.width = "100px";
        box1.style.height = "100px";
        // box1.style.background-color = "yellow"; //Uncaught ReferenceError: Invalid left-hand side in assignment
        box1.style.backgroundColor = "yellow";
        console.log(box1.style.margin); //"auto"
        console.log(box1.style.borderWidth); //空
        console.log(box1.style.borderColor); //空
        // console.log(box1.currentStyle.borderColor); //Uncaught TypeError: Cannot read property 'borderColor' of undefined

        var cssObject = window.getComputedStyle(box1,null);
        console.log(cssObject.borderColor); //rgb(255, 0, 255)
        console.log(cssObject.borderWidth); //0px

        console.log(typeof box1.clientHeight); //number
        console.log(box1.clientHeight); //100
        console.log(box1.clientWidth); //100
        console.log(box1.style.width); //100px
        console.log(box1.style.height); //100px

        box1.style.padding = "10px";
        console.log(box1.clientHeight); //120
        console.log(box1.clientWidth); //120
        console.log(box1.style.width); //100px
        console.log(box1.style.height); //100px

        box1.style.border = "10px solid yellow";
        console.log(box1.clientHeight); //120
        console.log(box1.clientWidth); //120
        console.log(box1.style.width); //100px
        console.log(box1.style.height); //100px

        box1.style.margin = "10px auto";
        console.log(box1.clientHeight); //120
        console.log(box1.clientWidth); //120
        console.log(box1.style.width); //100px
        console.log(box1.style.height); //100px

        console.log(box1.offsetHeight); //140
        console.log(box1.offsetWidth); //140
    };

    var btn2 = document.getElementById("btn2");
    btn2.onclick = function (ev1) {
        var box4 = document.getElementById("box4");
        var box7 = document.getElementById("box7");
        var box10 = document.getElementById("box10");

        console.log(box4.offsetParent.id); //"body"
        console.log(box7.offsetParent.id); //"box5"
        console.log(box10.offsetParent.id); //"box10"
        console.log(typeof box4.offsetLeft); //number
        console.log(box4.offsetLeft); //8
        console.log(box7.offsetLeft); //0
        console.log(box10.offsetLeft); //0
    };

    var btn3 = document.getElementById("btn3");
    btn3.onclick = function (ev1) {
        var box11 = document.getElementById("box11");
        var box12 = document.getElementById("box12");

        console.log(box11.clientHeight); //100
        console.log(box11.scrollHeight); //120
        console.log(box11.clientWidth); //100
        console.log(box11.scrollWidth); //200
        console.log(box12.clientHeight); //120
        console.log(box12.scrollHeight); //120
        console.log(box12.clientWidth); //200
        console.log(box12.scrollWidth); //200
        console.log(box11.scrollLeft); //水平滚动条滚动距离
        console.log(box11.scrollTop); //垂直滚动条滚动距离
    };

    var protocolElement = document.getElementById("protocolId");
    var inputs = document.getElementsByTagName("input");
    protocolElement.onscroll = function (ev1) {
        if (this.scrollHeight - this.scrollTop === this.clientHeight){
            inputs[0].disabled = false;
            inputs[1].disabled = false;
        }
    };

    inputs[1].onclick = function () {
        console.log(inputs[0].checked);
        if (!inputs[0].checked) {
            alert("请确认阅读!");
        }else {
            confirm("确定提交吗?") ? alert("提交成功") : alert("提交失败");
        }
    };
};

function getElementCSSStyle(element,styleName) {
    if (window.getComputedStyle()) {
        return window.getComputedStyle(element,null)[styleName];
    } else {
        return element.currentStyle[styleName];
    }
}