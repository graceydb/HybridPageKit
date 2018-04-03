//
//  RNSModelProtocol.h
//  ReusableNestingScrollview
//
//  Created by dequanzhu.
//  Copyright © 2018 HybridPageKit. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "RNSComponentContext.h"

@protocol RNSModelProtocol
@required
-(NSString *)getUniqueId;
-(void)setComponentFrame:(CGRect)frame;
-(CGRect)getComponentFrame;
-(Class)getComponentViewClass;
-(__kindof RNSComponentContext *)getCustomContext;

@optional
-(void)setComponentOriginX:(CGFloat)originX;
-(void)setComponentOriginY:(CGFloat)originY;
-(void)setComponentWidth:(CGFloat)width;
-(void)setComponentHeight:(CGFloat)height;
@end
