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
#import "HtmlRenderHandler.h"

@interface SingleWebViewController()<WKNavigationDelegate>
@property(nonatomic,strong,readwrite)ArticleApi *api;
@property(nonatomic,strong,readwrite)ArticleModel *articleModel;
@end

@implementation SingleWebViewController

- (instancetype)init{
    self = [super initWithWebView:YES];
    if (self) {
        [self _getRemoteData];
    }
    return self;
}

- (void)dealloc{
    if (_api) {
        [_api cancel];
        _api = nil;
    }
}

- (NSArray<NSObject<HPKComponentControllerDelegate> *> *)getValidComponentControllers{
    return @[
             [[AdController alloc]init],
             [[VideoController alloc]init],
             [[GifController alloc]init],
             [[ImageController alloc]init],
             [[TitleController alloc]init]
             ];
}

-(void)_getRemoteData{
    __weak typeof(self) wself = self;
    _api = [[ArticleApi alloc]initWithApiType:kArticleApiTypeArticle completionBlock:^(NSDictionary *responseDic, NSError *error) {
        
        wself.articleModel = [[ArticleModel alloc]initWithDic:responseDic];
        
        [[HtmlRenderHandler shareInstance] asyncRenderHTMLString:wself.articleModel.contentTemplateString componentArray:wself.articleModel.webViewComponents completeBlock:^(NSString *finalHTMLString, NSError *error) {
            
            [wself setArticleDetailModel:wself.articleModel
                            htmlTemplate:finalHTMLString
                 webviewExternalDelegate:wself
                       webViewComponents:wself.articleModel.webViewComponents
                     extensionComponents:nil];
        }];
    }];
}

#pragma mark -
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation{
    NSLog(@"SingleWebViewController external navigateion delegate");
}
@end
