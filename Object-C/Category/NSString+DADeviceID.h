//
//  NSString+DADeviceID.h
//  CategorySet
//
//  Created by test on 2018/7/15.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (DADeviceID)

/**
 *广告id， 在同一个设备上的所有App都会取到相同的值，是苹果专门给各广告提供商用来追踪用户而设的，用户可以在 设置|隐私|广告追踪 里重置此id的值，或限制此id的使用，故此id有可能会取不到值，但好在Apple默认是允许追踪的
 *如果用户完全重置系统（(设置程序 -> 通用 -> 还原 -> 还原位置与隐私) ，这个广告标示符会重新生成。另外如果用户明确的还原广告(设置程序-> 通用 -> 关于本机 -> 广告 -> 还原广告标示符) ，那么广告标示符也会重新生成
 *iOS 10 系统开始提供禁止广告跟踪功能，用户勾选这个功能后，应用程序将无法读取到设备的IDFA，此时获取到的值为00000000-0000-0000-0000-000000000000
 *如果程序在后台运行，此时用户“还原广告标示符”，然后再回到程序中，此时获取广 告标示符并不会立即获得还原后的标示符。必须要终止程序，然后再重新启动程序，才能获得还原后的广告标示符
 */
+ (NSString *)getDeviceIDFA;

/**
 *IDFA就是用来跟踪广告推广的，而UUID虽然每次不同，但是可以自己手动存入Keychain来进行唯一性的确保，这么说来IDFA就是如果广告商投放的时候使用，而UUID就是自己后台来判断用户是否换了设备，或者信息不一致需要重新登录的业务
 *获得的这个CFUUID值系统并没有存储。每次调用CFUUIDCreate，系统都会返回一个新的唯一标示符。如果你希望存储这个标示符，那么需要自己将其存储到NSUserDefaults, Keychain, Pasteboard或其它地方
 */
+ (NSString *)getDeviceUUID;

/**
 给Vendor标识用户用的，每个设备在所属同一个Vender的应用里，都有相同的值。其中的Vender是指应用提供商，但准确点说，是通过BundleID的反转的前两部分进行匹配，如果相同就是同一个Vender，共享同一个idfv的值。和idfa不同的是，idfv的值是一定能取到的，所以非常适合于作为内部用户行为分析的主id，来标识用户，替代OpenUDID
 */
+ (NSString *)getDeviceIDFV;

@end
