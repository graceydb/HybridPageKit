//
//  HPKWebViewHandler.h
//  HybridPageKit
//
//  Created by dequanzhu.
//  Copyright © 2018 HybridPageKit. All rights reserved.
//
#import <WebKit/WebKit.h>
#import "HPKViewController.h"

@interface HPKWebViewHandler : NSObject<WKNavigationDelegate>

- (instancetype)initWithController:(__kindof HPKViewController *)controller;

//last read position
- (void)saveLastReadPosition;
- (CGFloat)getLastReadPosition;

//js string

+ (NSString *)getComponentFrameJs;
+ (NSString *)componentHtmlTemplate;
+ (NSString *)setComponentJSWithIndex:(NSString *)index
                        componentSize:(CGSize)componentSize;

@end
