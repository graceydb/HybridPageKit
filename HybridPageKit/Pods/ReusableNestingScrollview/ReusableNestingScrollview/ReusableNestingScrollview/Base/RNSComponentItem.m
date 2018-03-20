//
//  RNSComponentItem.m
//  ReusableNestingScrollview
//
//  Created by dequanzhu.
//  Copyright © 2018 HybridPageKit. All rights reserved.
//

#import "RNSComponentItem.h"

@interface RNSComponentItem()

@property(nonatomic, copy, readwrite) NSString *uniqueId;
@property(nonatomic, assign, readwrite) CGRect componentFrame;
@property(nonatomic, assign, readwrite) Class componentViewClass;
@property(nonatomic, strong, readwrite) __kindof RNSComponentContext *customContext;

@end

@implementation RNSComponentItem

- (instancetype)initWithUniqueId:(NSString *)uniqueId
                  componentFrame:(CGRect)componentFrame
              componentViewClass:(Class)componentViewClass
                  contextBuilder:(RNSComponentItemBuilder)contextBuilder{
    self = [super init];
    if (self) {
        if(!uniqueId || uniqueId.length <= 0 || CGRectIsNull(componentFrame)){
            NSAssert(NO, @"RNSComponentItem init with invalid paras");
            return nil;
        }
        
        _uniqueId = uniqueId;
        _componentViewClass = componentViewClass;
        _componentFrame = componentFrame;
        
        _oldState = kRNSComponentItemStateNone;
        _newState = kRNSComponentItemStateNone;
        
        if (contextBuilder) {
            _customContext = contextBuilder();
        }
        if (_customContext == nil) {
            _customContext = [[RNSComponentContext alloc] init];
        }
    }
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:(@"%@,uniqueId:%@,frame:%@"),NSStringFromClass([self class]),_uniqueId,NSStringFromCGRect(_componentFrame)];
}

- (BOOL)isEqual:(id)object{
   return [[self class] isKindOfClass:[object class]] && [((RNSComponentItem *)object).uniqueId isEqualToString: self.uniqueId];
}

@end
