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
#import "HPKHtmlRenderHandler.h"

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
        __weak typeof(self) wself = self;
        [self setBottomPullRefreshBlock:^{
            [wself.commentController pullToRefresh];
        }];
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

        [wself setArticleDetailModel:wself.articleModel
                        htmlTemplate:wself.articleModel.contentTemplateString
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
