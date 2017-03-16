//
//  UIWebView+Https.h
//  LisztUIWebView+Https
//
//  Created by Liszt on 2017/1/19.
//  Copyright © 2017年 Liszt. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, TPHttpsLoadingState) {
    /*加载成功*/
    TPHttpsLoadSuccess,
    /*加载失败*/
    TPHttpsLoadFaild
};

@interface UIWebView (Https)<UIWebViewDelegate>
/*配置https*/
- (void)tp_configHttps:(NSString *)https;

/*正在加载中回调*/
@property (nonatomic, copy) void(^tp_httpsBeginLoadingBlock)(void);
/*加载完成*/
@property (nonatomic, copy) void(^tp_httpsLoadingFinishBlock)(TPHttpsLoadingState loadingState);
@end
