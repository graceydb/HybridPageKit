//
//  HotCommentView.h
//  HybridPageKit
//
//  Created by dequanzhu.
//  Copyright © 2018 HybridPageKit. All rights reserved.
//

#import "HotCommentModel.h"
#define kHotCommentViewCellHeight 100.f
@interface HotCommentView : UIView
-(void)layoutWithData:(HotCommentModel *)hotCommentModel;
@end
