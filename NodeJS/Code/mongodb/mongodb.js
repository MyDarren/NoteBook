/**
 * 1、启动数据库
 * 		MongoDB默认使用mongod命令所在盘符根目录下的/data/db作为数据存储目录
 *   	第一次使用该命令时需要手动创建好数据存储目录，使用mongod --dbpath修改数据存储目录路径
 *    	mongod --dbpath ~/Downloads/NoteBook/NodeJS/Code/mongodb/db/
 * 2、连接数据库
 * 		mongo默认连接本机MongoDB服务，使用exit推出连接
 * 3、基本命令
 * 		show dbs 								查看所有数据库
 * 		db 		 								查看当前操作的数据库
 * 		use DATABASE_NAME						切换到指定的数据库，没有则新建数据库，
 * 												新创建的数据库不会立即出现在数据库列表中，需要向数据库中插入一些数据来显示
 * 												默认的数据库为 test，如果没有创建新的数据库，集合将存放在 test 数据库中
 * 	    db.dropDatabase()						删除数据库，需要先use DATABASE_NAME切换到想要删除的数据库中
 * 		db.COLLECTION_NAME.insertOne(数据)		插入数据，在 MongoDB 中，集合只有在内容插入后才会创建
 * 		db.COLLECTION_NAME.find()				查询数据库集合中的数据，需要先use DATABASE_NAME切换到想要查询的数据库中
 * 		show collections						查询数据库中的集合，需要先use DATABASE_NAME切换到想要查询的数据库中
 * 		db.COLLECTION_NAME.drop()				删除数据库指定的集合，需要先use DATABASE_NAME切换到想要删除集合的数据库中
 *
 * 4、在Node中操作数据库
 * 		(1) 使用官方mongodb包操作，npm install mongodb --save
 * 			地址：https://github.com/mongodb/node-mongodb-native
 * 		(2) 使用第三方mongoose操作，基于官方的mongodb进一步封装
 * 			官网：https://mongoosejs.com/
 * 			npm install mongoose --save
 */

var mongoose = require('mongoose');
/**
 * 1、连接数据库
 * 数据库不需要存在，当插入第一条数据之后就会被自动创建出来
 */
mongoose.connect('mongodb://localhost/DarrenDB');

var Schema = mongoose.Schema;

// 2、设计文档结构
// var blogSchema = new Schema({
// 	title: String,
// 	author: { type: String, required: true },
// 	body: String,
// 	comments: [{ body: String, date: Date }],
// 	date: { type: Date, default: Date.now },
// 	hidden: Boolean,
// 	blogType: { type: Number, enum: [0,1], default: 0 },
// 	meta: {
// 		votes: Number,
// 		favs: Number
// 	}
// });

/**
 * 3、将文档结构转换为模型
 * 参数一：传入一个大写单数字符串表示集合名称，mongoose会自动转换为小写复数的集合名称，例如Blog-->blogs
 * 		  集合不需要存在，当插入第一条数据之后就会被自动创建出来
 * 参数二：文档结构
 * 返回值：模型构造函数
 */
// var Blog = mongoose.model('Blog',blogSchema);

// 创建一个实例
// var blog = new Blog({
// 	title: '要不要那么帅',
// 	author: 'Darren',
// 	body: '真的好帅啊',
// 	comments: [{body: '确实好帅', date: new Date()}],
// 	date: new Date(),
// 	hidden: false,
// 	blogType: 1,
// 	meta: {votes: 1, favs: 1}
// });

/**
 * 添加数据
 */
// blog.save(function (error,result) {
// 	if (error) {
// 		console.log('保存失败');
// 	}else{
// 		console.log('保存成功');
// 	}
// });

/**
 * 删除数据
 * 1、根据条件删除一个
 * 	  Model.findOneAndRemove(conditions,[options],callback)
 * 2、根据id删除一个
 * 	  Model.findByIdAndRemove(id,[options],callback)
 * 3、根据条件删除所有
 * 	  Model.remove(conditions,[options],callback)
 */

// Blog.remove({
// 	author: 'Darren'
// },function (error,result) {
// 	if (error) {
// 		console.log('删除失败');
// 	}else{
// 		console.log(result);
// 	}
// });

/**
 * 更新数据
 * 1、根据条件更新所有
 * 	  Model.update(conditions,[updates],[options],callback)
 * 2、根据条件更新单个
 * 	  Model.findOneAndUpdate(conditions,[updates],[options],callback)
 * 3、根据id更新单个
 * 	  Model.findByIdAndUpdate(id,[updates],[options],callback)
 */

// Blog.findByIdAndUpdate('5bcab1a16ef29d0b15fa18de',{
// 	body: '帅的不要不要的'
// },function (error,result) {
// 	if (error) {
// 		console.log('更新失败');
// 	}else{
// 		console.log(result);
// 	}
// });

// Blog.findOneAndUpdate({
// 	'_id': '5bcab1a16ef29d0b15fa18de'
// },{
// 	'title': '帅呆了'
// },function (error,result) {
// 	if (error) {
// 		console.log('更新失败');
// 	}else{
// 		console.log(result);
// 	}
// });

/**
 * 查询数据
 * 1、查询所有
 * 	  Model.find(callback)，返回数组
 * 2、根据条件查询
 * 	  Model.find(conditions,[options],callback)，返回数组
 * 3、根据条件查询单个
 * 	  Model.findOne(conditions,[options],callback)，返回查询到的第一个对象
 * 4、根据id查询
 *    Model.findById(id,[options],callback)
 */

// Blog.find(function (error,result) {
// 	if (error) {
// 		console.log('查询失败');
// 	}else{
// 		console.log(result);
// 	}
// });

// Blog.find({
// 	author: 'Darren'
// },function (error,result) {
// 	if (error) {
// 		console.log('查询失败');
// 	}else{
// 		console.log(result);
// 	}
// });

// 多条件查询
// Blog.findOne({
// 	author: 'Darren',
// 	hidden: false
// },function (error,result) {
// 	if (error) {
// 		console.log('查询失败');
// 	}else{
// 		console.log(result);
// 	}
// });

var userSchema = new Schema({
	name: { type : String, required: true },
	age : Number,
	password : { type : String, required : true }
});

var User = mongoose.model('User',userSchema);

// 创建一个实例
var user = new User({
	name : 'Lucy',
	age : 18,
	password : '123456'
});

User.findOne({
	name : user.name
})
	.then(function (findUser){
		if (findUser) {
			console.log('用户已经存在');
		}else{
			return user.save();
		}
	})
	.then(function (saveUser){
		console.log('保存成功');
	})

	







