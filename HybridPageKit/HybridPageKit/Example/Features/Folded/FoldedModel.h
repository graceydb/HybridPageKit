//
//  FoldedModel.h
//  HybridPageKit
//
//  Created by dequanzhu.
//  Copyright © 2018 HybridPageKit. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FoldedModel : NSObject<RNSModelProtocol>

@property(nonatomic,copy,readonly)NSString *index;
@property(nonatomic,copy,readonly)NSString *text;

- (instancetype)initWithDic:(NSDictionary *)dic;
@end
