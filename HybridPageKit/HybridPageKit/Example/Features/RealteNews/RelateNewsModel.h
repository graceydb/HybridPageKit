//
//  RelateNewsModel.h
//  HybridPageKit
//
//  Created by dequanzhu.
//  Copyright © 2018 HybridPageKit. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RelateNewsModel : NSObject<RNSModelProtocol>
@property(nonatomic,copy,readonly)NSString *index;
@property(nonatomic,copy,readonly) NSArray * relateNewsArray;

- (instancetype)initWithDic:(NSDictionary *)dic;

@end
