//
//  UIView + HPKLayout.m
//  HybridPageKit
//
//  Created by dequanzhu.
//  Copyright © 2018年 HybridPageKit. All rights reserved.
//

#import "UIView + HPKLayout.h"

@implementation UIView (HPKLayout)
- (CGFloat)hpk_width{
    return self.frame.size.width;
}
- (void)setHpk_width:(CGFloat)hpk_width{
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, hpk_width, self.frame.size.height);
}
- (CGFloat)hpk_height{
    return self.frame.size.height;
}
- (void)setHpk_height:(CGFloat)hpk_height{
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, hpk_height);
}
- (CGFloat)hpk_top{
    return self.frame.origin.y;
}
- (void)setHpk_top:(CGFloat)hpk_top{
    self.frame = CGRectMake(self.frame.origin.x, hpk_top, self.frame.size.width, self.frame.size.height);
}
- (CGFloat)hpk_left{
    return self.frame.origin.x;
}
- (void)setHpk_left:(CGFloat)hpk_left{
    self.frame = CGRectMake(hpk_left, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
}
@end

@implementation UIScrollView (HPKLayout)
- (CGFloat)hpk_contentSizeWidth{
    return self.contentSize.width;
}
- (void)setHpk_contentSizeWidth:(CGFloat)hpk_contentSizeWidth{
    self.contentSize = CGSizeMake(hpk_contentSizeWidth,self.contentSize.height);
}
- (CGFloat)hpk_contentSizeHeight{
    return self.contentSize.height;
}
- (void)setHpk_contentSizeHeight:(CGFloat)hpk_contentSizeHeight{
    self.contentSize = CGSizeMake(self.contentSize.width,hpk_contentSizeHeight);
}
- (CGFloat)hpk_contentOffsetX{
    return self.contentOffset.x;
}
- (void)setHpk_contentOffsetX:(CGFloat)hpk_contentOffsetX{
    self.contentOffset = CGPointMake(hpk_contentOffsetX, self.contentOffset.y);
}
- (CGFloat)hpk_contentOffsetY{
    return self.contentOffset.y;
}
- (void)setHpk_contentOffsetY:(CGFloat)hpk_contentOffsetY{
    self.contentOffset = CGPointMake(self.contentOffset.x, hpk_contentOffsetY);
}
@end
