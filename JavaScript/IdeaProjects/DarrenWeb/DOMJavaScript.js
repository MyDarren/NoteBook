/**
 * 1、DOM，Document Object Model文档对象模型，JS通过DOM来对HTML文档进行操作
 *    文档表示的就是整个的HTML文档
 *    对象表示将网页中每个部分转换为一个对象
 *    模型用来表示对象之间的关系
 * 2、节点Node：构成网页的最基本组成部分，html标签、属性、文本、注释和整个文档等都是节点
 *      1、节点类型：
 *          (1) 文档节点：整个HTML文档
 *          (2) 元素节点：HTML文档中的HTML标签
 *          (3) 属性节点：元素中的属性
 *          (4) 文本节点：HTML标签中的文本内容
 *      2、节点的属性
 *                          nodeName    nodeType    nodeValue
 *              文档节点    #document       9          null
 *              元素节点      标签名         1          null
 *              属性节点      属性名         2         属性值
 *              文本节点      #text         3        文本内容
 *      3、文档节点document
 *         文档节点对象可以在页面中直接使用，这个对象是window的属性，文档节点代表整个网页
 *
 * 3、获取元素节点，通过document调用
 *       getElementById()，通过id属性获取一个元素节点对象
 *       getElementsByTagName()，通过标签名获取一组元素节点对象
 *          返回一个类数组对象，所有查询到的元素都会封装到对象里
 *       getElementsByName()，通过name属性获取一组元素节点对象
 *       getElementsByClassName，通过元素的class属性值查询一组元素节点对象，不支持IE8及以下的浏览器，可以使用querySelector代替
 *
 * 4、获取元素节点的子节点，通过具体元素节点调用
 *       getElementsByTagName()方法，返回当前节点的指定标签名后代节点
 *       childNodes属性，表示当前节点的所有子节点，会获取包括文本节点在内的所有节点
 *          DOM标签间的空白也会当成文本节点，注意：IE8及以下的浏览器中，不会把空白当成文本节点
 *       child属性，表示当前元素的所有子元素
 *       firstChild属性，表示当前节点的第一个子节点，可能获取空白文本节点
 *       firstElementChild属性，表示当前节点的第一个子元素，不支持IE8及以下的浏览器
 *       lastChild属性，表示当前节点的最后一个节点，可能获取空白文本节点
 *       lastElementChild属性，表示当前节点的最后一个子元素，不支持IE8及以下的浏览器
 *
 * 5、获取元素节点的父节点和兄弟节点
 *       parentNode 表示当前节点的父节点
 *       previousSibling 表示当前节点的前一个兄弟节点，可能获取空白文本节点
 *       previousElementSibling 表示当前节点的前一个兄弟元素，不支持IE8及以下的浏览器
 *       nextSibling 表示当前节点的后一个兄弟节点，可能获取空白文本节点
 *       nextElementSibling 表示当前节点的后一个兄弟元素，不支持IE8及以下的浏览器
 *
 * 6、其他方法
 *       document.body 获取body标签
 *       document.documentElement 获取html根标签
 *       document.all 获取页面中所有的元素
 *       document.getElementsByTagName("*") 获取页面中所有的元素
 *       document.querySelector 根据CSS选择器查询元素节点对象，如果满足条件的元素有多个，只会返回第一个
 *       document.querySelectorAll 与document.querySelector类似，它会将满足条件的元素封装到数组中
 * 7、增删改
 *       appendChild，把新的节点添加到指定节点上，父节点.appendChild(子节点)
 *       removeChild，删除子节点，父节点.removeChild(子节点)
 *       replaceChild，替换子节点，父节点.replaceChild(新节点，旧节点)
 *       insertBefore，在指定子节点前面插入新的子节点，父节点.insertBefore(newChild,refChild)，父节点调用
 *       createAttribute，创建属性节点
 *       createElement，创建元素节点，参数一为标签名，参数二为
 *       createTextNode，创建文本节点，参数为文本内容，将会根据文本内容创建文本节点并返回
 *       getAttribute，获取节点属性值
 *       setAttribute，设置节点属性
 * */

/**
 * 事件，文档或浏览器窗口中发生的一些特定的交互瞬间，JavaScript与HTML之间的交互通过事件实现
 *      如点击某个元素、将鼠标移动至某个元素上方、按下键盘的某个键等
 *      可以在事件对应的属性中编写JS代码，当事件被触发时，执行JS代码
 *      在事件的响应函数中，响应函数是给谁绑定的，this就是谁
 * 事件类型
 *    onabort       图像的加载被中断
 *    onerror       加载文档或图片发生错误
 *    onload        一个页面或图片加载完成
 *    onunload      用户退出页面
 *    onblur        元素失去焦点
 *    onfocus       元素获得焦点
 *    onchange      域的内容被改变
 *    onclick       用户点击某个对象
 *    ondblclick    用户双击某个对象
 *    onkeydown     某个键盘按键被按下
 *    onkeypress    某个键盘按键被按下并松开
 *    onmousedown   鼠标按钮被按下
 *    onmousemove   鼠标被移动
 *    onmouseout    鼠标从某元素移开
 *    onmouseover   鼠标移到某元素上
 *    onmouseup     鼠标按键被松开
 *    onreset       重置按钮被点击
 *    onresize      窗口或框架被重新调整大小
 *    onselect      文本被选中
 *    onsubmit      确认按钮被点击
 *    onscroll      元素滚动条滚动
 * */

/**
 * 浏览器加载页面时，是按照自上向下的顺序加载的，读取一行就运行一行，如果将script标签写在页面上边，可能代码执行时，页面还没有加载
 * 可以为window绑定onload事件，该事件对应的响应事件会在页面加载完成之后再执行，确保代码执行时所有的DOM对象都加载完毕
 * */

/**
 * innerHTML用于获取元素内部的HTML代码，对于自结束标签没有意义
 * innerText用于获取元素内部的文本内容，与innerHTML类似，不同的是它会将HTML标签去除
 * 读取元素节点属性，使用元素.属性名，class属性不能使用这种方式，需要使用元素.className
 *     文本框value值就是文本框中的内容
 * 修改元素节点属性，使用元素.属性名=属性值
 * */

/**
 * 点击超链接后，超链接默认会跳转页面
 * 在a标签的href属性中指定为"javascript:;"可以使链接点击后不跳转，也可以在响应函数中return false取消默认行为
 *
 * confirm()，显示带有一段消息和确定取消按钮的对话框
 *
 * */

// Uncaught TypeError: Cannot set property 'onclick' of null

// var button = document.getElementById("btn");
// button.onclick = function (ev) {
//     button.innerHTML = "搞事情";
// };

window.onload = function () {

    /*
    function elementIdClick(id,clickFunction) {
        var element = document.getElementById(id);
        element.onclick = clickFunction;
    }

    function elementIdDblClick(id,dblClickFunction){
        var element = document.getElementById(id);
        element.ondblclick = dblClickFunction;
    }

    function elementTagName(id,clickFunction){
        var element = document.getElementsByTagName(id);
        element[0].onclick = clickFunction;
    }

    function elementName(id,clickFunction){
        var element = document.getElementsByName(id);
        element[0].onclick = clickFunction;
    }

    elementIdClick("btn",function () {
        this.innerHTML = "搞事情";
    });

    elementIdDblClick("city",function () {
        console.log(this.childNodes); //[text, li, text, li, text, li, text]
        console.log(this.children); //[li, li, li]
        console.log(this.firstChild); //#text
        console.log(this.firstElementChild); //<li>北京</li>
        console.log(this.lastChild); //#text
        console.log(this.lastElementChild);
    });

    elementIdClick("city",function () {
        var cityLists = this.getElementsByTagName("li");
        for (var i = 0; i < cityLists.length; i++) {
            console.log(cityLists[i].innerHTML); //北京 上海 武汉
            console.log(cityLists[i].firstChild.nodeValue); //北京 上海 武汉
        }
    });

    elementTagName("li",function () {
        this.innerHTML = "西安";
    });

    elementName("gender",function () {
        console.log(this); //<input class="input" type="radio" name="gender" value="male">
        console.log(this.value); //male
        console.log(this.className); //input
        console.log(this.parentNode.innerText); //Gender:   Male   Female
    });

    elementIdClick("userId",function () {
        console.log(this.previousSibling); //#text
        console.log(this.previousElementSibling); //<br>
        console.log(this.nextSibling); //#text
        console.log(this.nextElementSibling); //<br>

        console.log(document.body);
        console.log(document.documentElement);
        console.log(document.all.length);

        for (var i = 0; i < document.all.length; i++) {
            console.log(document.all[i]);
        }

        console.log(document.getElementsByClassName("inner"));
        var elements = document.getElementsByTagName("*");
        for (var j = 0; j < elements.length; j++) {
            console.log(elements[j]);
        }

        console.log(document.querySelector(".inner input"));
        console.log(document.querySelectorAll(".inner input"));
    });

    elementIdClick("city",function () {
        this.appendChild();
        this.removeChild();
        this.replaceChild();
        this.insertBefore();
        this.createAttribute();
        this.createElement();
        this.createTextNode();
        this.getAttribute();
        this.setAttribute();
    });

    elementIdDblClick("ul",function () {
        // 方式一
        var liElement = document.createElement("li");
        var textNode = document.createTextNode("台湾");
        liElement.appendChild(textNode);
        liElement.setAttribute("id","tw");
        this.appendChild(liElement);
        console.log(liElement.id);

        // 使用innerHTML也可以完成DOM的增删改查，这种方式创建的节点会导致同一父节点下的子节点被重新创建
        // 因而会将两种方式进行结合
        // var twString = "<li id='tw'>台湾</li>";
        // this.innerHTML += twString;

        // 方式二
        // var liElement = document.createElement("li");
        // liElement.innerHTML = "台湾";
        // liElement.setAttribute("id","tw");
        // this.appendChild(liElement);
    });

    elementIdClick("gd",function () {
        var hnElement = document.createElement("li");
        var textNode = document.createTextNode("湖南");
        hnElement.appendChild(textNode);
        this.parentNode.insertBefore(hnElement,this);
    });

    elementIdClick("sc",function () {
        var cqElement = document.createElement("li");
        var textNode = document.createTextNode("重庆");
        cqElement.appendChild(textNode);
        this.parentNode.replaceChild(cqElement,this);
    });

    elementIdClick("hb",function () {
        var ahElement = document.getElementById("ah");
        this.parentNode.removeChild(ahElement);
    });

    elementIdClick("ah",function () {
        console.log(this.parentNode.innerHTML);
    });

    elementIdClick("hn",function () {
        this.innerHTML = "荷兰";
    });
    */

    /*
    function elemetClickFunction() {
        var trElement = this.parentNode.parentNode;
        var tdNameElement = trElement.firstElementChild;
        confirm("确定删除"+tdNameElement.innerText+"吗?") ? trElement.parentNode.removeChild(trElement) : console.log("cancle...");
        return false;
    }

    var aElements = document.getElementsByTagName("a");
    for (var i = 0; i < aElements.length; i++) {
        aElements[i].onclick = elemetClickFunction;
    }

    elementIdClick("commit",function () {

        var infoTable = document.getElementById("infoTable");
        var name = document.getElementById("nameInput").value;
        var sex = document.getElementById("sexInput").value;
        var score = document.getElementById("scoreInput").value;

        var trElement = document.createElement("tr");
        //方式一
        // var nameTd = document.createElement("td");
        // var sexTd = document.createElement("td");
        // var scoreTd = document.createElement("td");
        // var deleteTd = document.createElement("td");
        // var aElement = document.createElement("a");
        //
        // aElement.innerHTML = "删除";
        // aElement.setAttribute("href","https://www.baidu.com");
        // // aElement.href = "javascript:;";
        // aElement.onclick = elemetClickFunction;
        //
        // nameTd.innerHTML = name;
        // sexTd.innerHTML = sex;
        // scoreTd.innerHTML = score;
        // deleteTd.appendChild(aElement);
        //
        // trElement.appendChild(nameTd);
        // trElement.appendChild(sexTd);
        // trElement.appendChild(scoreTd);
        // trElement.appendChild(deleteTd);

        //方式二
        trElement.innerHTML = "<td>"+name+"</td>"+
                              "<td>"+sex+"</td>"+
                              "<td>"+score+"</td>"+
                              "<td>"+"<a href=\'https://www.jd.com\'>删除</a>"+"</td>";

        var aElement = trElement.getElementsByTagName("a")[0];
        aElement.onclick = elemetClickFunction;

        var tbody = infoTable.getElementsByTagName("tbody")[0];
        tbody.appendChild(trElement);
    })
    */
};

