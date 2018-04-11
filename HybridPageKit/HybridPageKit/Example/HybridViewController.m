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

//document.getElementById('body').style.fontSize = 'xx-large'
//document.getElementById('body').style.fontSize = 'medium'

@interface HybridViewController()<WKNavigationDelegate>
@property(nonatomic,strong,readwrite)ArticleApi *api;
@property(nonatomic,strong,readwrite)ArticleModel *articleModel;

@property(nonatomic,strong,readwrite)HotCommentController *commentController;
@end

@implementation HybridViewController
-(instancetype)init{
    self = [super initWithDefaultWebView:YES];
    if (self) {
        [self getRemoteData];
        __weak typeof(self) wself = self;
        [self setBottomPullRefreshBlock:^{
            [wself.commentController pullToRefresh];
        }];
    }
    return self;
}

- (NSArray *)getComponentControllerArray{
    
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

-(id<WKNavigationDelegate>)getWebViewExternalNavigationDelegate{
    return self;
}

-(CGFloat)componentsGap{
    return 10.f;
}



-(void)getRemoteData{
    __weak typeof(self) wself = self;
    _api = [[ArticleApi alloc]initWithApiType:kArticleApiTypeArticle completionBlock:^(NSDictionary *responseDic, NSError *error) {
        
        wself.articleModel = [[ArticleModel alloc]initWithDic:responseDic];
        
        //render html
        [wself renderHtmlTemplate:_articleModel.contentTemplateString componentArray:_articleModel.inWebViewComponents];
        
        //component callback for data
        [wself setArticleDetailModel:wself.articleModel inWebViewComponents:wself.articleModel.inWebViewComponents outWebViewComponents:wself.articleModel.outWebViewComponents];
    }];
}

#pragma mark -
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation{
    NSLog(@"HybridViewController external navigateion delegate");
}
@end
