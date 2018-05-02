//
//  HotCommentController.m
//  HybridPageKit
//
//  Created by dequanzhu.
//  Copyright © 2018 HybridPageKit. All rights reserved.
//

#import "HotCommentController.h"
#import "ArticleModel.h"
#import "HPKViewController.h"
#import "HotCommentModel.h"
#import "HotCommentView.h"

@interface HotCommentController ()
@property(nonatomic,weak,readwrite) __kindof HPKViewController *controller;
@property(nonatomic,weak,readwrite)HotCommentModel *hotCommentModel;
@property(nonatomic,weak,readwrite)HotCommentView *hotCommentView;

@end

@implementation HotCommentController

- (void)pullToRefresh{
    __weak typeof(self) wself = self;
    [self.hotCommentModel loadMoreHotCommentsWithCompletionBlock:^{
        [wself.controller reLayoutExtensionComponents];
    }];
}

#pragma mark -
-(BOOL)shouldResponseWithComponentView:(__kindof UIView *)componentView
                         componentModel:(RNSModel *)componentModel{
    return [componentView class] == [HotCommentView class] && [componentModel class] == [HotCommentModel class];
}

- (void)controllerInit:(__kindof HPKViewController *)controller{
    _controller = controller;
}

//data
- (void)controller:(__kindof HPKViewController *)controller
    didReceiveData:(NSObject *)data{
    if([data isKindOfClass:[ArticleModel class]]){
        for (NSObject *component in ((ArticleModel *)data).extensionComponents) {
            if ([component isKindOfClass:[HotCommentModel class]]) {
                self.hotCommentModel = (HotCommentModel *)component;
                break;
            }
        }
    }
}

- (void)webViewDidShow:(__kindof HPKWebView *)webView{
    // 如果是单独接口异步加载评论，在此执行
    // 防止接口和布局影响webview渲染，提高内容页展示速度
}

//component scroll
- (void)scrollViewWillDisplayComponentView:(__kindof UIView *)componentView
                            componentModel:(RNSModel *)componentModel{
    _hotCommentView = (HotCommentView *)componentView;
    [((HotCommentView *)componentView) layoutWithData:(HotCommentModel *)componentModel];
}

- (void)scrollViewRelayoutComponentView:(__kindof UIView *)componentView
                         componentModel:(RNSModel *)componentModel{
    [((HotCommentView *)componentView) layoutWithData:(HotCommentModel *)componentModel];
}

@end
