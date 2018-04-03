//
//  HPKContainerScrollView.m
//  HybridPageKit
//
//  Created by dequanzhu.
//  Copyright © 2018 HybridPageKit. All rights reserved.
//

#import "HPKContainerScrollView.h"
#import "MJRefresh.h"

@interface HPKContainerScrollView ()
@property(nonatomic,copy,readwrite)HPKContainerScrollViewChangeBlock layoutBlock;
@property(nonatomic,copy,readwrite)HPKContainerScrollViewPullBlock pullBlock;
@end

@implementation HPKContainerScrollView

- (instancetype)initWithFrame:(CGRect)frame
                  layoutBlock:(HPKContainerScrollViewChangeBlock)layoutBlock
                    pullBlock:(HPKContainerScrollViewPullBlock)pullBlock{
    self = [super initWithFrame:frame];
    if (self) {
        _layoutBlock = [layoutBlock copy];
        _pullBlock = [pullBlock copy];
        if (_pullBlock) {
            __weak typeof(self) wself = self;
            self.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                if (wself.pullBlock) {
                    wself.pullBlock();
                }
            }];
        }
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    if (_layoutBlock) {
        _layoutBlock();
    }
}

@end
