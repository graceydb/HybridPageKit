//
//  HPKWebViewPool.h
//  HybridPageKit
//
//  Created by dequanzhu.
//  Copyright © 2018 HybridPageKit. All rights reserved.
//

#define kHPKWebViewReuseUrlString @"HybridPageKit://reuse-webView"

@protocol HPKWebViewReuseProtocol
-(void)webViewWillReuse;
-(void)webViewEndReuse;
@end

@interface HPKWebViewPool : NSObject

+ (HPKWebViewPool *)shareInstance;

- (__kindof HPKWebView *)getReusedWebViewForHolder:(id)holder;

- (void)recycleReusedWebView:(__kindof HPKWebView *)webView;

- (void)cleanReusableViews;

@end
