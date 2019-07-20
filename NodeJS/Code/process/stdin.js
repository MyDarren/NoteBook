
process.stdin.setEncoding('utf8');

// process.stdin.on('readable',() => {
//     var chunk = process.stdin.read();
//     if (chunk !== null) {
//         process.stdout.write(`data:${chunk}`);
//     }
// });

// process.stdin.on('end', () => {
//     process.stdout.write('end');
// });

// process.stdin.on('data',(data) => {
//     console.log(data);
// })

var promptName = '请输入用户名：';
var promptPwd = '请输入密码：';
var users = {
    'admin' : '123',
    'hello' : '456',
    'user' : '789'
};
var user = {};
process.stdout.write(promptName);
process.stdin.on('data',(input) => {
    // process.stdout.write(typeof input);
    //输入的字符带有回车符
    //process.stdout.write(`*${input}*`);
    input = input.trim();
    if (! user.name) {
        if (Object.keys(users).indexOf(input) === -1) {
            process.stdout.write('用户名不存在'+'\n');
            process.stdout.write(promptName);
        }else{
            process.stdout.write(promptPwd);
            user.name = input;
            user.pwd = users[input];
        }
    }else{
        if (user.pwd !== input) {
            process.stdout.write(promptPwd);
        }else{
            process.stdout.write('密码正确'+'\n');
            user = {};
            process.exit();
        }
    }
})
