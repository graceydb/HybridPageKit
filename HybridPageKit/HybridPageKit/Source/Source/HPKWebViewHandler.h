//
//  HPKWebViewHandler.h
//  HybridPageKit
//
//  Created by dequanzhu.
//  Copyright © 2018 HybridPageKit. All rights reserved.
//

@interface HPKWebViewHandler : NSObject<WKNavigationDelegate>

- (instancetype)initWithController:(__kindof HPKViewController *)controller;

//last read position
- (void)saveLastReadPosition;
- (CGFloat)getLastReadPosition;

@end
