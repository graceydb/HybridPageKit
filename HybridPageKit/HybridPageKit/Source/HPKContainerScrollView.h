//
//  HPKContainerScrollView.h
//  HybridPageKit
//
//  Created by dequanzhu.
//  Copyright © 2018 HybridPageKit. All rights reserved.
//

typedef void (^HPKContainerScrollViewChangeBlock)(void);
typedef void (^HPKContainerScrollViewPullBlock) (void);

@interface HPKContainerScrollView : UIScrollView

- (instancetype)initWithFrame:(CGRect)frame
                  layoutBlock:(HPKContainerScrollViewChangeBlock)layoutBlock
                    pullBlock:(HPKContainerScrollViewPullBlock)pullBlock;
@end
