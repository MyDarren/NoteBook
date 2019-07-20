Xcode6 之后沙盒路径与manBundle路径不一致
1、沙盒目录：
      po NSHomeDirectory()
      应用在沙箱中，在文件读写权限上受到限制，只能在几个目录中读写文件
      Documents：文档目录，保存程序生成的数据，会自动备份到iCloud中，iTunes备份和恢复的时候会包括此目录
      如果保存了下载的数据，程序提交直接被拒绝

      tmp：临时文件，iTunes不会备份和恢复此目录，系统会自动清理。 重新启动，就会清理
      Library/Caches: 存放缓存文件，iTunes不会备份和恢复此目录，此目录文件不会在应用退出删除
      Library/Preferences：偏好设置，使用NSUserDefault保存数据的路径

2、manbundle 路径
      po [[NSBundle mainBundle] bundlePath]

manbundle路径
/Users/apple/Library/Developer/Xcode/DerivedData/02-表格图片下载-dtuhlnxqskojpdfemowsszplsciy/Build/Products/Debug-iphonesimulator/

沙盒路径
/Users/apple/Library/Developer/CoreSimulator/Devices/AA938C24-98DC-4F4A-89E6-EEB4CFA4179D/data/Containers/Data/Application/1313B119-0A26-496F-8CA9-621FB9C6B1F7

po ＝ print object