//
//  HotCommentModel.h
//  HybridPageKit
//
//  Created by dequanzhu.
//  Copyright © 2018 HybridPageKit. All rights reserved.
//

typedef void (^HotCommentModelLoadCompletionBlock)(void);

@interface HotCommentModel : RNSModel
@property(nonatomic,copy,readonly)NSString *index;
@property(nonatomic,copy,readonly) NSArray * HotCommentArray;
@property(nonatomic,assign,readonly)BOOL hasMore;

- (instancetype)initWithDic:(NSDictionary *)dic;


-(void)loadMoreHotCommentsWithCompletionBlock:(HotCommentModelLoadCompletionBlock)completionBlock;

@end
