//
//  AdModel.m
//  HybridPageKit
//
//  Created by dequanzhu.
//  Copyright © 2018 HybridPageKit. All rights reserved.
//

#import "AdModel.h"
#import "AdView.h"

@interface AdModel ()
@property(nonatomic,copy,readwrite)NSString *index;
@property(nonatomic,copy,readwrite)NSString *imageUrl;
@property(nonatomic,copy,readwrite)NSString *title;
@property(nonatomic,copy,readwrite)NSString *desc;
@property(nonatomic,assign,readwrite)CGRect frame;
@end

@implementation AdModel
- (instancetype)initWithIndex:(NSString *)index valueDic:(NSDictionary *)valueDic{
    self = [super init];
    if (self) {
        _index = index;
    }
    return self;
}

- (void)setDataWithDic:(NSDictionary *)dic{
    _title = [dic objectForKey:@"title"];
    _imageUrl = [dic objectForKey:@"image"];
    _desc = [dic objectForKey:@"subTitle"];
    _frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [AdView getAdViewHeightWithModel:self]);
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
    return [AdView class];
}
-(Class)getComponentControllerClass{
    return [AdController class];
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
