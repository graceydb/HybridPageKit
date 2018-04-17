//
//  HPKViewController.h
//  HybridPageKit
//
//  Created by dequanzhu.
//  Copyright © 2018 HybridPageKit. All rights reserved.
//

#import "HPKDefs.h"

typedef void (^HPKViewControllerBottomPullRefreshBlock)(void);

@interface HPKViewController : UIViewController

@property(nonatomic,assign,readwrite)CGFloat componentsGap;


- (instancetype)initWithWebView:(BOOL)needWebView;

- (NSArray<NSObject<HPKComponentControllerDelegate> *> *)getValidComponentControllers;


#pragma mark -  set data and render
// hybrid view controller
- (void)setArticleDetailModel:(NSObject *)model
                 htmlTemplate:(NSString *)htmlTemplate
      webviewExternalDelegate:(id<WKNavigationDelegate>)externalDelegate
            webViewComponents:(NSArray<RNSModel *> *)webViewComponents
          extensionComponents:(NSArray<RNSModel *> *)extensionComponents;

// banner view controller & components view controller
- (void)setArticleDetailModel:(NSObject *)model
               topInsetOffset:(CGFloat)topInsetOffset
          extensionComponents:(NSArray<RNSModel *> *)extensionComponents;

#pragma mark - pull to refresh
- (void)setBottomPullRefreshBlock:(HPKViewControllerBottomPullRefreshBlock)bottomPullRefreshBlock;
- (void)stopRefreshLoadingWithMoreData:(BOOL)hasMore;

#pragma mark - layout
- (void)reLayoutWebViewComponentsWithIndex:(NSString *)index
                             componentSize:(CGSize)componentSize;
- (void)reLayoutWebViewComponents;
- (void)reLayoutExtensionComponents;

#pragma mark - trigger event
- (void)triggerEvent:(HPKComponentEvent)event;
- (void)triggerEvent:(HPKComponentEvent)event para1:(NSObject *)para1;
- (void)triggerEvent:(HPKComponentEvent)event para1:(NSObject *)para1 para2:(NSObject *)para2;

@end
