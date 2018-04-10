//
//  VideoModel.m
//  HybridPageKit
//
//  Created by dequanzhu.
//  Copyright © 2018 HybridPageKit. All rights reserved.
//

#import "VideoModel.h"
#import "VideoView.h"

@interface VideoModel()
@property(nonatomic,copy,readwrite)NSString *index;
@property(nonatomic,copy,readwrite)NSString *imageUrl;
@property(nonatomic,copy,readwrite)NSString *desc;
@property(nonatomic,assign,readwrite)CGRect frame;
@end

@implementation VideoModel
- (instancetype)initWithIndex:(NSString *)index valueDic:(NSDictionary *)valueDic{
    self = [super init];
    if (self) {
        _index = index;
        _imageUrl = [valueDic objectForKey:@"url"];
        _desc = [valueDic objectForKey:@"desc"];
        _frame = CGRectMake(0, 0, ((NSString *)[valueDic objectForKey:@"width"]).floatValue, ((NSString *)[valueDic objectForKey:@"height"]).floatValue);
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
    return [VideoView class];
}
-(Class)getComponentControllerClass{
    return [VideoController class];
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
