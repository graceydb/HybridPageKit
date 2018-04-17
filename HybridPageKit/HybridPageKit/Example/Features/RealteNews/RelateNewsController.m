//
//  RelateNewsController.m
//  HybridPageKit
//
//  Created by dequanzhu.
//  Copyright © 2018 HybridPageKit. All rights reserved.
//

#import "RelateNewsController.h"

@implementation RelateNewsController

-(BOOL)shouldResponseWithComponentView:(__kindof UIView *)componentView
componentModel:(RNSModel *)componentModel{
   return [componentView class] == [RelateNewsView class] && [componentModel class] == [RelateNewsModel class];
}

- (void)scrollViewWillDisplayComponentView:(__kindof UIView *)componentView
                            componentModel:(RNSModel *)componentModel{
    [((RelateNewsView *)componentView) layoutWithData:(RelateNewsModel *)componentModel];
}

@end
