//
//  HPKViewController.h
//  HybridPageKit
//
//  Created by dequanzhu.
//  Copyright © 2018 HybridPageKit. All rights reserved.
//

#import "HPKWebView.h"
#import "HPKContainerScrollView.h"
#import "HPKComponentControllerDelegate.h"
#import "HPKEventMap.h"

typedef void (^HPKViewControllerBottomPullRefreshBlock)(void);

@interface HPKViewController : UIViewController

@property(nonatomic,strong,readonly)HPKWebView *webView;
@property(nonatomic,strong,readonly)HPKContainerScrollView *containerScrollView;



- (instancetype)initWithDefaultWebView:(BOOL)needWebView;


- (void)setBottomPullRefreshBlock:(HPKViewControllerBottomPullRefreshBlock)bottomPullRefreshBlock;

//override
- (NSArray *)getComponentControllerArray;
- (CGFloat)componentsGap;
- (id<WKNavigationDelegate>)getWebViewExternalNavigationDelegate;

- (__kindof UIView *)getBannerView;

//set
- (void)setArticleDetailModel:(NSObject *)model
          inWebViewComponents:(NSArray<NSObject <RNSModelProtocol> *> *)inWebViewComponents
          outWebViewComponents:(NSArray<NSObject <RNSModelProtocol> *> *)outWebViewComponents;

- (void)renderHtmlTemplate:(NSString *)htmlTemplate
            componentArray:(NSArray<NSObject <RNSModelProtocol> *> *)componentArray;

- (void)reLayoutOutWebViewComponents;
- (void)reLayoutInWebViewComponents;


- (void)triggerEvent:(HPKComponentEvent)event para1:(NSObject *)para1;

@end
