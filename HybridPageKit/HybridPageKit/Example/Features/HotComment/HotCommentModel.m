//
//  HotCommentModel.m
//  HybridPageKit
//
//  Created by dequanzhu.
//  Copyright © 2018 HybridPageKit. All rights reserved.
//

#import "HotCommentModel.h"
#import "HotCommentView.h"

@interface HotCommentModel()
@property(nonatomic,copy,readwrite)NSString *index;
@property(nonatomic,copy,readwrite) NSArray * HotCommentArray;
@property(nonatomic,assign,readwrite)CGRect frame;

@end
@implementation HotCommentModel
- (instancetype)initWithDic:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        _index = [dic objectForKey:@"index"];
        _HotCommentArray = [dic objectForKey:@"commentArray"];
        _frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, _HotCommentArray.count * kHotCommentViewCellHeight);
    }
    return self;
}
-(void)setHotComments:(NSArray *)hotComments{
    _HotCommentArray = hotComments;
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
    return [HotCommentView class];
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
