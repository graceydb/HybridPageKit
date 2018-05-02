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
#import "HotCommentModel.h"
#import "MediaController.h"
#import "FoldedController.h"
#import "HotCommentController.h"

@interface FoldedViewController()
@property(nonatomic,strong,readwrite)ArticleApi *api;
@property(nonatomic,strong,readwrite)ArticleModel *articleModel;
@property(nonatomic,strong,readwrite)HotCommentController *commentController;
@end

@implementation FoldedViewController
-(instancetype)init{
    self = [super initWithWebView:NO];
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

#pragma mark -

- (NSArray<NSObject<HPKComponentControllerDelegate> *> *)getValidComponentControllers{
    
    if (!_commentController) {
        _commentController = [[HotCommentController alloc]init];
    }
    
    return @[
             [[FoldedController alloc]init],
             _commentController,
             [[MediaController alloc]init]
             ];
}

-(void)_getRemoteData{
    __weak typeof(self) wself = self;
    _api = [[ArticleApi alloc]initWithApiType:kArticleApiTypeArticle completionBlock:^(NSDictionary *responseDic, NSError *error) {
        
        wself.articleModel = [[ArticleModel alloc]initWithDic:responseDic];
        
        [wself setArticleDetailModel:wself.articleModel
                      topInsetOffset:0.f
                 extensionComponents:wself.articleModel.extensionComponents];
        
        [wself reLayoutExtensionComponents];
    }];
}
@end
