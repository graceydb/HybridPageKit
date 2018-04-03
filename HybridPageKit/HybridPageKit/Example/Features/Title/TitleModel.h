//
//  TitleModel.h
//  HybridPageKit
//
//  Created by dequanzhu.
//  Copyright © 2018 HybridPageKit. All rights reserved.
//
#import "RNSModelProtocol.h"

@interface TitleModel : NSObject <RNSModelProtocol>
@property(nonatomic,copy,readonly)NSString *title;

- (instancetype)initWithDic:(NSDictionary *)dic;
@end
