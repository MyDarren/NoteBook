
01. Reachability
================================================================================
框架地址：https://developer.apple.com/library/ios/samplecode/Reachability/Reachability.zip

使用方法

1>  添加一个联网状态监听对象
@property (nonatomic, strong) Reachability *reach;

2>  实例化监听对象
self.reach = [Reachability reachabilityWithHostName:@"www.baidu.com"];

3>  判断联网状态
- (void)netwrokStatusChanged {
    switch (self.reach.currentReachabilityStatus) {
        case NotReachable:
            NSLog(@"没有联网");
            break;
        case ReachableViaWiFi:
            NSLog(@"通过Wi-Fi上网");
            break;
        case ReachableViaWWAN:
            NSLog(@"通过3G上网");
            break;
        default:
            break;
    }
}

4>  利用通知中心实时监听联网状态
[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(netwrokStatusChanged) name:kReachabilityChangedNotification object:nil];
[self.reach startNotifier];

- (void)dealloc {
    // 注册指定的通知监听
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kReachabilityChangedNotification object:nil];
}

02. SDWebImage
================================================================================
官方网站
$ git clone --recursive https://github.com/rs/SDWebImage.git

1>  面试题
1] 如何防止一个url对应的图片重复下载
* "cell下载图片思路 – 有沙盒缓存"

2] SDWebImage的默认缓存时长是多少？
* 1个星期

3] SDWebImage底层是怎么实现的？
* 上课PPT的"cell下载图片思路 – 有沙盒缓存"

2> 常用方法
- (void)sd_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder;
- (void)sd_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options;
- (void)sd_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder completed:(SDWebImageCompletionBlock)completedBlock;
- (void)sd_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options progress:(SDWebImageDownloaderProgressBlock)progressBlock completed:(SDWebImageCompletionBlock)completedBlock;

3> 内存处理：当app接收到内存警告时，SDWebImage做了什么？
- SDWebImage会监听系统的UIApplicationDidReceiveMemoryWarningNotification通知，一旦收到通知，就会清理内存
- 应用程序将要终止的通知,UIApplicationWillTerminateNotification, 清理磁盘
- 应用程序进入后台的通知，UIApplicationDidEnterBackgroundNotification，也会清理磁盘

4> SDWebImageOptions
* SDWebImageRetryFailed : 下载失败后，会自动重新下载
* SDWebImageLowPriority : 当正在进行UI交互时，自动暂停内部的一些下载操作

* SDWebImageRetryFailed | SDWebImageLowPriority : 拥有上面2个功能

// 图片的格式
PNG: 无损压缩！压缩比较低。 PNG图片一般会JPG大。
- GPU解压缩的消耗非常小。解压缩的速度比较快，比较清晰，苹果推荐使用
JPG: 有损压缩！压缩比非常高！照相机使用。
- GPU解压缩的消耗比较大
GIF: 可动画的图片
BMP: (位图)，没有任何压缩。几乎不用


"留待查阅"
typedef NS_OPTIONS(NSUInteger, SDWebImageOptions) {
    /**
     * By default, when a URL fail to be downloaded, the URL is blacklisted so the library won't keep trying.
     * 默认情况下，当一个 URL 下载失败，会将该 URL 放在黑名单中，不再尝试下载
     *
     * This flag disable this blacklisting.
     * 此标记取消黑名单
     */
    SDWebImageRetryFailed = 1 << 0,
    
    /**
     * By default, image downloads are started during UI interactions, this flags disable this feature,
     * 默认情况下，在 UI 交互时也会启动图像下载，此标记取消这一特性
     *
     * leading to delayed download on UIScrollView deceleration for instance.
     * 会推迟到滚动视图停止滚动之后再继续下载(这个注释是假的！)
     */
    SDWebImageLowPriority = 1 << 1,
    
    /**
     * This flag disables on-disk caching
     * 此标记取消磁盘缓存，只有内存缓存
     */
    SDWebImageCacheMemoryOnly = 1 << 2,
    
    /**
     * This flag enables progressive download, the image is displayed progressively during download as a browser would do.
     * 此标记允许渐进式下载，就像浏览器中那样，下载过程中，图像会逐步显示出来
     *
     * By default, the image is only displayed once completely downloaded.
     * 默认情况下，图像会在下载完成后一次性显示
     */
    SDWebImageProgressiveDownload = 1 << 3,
    
    /**
     * Even if the image is cached, respect the HTTP response cache control, and refresh the image from remote location if needed.
     * 即使图像被缓存，遵守 HTPP 响应的缓存控制，如果需要，从远程刷新图像
     *
     * The disk caching will be handled by NSURLCache instead of SDWebImage leading to slight performance degradation.
     * 磁盘缓存将由 NSURLCache 处理，而不是 SDWebImage，这会对性能有轻微的影响
     *
     * This option helps deal with images changing behind the same request URL, e.g. Facebook graph api profile pics.
     * 此选项有助于处理同一个请求 URL 的图像发生变化
     *
     * If a cached image is refreshed, the completion block is called once with the cached image and again with the final image.
     * 如果缓存的图像被刷新，会调用一次 completion block，并传递最终的图像
     *
     * Use this flag only if you can't make your URLs static with embeded cache busting parameter.
     * 仅在无法使用嵌入式缓存清理参数确定图像 URL 时，使用此标记
     */
    SDWebImageRefreshCached = 1 << 4,
    
    /**
     * In iOS 4+, continue the download of the image if the app goes to background. This is achieved by asking the system for
     * 在 iOS 4+，当 App 进入后台后仍然会继续下载图像。这是向系统请求额外的后台时间以保证下载请求完成的
     *
     * extra time in background to let the request finish. If the background task expires the operation will be cancelled.
     * 如果后台任务过期，请求将会被取消
     */
    SDWebImageContinueInBackground = 1 << 5,
    
    /**
     * Handles cookies stored in NSHTTPCookieStore by setting
     * 通过设置
     * NSMutableURLRequest.HTTPShouldHandleCookies = YES;
     * 处理保存在 NSHTTPCookieStore 中的 cookies
     */
    SDWebImageHandleCookies = 1 << 6,
    
    /**
     * Enable to allow untrusted SSL ceriticates.
     * 允许不信任的 SSL 证书
     *
     * Useful for testing purposes. Use with caution in production.
     * 可以出于测试目的使用，在正式产品中慎用
     */
    SDWebImageAllowInvalidSSLCertificates = 1 << 7,
    
    /**
     * By default, image are loaded in the order they were queued. This flag move them to
     * 默认情况下，图像会按照在队列中的顺序被加载，此标记会将它们移动到队列前部立即被加载
     *
     * the front of the queue and is loaded immediately instead of waiting for the current queue to be loaded (which
     * 而不是等待当前队列被加载，等待队列加载会需要一段时间
     * could take a while).
     */
    SDWebImageHighPriority = 1 << 8,
    
    /**
     * By default, placeholder images are loaded while the image is loading. This flag will delay the loading
     * 默认情况下，在加载图像时，占位图像已经会被加载。而此标记会延迟加载占位图像，直到图像已经完成加载
     *
     * of the placeholder image until after the image has finished loading.
     */
    SDWebImageDelayPlaceholder = 1 << 9,
    
    /**
     * We usually don't call transformDownloadedImage delegate method on animated images,
     * 通常不会在可动画的图像上调用 transformDownloadedImage 代理方法，因为大多数转换代码会破坏动画文件
     *
     * as most transformation code would mangle it.
     * Use this flag to transform them anyway.
     * 使用此标记尝试转换
     */
    SDWebImageTransformAnimatedImage = 1 << 10,
};
