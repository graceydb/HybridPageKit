//
//  RNSComponentItem.h
//  ReusableNestingScrollview
//
//  Created by dequanzhu.
//  Copyright © 2018 HybridPageKit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "RNSComponentContext.h"

typedef NS_ENUM(NSInteger,RNSComponentItemState) {
    kRNSComponentItemStateNone,        //准备区之外
    kRNSComponentItemStatePrepare,     //在准备区域
    kRNSComponentItemStateVisible,     //在可视区域
};

typedef __kindof RNSComponentContext * (^RNSComponentItemBuilder)(void);

@interface RNSComponentItem : NSObject

@property(nonatomic, copy, readonly) NSString *uniqueId;
@property(nonatomic, assign, readonly) CGRect componentFrame;
@property(nonatomic, assign, readonly) Class componentViewClass;
@property(nonatomic, strong, readonly) __kindof RNSComponentContext *customContext;

@property(nonatomic, assign, readwrite) RNSComponentItemState oldState;        //页面滚动复用标志位
@property(nonatomic, assign, readwrite) RNSComponentItemState newState;        //页面滚动复用标志位

- (instancetype)initWithUniqueId:(NSString *)uniqueId
                  componentFrame:(CGRect)componentFrame
              componentViewClass:(Class)componentViewClass
                  contextBuilder:(RNSComponentItemBuilder)contextBuilder;

@end
