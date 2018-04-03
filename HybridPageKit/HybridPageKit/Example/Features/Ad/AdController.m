//
//  AdController.m
//  HybridPageKit
//
//  Created by dequanzhu.
//  Copyright © 2018 HybridPageKit. All rights reserved.
//

#import "AdController.h"
#import "ArticleApi.h"
#import "HPKViewController.h"
#import "ArticleModel.h"

@interface AdController()
@property(nonatomic,weak,readwrite) __kindof HPKViewController *controller;
@property(nonatomic,weak,readwrite) __kindof HPKWebView *webView;
@property(nonatomic,strong,readwrite)ArticleApi *adApi;
@property(nonatomic,strong,readwrite)AdModel *adModel;
@end

@implementation AdController
-(BOOL)shouldResponseWithComponentView:(__kindof UIView *)componentView
                         componentModel:(NSObject<RNSModelProtocol> *)componentModel{
    return [componentView class] == [AdView class] && [componentModel class] == [AdModel class];
}

- (void)controllerInit:(__kindof HPKViewController *)controller{
    _controller = controller;
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
    
    if([data isKindOfClass:[ArticleModel class]]){
        for (NSObject *component in ((ArticleModel *)data).inWebViewComponents) {
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
- (void)webViewDidShow:(__kindof HPKWebView *)webView{
    __weak typeof(self) wself = self;
    _adApi = [[ArticleApi alloc]initWithApiType:kArticleApiTypeAD completionBlock:^(NSDictionary *responseDic, NSError *error) {
        [wself.adModel setDataWithDic:responseDic];
        
        NSString *jsStr =  [NSString stringWithFormat:@"var dom=document.getElementById('%@');dom.style.width='%@px';dom.style.width='%@px';",wself.adModel.index,@(wself.adModel.frame.size.width),@(wself.adModel.frame.size.height)];

        [wself.webView safeAsyncEvaluateJavaScriptString:jsStr completionBlock:^(NSObject *result) {
            [wself.controller reLayoutInWebViewComponents];
        }];
    }];
}
- (void)webViewScrollViewDidScroll:(__kindof HPKWebView *)webView{
    
}

//component scroll
- (void)scrollViewWillDisplayComponentView:(__kindof UIView *)componentView
                            componentModel:(NSObject<RNSModelProtocol> *)componentModel{
    [((AdView *)componentView) layoutWithData:(AdModel *)componentModel];
}

- (void)scrollViewEndDisplayComponentView:(__kindof UIView *)componentView
                           componentModel:(NSObject<RNSModelProtocol> *)componentModel{
    NSLog(@"");
}

- (void)scrollViewWillPrepareComponentView:(__kindof UIView *)componentView
                            componentModel:(NSObject<RNSModelProtocol> *)componentModel{
    NSLog(@"");
}

- (void)scrollViewEndPrepareComponentView:(__kindof UIView *)componentView
                           componentModel:(NSObject<RNSModelProtocol> *)componentModel{
    NSLog(@"");
}
@end
