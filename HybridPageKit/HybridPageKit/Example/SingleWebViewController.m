//
//  SingleWebViewController.m
//  HybridPageKit
//
//  Created by dequanzhu.
//  Copyright © 2018 HybridPageKit. All rights reserved.
//

#import "SingleWebViewController.h"
#import "ArticleApi.h"
#import "ArticleModel.h"
#import "HPKHtmlRenderHandler.h"

@interface SingleWebViewController()<WKNavigationDelegate>
@property(nonatomic,strong,readwrite)ArticleApi *api;
@property(nonatomic,strong,readwrite)ArticleModel *articleModel;
@end

@implementation SingleWebViewController

- (instancetype)init{
    self = [super initWithDefaultWebView:YES];
    if (self) {
        [self getRemoteData];
    }
    return self;
}

- (void)dealloc{
    if (_api) {
        [_api cancel];
        _api = nil;
    }
}

- (NSArray *)getComponentControllerArray{
    return @[
             [[AdController alloc]init],
             [[VideoController alloc]init],
             [[GifController alloc]init],
             [[ImageController alloc]init],
             [[TitleController alloc]init]
             ];
}

-(id<WKNavigationDelegate>)getWebViewExternalNavigationDelegate{
    return self;
}

-(void)getRemoteData{
    __weak typeof(self) wself = self;
    _api = [[ArticleApi alloc]initWithApiType:kArticleApiTypeArticle completionBlock:^(NSDictionary *responseDic, NSError *error) {
        
        wself.articleModel = [[ArticleModel alloc]initWithDic:responseDic];
        
        //render html
        [wself renderHtmlTemplate:_articleModel.contentTemplateString componentArray:_articleModel.webViewComponents];
        
        //component callback for data
        [wself setArticleDetailModel:wself.articleModel webViewComponents:wself.articleModel.webViewComponents extensionComponents:nil];
    }];
}

#pragma mark -
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation{
    NSLog(@"SingleWebViewController external navigateion delegate");
}
@end
