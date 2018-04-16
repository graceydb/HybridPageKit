//
//  HPKContainerScrollView.m
//  HybridPageKit
//
//  Created by dequanzhu.
//  Copyright © 2018 HybridPageKit. All rights reserved.
//

#import "HPKContainerScrollView.h"

@interface HPKContainerScrollView ()
@property(nonatomic,copy,readwrite)HPKContainerScrollViewChangeBlock layoutBlock;
@end

@implementation HPKContainerScrollView

- (instancetype)initWithFrame:(CGRect)frame
                  layoutBlock:(HPKContainerScrollViewChangeBlock)layoutBlock{
    self = [super initWithFrame:frame];
    if (self) {
        _layoutBlock = [layoutBlock copy];
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
