//
//  RelateNewsModel.h
//  HybridPageKit
//
//  Created by dequanzhu.
//  Copyright © 2018 HybridPageKit. All rights reserved.
//
#import "RNSHandler.h"

@interface RelateNewsModel : RNSModel
@property(nonatomic,copy,readonly)NSString *index;
@property(nonatomic,copy,readonly) NSArray * relateNewsArray;

- (instancetype)initWithDic:(NSDictionary *)dic;

@end
