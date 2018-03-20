//
//  RNSComponentHandler.m
//  HybridPageKit
//
//  Created by dequanzhu.
//  Copyright © 2018 HybridPageKit. All rights reserved.
//

#import "RNSComponentHandler.h"
#import "RNSComponentViewPool.h"
#import "UIView + RNSComponent.h"

@interface RNSComponentHandler()
@property(nonatomic, strong, readwrite) NSDictionary<NSString *, RNSComponentItem *> *componentItemDic;  //全部的componentItem Dic
@property(nonatomic, strong, readwrite) NSMutableDictionary<NSString *, __kindof UIView *> *dequeueViewsDic;    //prepare和visible的view
@property(nonatomic, strong, readwrite) NSMutableArray <__kindof UIView *>* scrollViewSubViews;
@property(nonatomic, assign, readwrite) RNSComponentViewStateChangeBlock changeBlock;
@property(nonatomic, weak, readwrite) __kindof UIScrollView * scrollView;
@end

@implementation RNSComponentHandler

- (instancetype)initWithScrollView:(__kindof __weak UIScrollView *)scrollView
     componentViewStateChangeBlock:(RNSComponentViewStateChangeBlock)componentViewStateChangeBlock{
    self = [super init];
    if (self) {
        _componentItemDic = @{};
        _dequeueViewsDic = @{}.mutableCopy;
        _scrollViewSubViews = @[].mutableCopy;
        _scrollView = scrollView;
        _changeBlock = componentViewStateChangeBlock;
    }
    return self;
}

-(void)dealloc{
    self.componentItemDic = nil;
    
    [self.dequeueViewsDic removeAllObjects];
    self.dequeueViewsDic = nil;
    
    for (__kindof UIView * subView in self.scrollViewSubViews) {
        [subView removeFromSuperview];
    }
    [self.scrollViewSubViews removeAllObjects];
    self.scrollViewSubViews = nil;
    
    self.changeBlock = nil;
    self.scrollView = nil;
    
}

#pragma mark - public method

- (void)reloadComponentViewsWithProcessBlock:(RNSComponentProcessItemBlock)processBlock{
    
    if ([NSThread isMainThread]) {
        if(processBlock){
            NSMutableDictionary * componentItemTmp = _componentItemDic.mutableCopy;
            processBlock(componentItemTmp);
            _componentItemDic = componentItemTmp.copy;
        }
        
        [self detailComponentsDidUpdateWithOffsetTop:self.scrollView.contentOffset.y];
    }else{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self reloadComponentViewsWithProcessBlock:processBlock];
        });
    }
}

#pragma mark - public method

- (RNSComponentItem *)getComponentItemByUniqueId:(NSString *)uniqueId{
    if (!uniqueId || uniqueId.length <= 0 || !self.componentItemDic || self.componentItemDic.count <= 0) {
        return nil;
    }
    return [self.componentItemDic objectForKey:uniqueId];
}

- (__kindof UIView *)getComponentViewByItem:(RNSComponentItem *)item{
    if(!item || !self.dequeueViewsDic || self.dequeueViewsDic.count <= 0){
        return nil;
    }
    return [self.dequeueViewsDic objectForKey:item.uniqueId];
}

- (NSArray <RNSComponentItem *> *)getVisiableComponentItems{
    if (!self.componentItemDic || self.componentItemDic.count <= 0) {
        return @[];
    }
    
   return  [self.componentItemDic.allValues objectsAtIndexes:
     [self.componentItemDic.allValues indexesOfObjectsPassingTest:^BOOL(id _Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
       if ([obj isKindOfClass:[RNSComponentItem class]]) {
           return ((RNSComponentItem *)obj).newState == kRNSComponentItemStateVisible;
       }
       return NO;
    }]];

}

- (NSArray <RNSComponentItem *> *)getPreparedComponentItems{
    if (!self.componentItemDic || self.componentItemDic.count <= 0) {
        return @[];
    }

    return  [self.componentItemDic.allValues objectsAtIndexes:
             [self.componentItemDic.allValues indexesOfObjectsPassingTest:^BOOL(id _Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        if ([obj isKindOfClass:[RNSComponentItem class]]) {
            return ((RNSComponentItem *)obj).newState == kRNSComponentItemStatePrepare;
        }
        return NO;
    }]];
}

- (NSArray <RNSComponentItem *>*)getAllComponentItemsWithorderByOffset:(BOOL)orderByOffset{
    
    if (!self.componentItemDic || self.componentItemDic.count <= 0) {
        return @[];
    }
    
    if(orderByOffset){
        return [self.componentItemDic.allValues sortedArrayUsingComparator:^NSComparisonResult(RNSComponentItem *item1,
                                                                                               RNSComponentItem *item2) {
            if (item1.componentFrame.origin.y  < item2.componentFrame.origin.y )
                return (NSComparisonResult)NSOrderedAscending;
            else
                return (NSComparisonResult)NSOrderedDescending;
        }];
    }else{
        return self.componentItemDic.allValues;
    }
}

#pragma mark -

- (void)detailComponentsDidUpdateWithOffsetTop:(CGFloat)offsetTop{
    
    
    if (!self.componentItemDic || self.componentItemDic.count <= 0) {
        return;
    }
    
    CGFloat visibleTopLine = offsetTop;
    CGFloat visibleBottomLine = offsetTop + self.scrollView.frame.size.height;
    
    CGFloat preparedTopLine = visibleTopLine - self.componentWorkRange;
    CGFloat preparedBottomLine = visibleBottomLine + self.componentWorkRange;
    
    //重新赋值新位置状态
    for (RNSComponentItem *item in self.componentItemDic.allValues) {
        //在prepare的区域
        if (item.componentFrame.origin.y + item.componentFrame.size.height > preparedTopLine && item.componentFrame.origin.y < preparedBottomLine) {
            //在visible的区域
            if (item.componentFrame.origin.y + item.componentFrame.size.height > visibleTopLine && item.componentFrame.origin.y < visibleBottomLine) {
                item.newState = kRNSComponentItemStateVisible;
            }else{
                item.newState = kRNSComponentItemStatePrepare;
            }
        }else{
            item.newState = kRNSComponentItemStateNone;
        }
    }
    
    //和旧位置状态对比
    for (RNSComponentItem *item in self.componentItemDic.allValues) {
        if(item.newState == item.oldState){
            //两次状态没有变化，无需处理
            continue;
        }
        
        if(item.newState == kRNSComponentItemStateVisible && item.oldState == kRNSComponentItemStatePrepare){
            
            //1.从prepare到visible
            [self _triggerComponentEvent:kRNSComponentViewWillDisplayComponentView withItem:item];
            
        }else if (item.newState == kRNSComponentItemStateVisible && item.oldState == kRNSComponentItemStateNone){
            
            //2.从none到visible，容错
            __kindof UIView *view = [self _dequeueViewOfItem:item];
            [_scrollView addSubview:view];
            [_scrollViewSubViews addObject:view];
            
            [self _triggerComponentEvent:kRNSComponentViewWillPreparedComponentView withItem:item];
            [self _triggerComponentEvent:kRNSComponentViewWillDisplayComponentView withItem:item];
            
            
        }else if (item.newState == kRNSComponentItemStatePrepare && item.oldState == kRNSComponentItemStateNone){
            
            //3.从none到prepare
            [self _dequeueViewOfItem:item];
            __kindof UIView *view = [self _triggerComponentEvent:kRNSComponentViewWillPreparedComponentView withItem:item];
            [_scrollView addSubview:view];
            [_scrollViewSubViews addObject:view];
            
        }else if (item.newState == kRNSComponentItemStatePrepare && item.oldState == kRNSComponentItemStateVisible){
            
            //4.从visible到prepare
            [self _triggerComponentEvent:kRNSComponentViewEndDisplayComponentView withItem:item];
            
        }else if (item.newState == kRNSComponentItemStateNone && item.oldState == kRNSComponentItemStatePrepare){
            
            //5.从prepare到none
            [self _triggerComponentEvent:kRNSComponentViewEndPreparedComponentView withItem:item];
            [self _enqueueViewOfItem:item];
            
        }else if (item.newState == kRNSComponentItemStateNone && item.oldState == kRNSComponentItemStateVisible){
            
            //6.从visible到none，容错
            [self _triggerComponentEvent:kRNSComponentViewEndDisplayComponentView withItem:item];
            [self _triggerComponentEvent:kRNSComponentViewEndPreparedComponentView withItem:item];
            [self _enqueueViewOfItem:item];
            
        }else{
            //never
        }
        
        //更新状态
        item.oldState = item.newState;
    }
}


#pragma mark - private method of

- (__kindof UIView *)_dequeueViewOfItem:(RNSComponentItem *)item{
    
    __kindof UIView *view =  [[RNSComponentViewPool shareInstance]
                              dequeueComponentViewWithIdentifier:item.uniqueId viewClass:item.componentViewClass];
    
    view.frame = item.componentFrame;
    [view setRNSId:item.uniqueId];
    [self.dequeueViewsDic setValue:view forKey:item.uniqueId];
    
    return view;
}

- (void)_enqueueViewOfItem:(RNSComponentItem *)item{
    __kindof UIView *view = [self getComponentViewByItem:item];
    [view removeFromSuperview];
    [view setRNSId:@""];
    [self.dequeueViewsDic removeObjectForKey:item.uniqueId];
    [self.scrollViewSubViews removeObject:view];
    [[RNSComponentViewPool shareInstance] enqueueComponentView:view];
    
}

- (__kindof UIView *)_triggerComponentEvent:(RNSComponentViewState)event withItem:(RNSComponentItem *)item{

    if(!item){
        return nil;
    }

    __kindof UIView * view = [self getComponentViewByItem:item];
    
    if (_changeBlock) {
        _changeBlock(event,item,view);
    }
    
    return view;
}

#pragma mark -

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self detailComponentsDidUpdateWithOffsetTop:scrollView.contentOffset.y];
}
- (void)scrollViewDidScrollTo:(CGFloat)offsetTop {
    [self detailComponentsDidUpdateWithOffsetTop:offsetTop];
}

@end
