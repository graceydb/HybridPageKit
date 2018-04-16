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
@end

@implementation HybridViewController
-(instancetype)initWithShortContent:(BOOL)shortContent{
    self = [super initWithComponentControllerArray:@[[[AdController alloc]init],
                                                     [[VideoController alloc]init],
                                                     [[GifController alloc]init],
                                                     [[ImageController alloc]init],
                                                     [[RelateNewsController alloc]init],
                                                     [[HotCommentController alloc]init],
                                                     [[MediaController alloc]init],
                                                     [[TitleController alloc]init]
                                                     ] needWebView:YES];
    if (self) {
        [self getRemoteDataWithShortContent:shortContent];
        __weak typeof(self) wself = self;
        [self setBottomPullRefreshBlock:^{
            [wself.commentController pullToRefresh];
        }];
    }
    return self;
}

- (void)dealloc{
    if (_api) {
        [_api cancel];
        _api = nil;
    }
}


-(id<WKNavigationDelegate>)getWebViewExternalNavigationDelegate{
    return self;
}



-(void)getRemoteDataWithShortContent:(BOOL)shortContent{
    __weak typeof(self) wself = self;
    _api = [[ArticleApi alloc]initWithApiType: shortContent ? kArticleApiTypeShortArticle : kArticleApiTypeArticle completionBlock:^(NSDictionary *responseDic, NSError *error) {
        
        wself.articleModel = [[ArticleModel alloc] initWithDic:responseDic];

        [wself setArticleDetailModel:wself.articleModel
                        htmlTemplate:_articleModel.contentTemplateString
                   webViewComponents:wself.articleModel.webViewComponents
                 extensionComponents:wself.articleModel.extensionComponents];
    }];
}

#pragma mark -
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation{
    NSLog(@"HybridViewController external navigateion delegate");
}
@end
