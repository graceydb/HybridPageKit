//
//  UIView + HPKLayout.h
//  HybridPageKit
//
//  Created by dequanzhu.
//  Copyright © 2018年 HybridPageKit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (HPKLayout)
@property(nonatomic,assign,readwrite) CGFloat hpk_width;
@property(nonatomic,assign,readwrite) CGFloat hpk_height;
@property(nonatomic,assign,readwrite) CGFloat hpk_top;
@property(nonatomic,assign,readwrite) CGFloat hpk_left;
@end

@interface UIScrollView (HPKLayout)
@property(nonatomic,assign,readwrite) CGFloat hpk_contentSizeWidth;
@property(nonatomic,assign,readwrite) CGFloat hpk_contentSizeHeight;
@property(nonatomic,assign,readwrite) CGFloat hpk_contentOffsetX;
@property(nonatomic,assign,readwrite) CGFloat hpk_contentOffsetY;
@end
