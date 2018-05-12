//
//  HotCommentView.m
//  HybridPageKit
//
//  Created by dequanzhu.
//  Copyright © 2018年 HybridPageKit. All rights reserved.
//

#import "HotCommentView.h"
#import "MJRefresh.h"

@interface HotCommentView()
@property(nonatomic,copy,readwrite)NSArray *hotCommentData;
@property(nonatomic,copy,readwrite)HotCommentViewPullBlock pullBlock;
@end

@implementation HotCommentView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.scrollEnabled = NO;
        if (@available(iOS 11.0, *)){
            self.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        self.estimatedRowHeight = 0;
        self.estimatedSectionHeaderHeight = 0;
        self.estimatedSectionFooterHeight = 0;
        __weak typeof(self) wself = self;
        self.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            if (wself.pullBlock) {
                wself.pullBlock();
            }
        }];
    }
    return self;
}

-(void)dealloc{
    _pullBlock = nil;
}

- (void)layoutWithData:(HotCommentModel *)hotCommentModel
          setPullBlock:(HotCommentViewPullBlock)pullBlock{
    
    if (hotCommentModel == nil || hotCommentModel.hotCommentArray == nil) {
        return;
    }
    _pullBlock = [pullBlock copy];
    _hotCommentData = [hotCommentModel.hotCommentArray copy];
    [self reloadData];
}

- (void)stopRefreshLoadingWithMoreData:(BOOL)hasMore{
    self.mj_footer.state = hasMore ? MJRefreshStateIdle : MJRefreshStateNoMoreData;
}

@end
