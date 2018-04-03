//
//  HotCommentModel.h
//  HybridPageKit
//
//  Created by dequanzhu.
//  Copyright © 2018 HybridPageKit. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HotCommentModel : NSObject<RNSModelProtocol>
@property(nonatomic,copy,readonly)NSString *index;
@property(nonatomic,copy,readonly) NSArray * HotCommentArray;

- (instancetype)initWithDic:(NSDictionary *)dic;

-(void)setHotComments:(NSArray *)hotComments;

@end
