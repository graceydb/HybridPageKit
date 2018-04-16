//
//  FoldedViewController.m
//  HybridPageKit
//
//  Created by dequanzhu.
//  Copyright © 2018 HybridPageKit. All rights reserved.
//

#import "FoldedViewController.h"
#import "ArticleApi.h"
#import "ArticleModel.h"

@interface FoldedViewController()
@property(nonatomic,strong,readwrite)ArticleApi *api;
@property(nonatomic,strong,readwrite)ArticleModel *articleModel;
@property(nonatomic,strong,readwrite)HotCommentController *commentController;
@end

@implementation FoldedViewController
-(instancetype)init{
    self = [super initWithDefaultWebView:NO];
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
             [[FoldedController alloc]init],
             _commentController,
             [[MediaController alloc]init]
             ];
}

-(CGFloat)componentsGap{
    return 10.f;
}

-(void)getRemoteData{
    __weak typeof(self) wself = self;
    _api = [[ArticleApi alloc]initWithApiType:kArticleApiTypeArticle completionBlock:^(NSDictionary *responseDic, NSError *error) {
        
        wself.articleModel = [[ArticleModel alloc]initWithDic:responseDic];
        //component callback for data
        [wself setArticleDetailModel:wself.articleModel WebViewComponents:nil ExtensionComponents:wself.articleModel.ExtensionComponents];
        [wself reLayoutExtensionComponents];
    }];
}
@end
