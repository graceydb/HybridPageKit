//
//  TitleController.m
//  HybridPageKit
//
//  Created by dequanzhu.
//  Copyright © 2018 HybridPageKit. All rights reserved.
//

#import "TitleController.h"

@implementation TitleController
-(BOOL)shouldResponseWithComponentView:(__kindof UIView *)componentView
                         componentModel:(RNSModel *)componentModel{
    return [componentView class] == [TitleView class] && [componentModel class] == [TitleModel class];
}
- (void)scrollViewWillPrepareComponentView:(__kindof UIView *)componentView
                            componentModel:(RNSModel *)componentModel{
    [((TitleView *)componentView) layoutWithData:(TitleModel *)componentModel];
}

@end
