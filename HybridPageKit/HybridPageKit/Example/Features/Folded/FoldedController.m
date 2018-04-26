//
//  FoldedController.m
//  HybridPageKit
//
//  Created by dequanzhu.
//  Copyright © 2018 HybridPageKit. All rights reserved.
//

#import "FoldedController.h"
#import "HPKViewController.h"
#import "FoldedView.h"
#import "FoldedModel.h"

@interface FoldedController()
@property(nonatomic,weak,readwrite) __kindof HPKViewController *controller;
@property(nonatomic,weak,readwrite)FoldedModel *foldedModel;
@end

@implementation FoldedController

-(BOOL)shouldResponseWithComponentView:(__kindof UIView *)componentView
                        componentModel:(RNSModel *)componentModel{
    return [componentView class] == [FoldedView class] && [componentModel class] == [FoldedModel class];
}

- (void)controllerInit:(__kindof HPKViewController *)controller{
    _controller = controller;
}

- (void)scrollViewWillPrepareComponentView:(__kindof UIView *)componentView
                            componentModel:(RNSModel *)componentModel{
    
    _foldedModel = (FoldedModel *)componentModel;
    
    __weak typeof(self) wself = self;
    [((FoldedView *)componentView) layoutWithData:_foldedModel clickBlock:^(CGFloat height) {
        [wself.foldedModel setComponentHeight:height];
        [wself.controller reLayoutExtensionComponents];
    }];
}

@end
