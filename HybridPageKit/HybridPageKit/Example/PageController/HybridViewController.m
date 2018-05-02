//
//  HybridViewController.m
//  HybridPageKit
//
//  Created by dequanzhu.
//  Copyright © 2018 HybridPageKit. All rights reserved.
//

#import "HybridViewController.h"
#import "ArticleApi.h"
#import "ArticleModel.h"
#import "HtmlRenderHandler.h"
#import "HotCommentController.h"
#import "AdController.h"
#import "VideoController.h"
#import "GifController.h"
#import "ImageController.h"
#import "TitleController.h"
#import "RelateNewsController.h"
#import "MediaController.h"

@interface HybridViewController()<WKNavigationDelegate>
@property(nonatomic,strong,readwrite)ArticleApi *api;
@property(nonatomic,strong,readwrite)ArticleModel *articleModel;
@property(nonatomic,strong,readwrite)HotCommentController *commentController;
@end

@implementation HybridViewController
-(instancetype)initWithShortContent:(BOOL)shortContent{
    self = [super initWithWebView:YES];
    if (self) {
        [self _getRemoteDataWithShortContent:shortContent];
    }
    return self;
}

- (void)dealloc{
    if (_api) {
        [_api cancel];
        _api = nil;
    }
}

#pragma mark -

- (NSArray<NSObject<HPKComponentControllerDelegate> *> *)getValidComponentControllers{
    
    if (!_commentController) {
        _commentController = [[HotCommentController alloc]init];
    }
    
    return @[
             [[AdController alloc]init],
             [[VideoController alloc]init],
             [[GifController alloc]init],
             [[ImageController alloc]init],
             [[RelateNewsController alloc]init],
             _commentController,
             [[MediaController alloc]init],
             [[TitleController alloc]init]
             ];
}

- (void)_getRemoteDataWithShortContent:(BOOL)shortContent{
    __weak typeof(self) wself = self;
    _api = [[ArticleApi alloc]initWithApiType: shortContent ? kArticleApiTypeShortArticle : kArticleApiTypeArticle completionBlock:^(NSDictionary *responseDic, NSError *error) {
        wself.articleModel = [[ArticleModel alloc] initWithDic:responseDic];
        [wself _renderAndLoadData];
    }];
}

- (void)_renderAndLoadData{
    __weak typeof(self) wself = self;
    [[HtmlRenderHandler shareInstance]
     asyncRenderHTMLString:self.articleModel.contentTemplateString
            componentArray:self.articleModel.webViewComponents
                completeBlock:^(NSString *finalHTMLString, NSError *error) {
                   [wself setArticleDetailModel:wself.articleModel
                                   htmlTemplate:finalHTMLString
                        webviewExternalDelegate:wself
                              webViewComponents:wself.articleModel.webViewComponents
                            extensionComponents:wself.articleModel.extensionComponents];
               }];
}

#pragma mark -

- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation{
    NSLog(@"HybridViewController external navigateion delegate");
}
@end
