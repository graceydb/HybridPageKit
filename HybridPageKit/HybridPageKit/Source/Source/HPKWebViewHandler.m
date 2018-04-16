//
//  HPKWebViewHandler.m
//  HybridPageKit
//
//  Created by dequanzhu.
//  Copyright © 2018 HybridPageKit. All rights reserved.
//

#import "HPKWebViewHandler.h"
#import "HPKViewController.h"

@interface HPKWebViewHandler()
@property(nonatomic,weak,readwrite)__kindof HPKViewController *controller;
@end

@implementation HPKWebViewHandler

- (instancetype)initWithController:(__kindof HPKViewController *)controller{
    self = [super init];
    if (self) {
        _controller = controller;
    }
    return self;
}

#pragma mark -
- (void)saveLastReadPosition{
    // save current webview scrollview offset 
}
- (CGFloat)getLastReadPosition{
    // get last webview scrollview offset by custom key
    return 0.f;
}

#pragma mark -
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation{
    
    [self.controller triggerEvent:kHPKComponentEventWebViewDidFinishNavigation para1:webView];
    __weak typeof(self) wself = self;
    [webView scrollToOffset:MAX(0.f, [self getLastReadPosition])
                maxRunloops:50
            completionBlock:^(BOOL success, NSInteger loopTimes) {
                [wself.controller triggerEvent:kHPKComponentEventWebViewDidShow para1:webView];
                [wself.controller reLayExtensionComponents];
            }];
}
@end
