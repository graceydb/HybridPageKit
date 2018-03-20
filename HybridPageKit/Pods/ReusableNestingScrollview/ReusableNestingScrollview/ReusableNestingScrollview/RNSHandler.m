//
//  RNSHandler.m
//  ReusableNestingScrollview
//
//  Created by dequanzhu.
//  Copyright © 2018 HybridPageKit. All rights reserved.
//

#import "RNSHandler.h"
#import "RNSDealgateDispatcher.h"
#import "RNSComponentHandler.h"

@interface RNSHandler ()
@property(nonatomic,readwrite,strong) RNSDealgateDispatcher *delegateDispatcher;
@property(nonatomic,readwrite,strong) RNSComponentHandler *handler;
@end

@implementation RNSHandler

- (instancetype)initWithScrollView:(__kindof UIScrollView *)scrollView
        externalScrollViewDelegate:(__weak NSObject <UIScrollViewDelegate>*)externalDelegate
                   scrollWorkRange:(CGFloat)scrollWorkRange
     componentViewStateChangeBlock:(RNSComponentViewStateChangeBlock)componentViewStateChangeBlock{
    self = [super init];
    if (self) {
        _handler = [[RNSComponentHandler alloc] initWithScrollView:scrollView       componentViewStateChangeBlock:componentViewStateChangeBlock];
        _handler.componentWorkRange = scrollWorkRange;
        
        _delegateDispatcher = [[RNSDealgateDispatcher alloc] initWithInternalDelegate:self.handler externalDelegate:externalDelegate];
        
        scrollView.delegate = self.delegateDispatcher;
    }
    return self;
}

-(void)dealloc{
    _delegateDispatcher = nil;
    _handler = nil;
}

- (void)reloadComponentViewsWithProcessBlock:(RNSComponentProcessItemBlock)processBlock{
    [_handler reloadComponentViewsWithProcessBlock:processBlock];
}

- (RNSComponentItem *)getComponentItemByUniqueId:(NSString *)uniqueId{
    return [_handler getComponentItemByUniqueId:uniqueId];
}
- (__kindof UIView *)getComponentViewByItem:(RNSComponentItem *)item{
    return [_handler getComponentViewByItem:item];
}
- (NSArray <RNSComponentItem *>*)getAllComponentItems{
    return [_handler getAllComponentItemsWithorderByOffset:YES];
}

@end
