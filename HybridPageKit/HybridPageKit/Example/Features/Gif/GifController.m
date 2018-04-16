//
//  GifController.m
//  HybridPageKit
//
//  Created by dequanzhu.
//  Copyright © 2018 HybridPageKit. All rights reserved.
//

#import "GifController.h"

@implementation GifController


- (void)controllerInit:(__kindof HPKViewController *)controller{
    
}
- (void)controllerViewDidLoad:(__kindof HPKViewController *)controller{
    
}
- (void)controllerViewWillAppear:(__kindof HPKViewController *)controller{
    
}
- (void)controllerViewDidAppear:(__kindof HPKViewController *)controller{
    
}
- (void)controllerViewWillDisappear:(__kindof HPKViewController *)controller{
    
}
- (void)controllerViewDidDisappear:(__kindof HPKViewController *)controller{
    
}

//data
- (void)controller:(__kindof HPKViewController *)controller
    didReceiveData:(NSObject *)data{
    
}

//webview
- (void)webViewDidFinishNavigation:(__kindof HPKWebView *)webView{
    
}
- (void)webViewDidShow:(__kindof HPKWebView *)webView{
    
}
- (void)webViewScrollViewDidScroll:(__kindof HPKWebView *)webView{
    
}

//component scroll
-(BOOL)shouldResponseWithComponentView:(__kindof UIView *)componentView
                        componentModel:(RNSModel *)componentModel{
    return [componentView class] == [GifView class] && [componentModel class] == [GifModel class];
}

- (void)scrollViewWillDisplayComponentView:(__kindof UIView *)componentView
                            componentModel:(RNSModel *)componentModel{
    [((GifView *)componentView) startPlay];
}

- (void)scrollViewEndDisplayComponentView:(__kindof UIView *)componentView
                           componentModel:(RNSModel *)componentModel{
    [((GifView *)componentView) stopPlay];
}

- (void)scrollViewWillPrepareComponentView:(__kindof UIView *)componentView
                            componentModel:(RNSModel *)componentModel{
    [((GifView *)componentView) layoutWithData:(GifModel *)componentModel];
}

- (void)scrollViewEndPrepareComponentView:(__kindof UIView *)componentView
                           componentModel:(RNSModel *)componentModel{
}
@end
