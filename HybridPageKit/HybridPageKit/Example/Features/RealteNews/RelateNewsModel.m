//
//  RelateNewsModel.m
//  HybridPageKit
//
//  Created by dequanzhu.
//  Copyright © 2018 HybridPageKit. All rights reserved.
//

#import "RelateNewsModel.h"
#import "RelateNewsView.h"

@interface RelateNewsModel()
@property(nonatomic,copy,readwrite) NSArray * relateNewsArray;
@property(nonatomic,assign,readwrite)CGRect frame;
@property(nonatomic,copy,readwrite)NSString *index;
@end
@implementation RelateNewsModel
- (instancetype)initWithDic:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        _index = [dic objectForKey:@"index"];
        _relateNewsArray = [dic objectForKey:@"newsArray"];
        _frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, _relateNewsArray.count * kRelateNewsViewCellHeight);
    }
    return self;
}

#pragma mark - RNSModelProtocol

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
    return [RelateNewsView class];
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
@end
