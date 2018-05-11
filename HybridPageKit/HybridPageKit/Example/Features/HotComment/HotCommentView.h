//
//  HotCommentView.h
//  HybridPageKit
//
//  Created by dequanzhu.
//  Copyright © 2018年 HybridPageKit. All rights reserved.
//

#import "HotCommentModel.h"
#define kHotCommentViewCellHeight 100.f
typedef void (^HotCommentViewPullBlock)(void);
@interface HotCommentView : UITableView
- (void)layoutWithData:(HotCommentModel *)hotCommentModel
          setPullBlock:(HotCommentViewPullBlock)pullBlock;
- (void)stopRefreshLoadingWithMoreData:(BOOL)hasMore;
@end
