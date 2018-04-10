//
//  HPKWebViewDelegateHandler.h
//  HybridPageKit
//
//  Created by dequanzhu.
//  Copyright © 2018 HybridPageKit. All rights reserved.
//

@interface HPKWebViewDelegateHandler : NSObject<WKNavigationDelegate>
- (instancetype)initWithController:(__kindof HPKViewController *)controller;
@end
