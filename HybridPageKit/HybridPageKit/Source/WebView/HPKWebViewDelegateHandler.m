//
//  HPKWebViewDelegateHandler.m
//  HybridPageKit
//
//  Created by dequanzhu on 10/04/2018.
//  Copyright © 2018 HybridPageKit. All rights reserved.
//

#import "HPKWebViewDelegateHandler.h"
#import "HPKViewController.h"

@interface HPKWebViewDelegateHandler()
@property(nonatomic,weak,readwrite)__kindof HPKViewController *controller;
@end

@implementation HPKWebViewDelegateHandler

- (instancetype)initWithController:(__kindof HPKViewController *)controller{
    self = [super init];
    if (self) {
        _controller = controller;
    }
    return self;
}

#pragma mark -
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation{
    
    [self.controller triggerEvent:kHPKComponentEventWebViewDidFinishNavigation para1:webView];
    __weak typeof(self) wself = self;
    [webView scrollToOffset:100
                maxRunloops:20
            completionBlock:^(BOOL success, NSInteger loopTimes) {
                [wself.controller triggerEvent:kHPKComponentEventWebViewDidShow para1:webView];
                [wself.controller reLayoutInWebViewComponents];
            }];
}
@end
