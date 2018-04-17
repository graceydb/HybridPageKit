//
//  GifController.m
//  HybridPageKit
//
//  Created by dequanzhu.
//  Copyright © 2018 HybridPageKit. All rights reserved.
//

#import "GifController.h"

@implementation GifController

- (BOOL)shouldResponseWithComponentView:(__kindof UIView *)componentView
                        componentModel:(RNSModel *)componentModel{
    return [componentView class] == [GifView class] && [componentModel class] == [GifModel class];
}

- (void)scrollViewWillDisplayComponentView:(__kindof UIView *)componentView
                            componentModel:(RNSModel *)componentModel{
    [((GifView *)componentView) startPlay];
}

- (void)scrollViewEndDisplayComponentView:(__kindof UIView *)componentView
                           componentModel:(RNSModel *)componentModel{
    [((GifView *)componentView) stopPlay];
}

- (void)scrollViewWillPrepareComponentView:(__kindof UIView *)componentView
                            componentModel:(RNSModel *)componentModel{
    [((GifView *)componentView) layoutWithData:(GifModel *)componentModel];
}

@end
