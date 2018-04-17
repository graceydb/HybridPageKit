//
//  AdController.m
//  HybridPageKit
//
//  Created by dequanzhu.
//  Copyright © 2018 HybridPageKit. All rights reserved.
//

#import "AdController.h"
#import "HPKViewController.h"
#import "ArticleModel.h"
#import "HPKWebViewHandler.h"

@interface AdController()
@property(nonatomic,weak,readwrite) __kindof HPKViewController *controller;
@property(nonatomic,weak,readwrite) __kindof HPKWebView *webView;
@property(nonatomic,weak,readwrite)AdModel *adModel;
@end

@implementation AdController
-(BOOL)shouldResponseWithComponentView:(__kindof UIView *)componentView
                         componentModel:(RNSModel *)componentModel{
    return [componentView class] == [AdView class] && [componentModel class] == [AdModel class];
}

- (void)controllerInit:(__kindof HPKViewController *)controller{
    _controller = controller;
}

//data
- (void)controller:(__kindof HPKViewController *)controller
    didReceiveData:(NSObject *)data{
    
    if([data isKindOfClass:[ArticleModel class]]){
        for (NSObject *component in ((ArticleModel *)data).webViewComponents) {
            if ([component isKindOfClass:[AdModel class]]) {
                self.adModel = (AdModel *)component;
                break;
            }
        }
    }  
}

//webview
- (void)webViewDidFinishNavigation:(__kindof HPKWebView *)webView{
    _webView = webView;
}

//component scroll
- (void)scrollViewWillDisplayComponentView:(__kindof UIView *)componentView
                            componentModel:(RNSModel *)componentModel{
    [((AdView *)componentView) layoutWithData:(AdModel *)componentModel];
}

- (void)scrollViewRelayoutComponentView:(__kindof UIView *)componentView
                         componentModel:(RNSModel *)componentModel{
    [((AdView *)componentView) layoutWithData:(AdModel *)componentModel];
}

- (void)scrollViewWillPrepareComponentView:(__kindof UIView *)componentView
                            componentModel:(RNSModel *)componentModel{
    
    __weak typeof(self) wself = self;
    [self.adModel getAsyncDataWithCompletionBlock:^{
        //异步获取数据后更新布局
        [wself.controller reLayoutWebViewComponentsWithIndex:wself.adModel.index componentSize:wself.adModel.frame.size];
    }];
}

@end
