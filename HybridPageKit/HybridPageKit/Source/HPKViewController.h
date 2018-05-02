//
//  HPKViewController.h
//  HybridPageKit
//
//  Created by dequanzhu.
//  Copyright © 2018 HybridPageKit. All rights reserved.
//


#import "_HPKViewController.h"
#import "HPKViewConfig.h"
#import <WebKit/WebKit.h>


@interface HPKViewController : _HPKViewController


@property(nonatomic,strong,readwrite) HPKViewConfig *viewConfig;


- (instancetype)initWithWebView:(BOOL)needWebView;


#pragma mark -

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


#pragma mark - layout
- (void)reLayoutWebViewComponentsWithIndex:(NSString *)index
                             componentSize:(CGSize)componentSize;
- (void)reLayoutWebViewComponents;

- (void)reLayoutExtensionComponents;


@end
