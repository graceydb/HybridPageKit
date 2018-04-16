//
//  GifModel.m
//  HybridPageKit
//
//  Created by dequanzhu.
//  Copyright © 2018 HybridPageKit. All rights reserved.
//

#import "GifModel.h"
#import "GifView.h"

@interface GifModel()
@property(nonatomic,copy,readwrite)NSString *index;
@property(nonatomic,copy,readwrite)NSString *imageUrl;
@property(nonatomic,copy,readwrite)NSString *desc;
@property(nonatomic,assign,readwrite)CGRect frame;
@end

@implementation GifModel

RNSProtocolImp(_index,_frame,GifView,GifController,nil);

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

@end
