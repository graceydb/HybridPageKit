//
//  HPKWebViewHandler.m
//  HybridPageKit
//
//  Created by dequanzhu.
//  Copyright © 2018 HybridPageKit. All rights reserved.
//

#import "HPKWebViewHandler.h"
#import "HPKViewController.h"
#import "WKWebViewExtensionsDef.h"

#define HPKWebViewHandlerComponentClass @"HPK-Component-PlaceHolder"

@interface HPKWebViewHandler()
@property(nonatomic,weak,readwrite)__kindof HPKViewController *controller;
@property(nonatomic,assign,readwrite)CGSize lastWebViewContentSize;

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

+ (NSString *)getComponentFrameJs{
    return [NSString stringWithFormat:@"function HPKGetAllComponentFrame(){var componentFrameDic=[];var list= document.getElementsByClassName('%@');for(var i=0;i<list.length;i++){var dom = list[i];componentFrameDic.push({'index':dom.getAttribute('data-index'),'top':dom.offsetTop,'left':dom.offsetLeft,'width':dom.clientWidth,'height':dom.clientHeight});}return componentFrameDic;}",HPKWebViewHandlerComponentClass];
}
+ (NSString *)componentHtmlTemplate{
    return [NSString stringWithFormat:@"<div class='%@' style='width:{{width}}px;height:{{height}}px' data-index='{{componentIndex}}'></div>",HPKWebViewHandlerComponentClass];
}
+ (NSString *)setComponentJSWithIndex:(NSString *)index
                        componentSize:(CGSize)componentSize{
    if (!index) {
        return nil;
    }
    
    return [NSString stringWithFormat:@"var dom=$(\".HPK-Component-PlaceHolder[data-index='%@']\");dom.width('%@px');dom.height('%@px');",index,@(componentSize.width),@(componentSize.height)];
}

#pragma mark -
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    
    CGSize newSize = [((NSValue *)[change objectForKey:NSKeyValueChangeNewKey]) CGSizeValue];
        
    if(!CGSizeEqualToSize(newSize,_lastWebViewContentSize)){
        _lastWebViewContentSize = newSize;
        [self.controller reLayoutWebViewComponents];
    }
}

#pragma mark -
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation{
    
    [self.controller triggerEvent:kHPKComponentEventWebViewDidFinishNavigation para1:webView];
    __weak typeof(self) wself = self;
    [webView scrollToOffset:MAX(0.f, [self getLastReadPosition])
                maxRunloops:50
            completionBlock:^(BOOL success, NSInteger loopTimes) {
                [wself.controller triggerEvent:kHPKComponentEventWebViewDidShow para1:webView];
                [wself.controller reLayoutWebViewComponents];
            }];
}
@end
