//
//  FoldedModel.m
//  HybridPageKit
//
//  Created by dequanzhu.
//  Copyright © 2018 HybridPageKit. All rights reserved.
//

#import "FoldedModel.h"

@interface FoldedModel ()
@property(nonatomic,copy,readwrite)NSString *index;
@property(nonatomic,assign,readwrite)CGRect frame;
@property(nonatomic,copy,readwrite)NSString *text;
@end

@implementation FoldedModel
- (instancetype)initWithDic:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        _index = [dic objectForKey:@"index"];
        _text = [dic objectForKey:@"foldedText"];
        _frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, kFoldedViewFoldedHeight);
    }
    return self;
}

#pragma mark - 

-(NSString *)getUniqueId{
    return _index;
}
-(CGRect)getComponentFrame{
    return _frame;
}
-(void)setComponentFrame:(CGRect)frame{
    _frame = frame;
}
-(Class)getComponentViewClass{
    return [FoldedView class];
}
-(Class)getComponentControllerClass{
    return [FoldedController class];
}
-(__kindof RNSComponentContext *)getCustomContext{
    return nil;
}
-(void)setComponentOriginY:(CGFloat)originY{
    _frame = CGRectMake(_frame.origin.x, originY, _frame.size.width, _frame.size.height);
}
-(void)setComponentOriginX:(CGFloat)originX{
    _frame = CGRectMake(originX, _frame.origin.y, _frame.size.width, _frame.size.height);
}
-(void)setComponentHeight:(CGFloat)height{
    _frame = CGRectMake(_frame.origin.x, _frame.origin.y, _frame.size.width, height);
}
@end
