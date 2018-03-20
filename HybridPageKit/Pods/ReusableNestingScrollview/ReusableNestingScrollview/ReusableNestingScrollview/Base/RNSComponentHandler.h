//
//  RNSComponentHandler.h
//  HybridPageKit
//
//  Created by dequanzhu.
//  Copyright © 2018 HybridPageKit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RNSComponentItem.h"
#import "RNSHandler.h"

@interface RNSComponentHandler : NSObject<UIScrollViewDelegate>

@property(nonatomic, assign, readwrite) CGFloat componentWorkRange;

- (instancetype)initWithScrollView:(__kindof UIScrollView *)scrollView
     componentViewStateChangeBlock:(RNSComponentViewStateChangeBlock)componentViewStateChangeBlock;

- (void)reloadComponentViewsWithProcessBlock:(RNSComponentProcessItemBlock)processBlock;

#pragma mark -

- (RNSComponentItem *)getComponentItemByUniqueId:(NSString *)uniqueId;
- (__kindof UIView *)getComponentViewByItem:(RNSComponentItem *)item;

- (NSArray <RNSComponentItem *>*)getAllComponentItemsWithorderByOffset:(BOOL)orderByOffset;
- (NSArray <RNSComponentItem *>*)getVisiableComponentItems;        //返回visible的ComponentItem
- (NSArray <RNSComponentItem *>*)getPreparedComponentItems;        //返回prepared的ComponentItem

@end
