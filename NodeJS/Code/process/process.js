
setInterval(function(){
    console.log(1);
},1000);

var exiting = false;

// 按下Ctrl-C会执行该方法
process.on('SIGINT',() => {
    if (exiting) {
        // 终止当前进程
        process.exit();
        console.log('exiting...');
    }else{
        exiting = true;
        console.log('Get SIGINT.Press Ctrl-C to exit');
        setTimeout(() => {
            exiting = false;
        }, 1000);
    }
});