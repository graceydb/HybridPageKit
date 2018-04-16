//
//  HPKDefs.h
//  HybridPageKit
//
//  Created by dequanzhu.
//  Copyright © 2018 HybridPageKit. All rights reserved.
//

@class HPKViewController;
@class HPKWebView;

#import "RNSModelProtocol.h"

@protocol HPKComponentControllerDelegate

@required
- (BOOL)shouldResponseWithComponentView:(__kindof UIView *)componentView
                         componentModel:(RNSObject *)componentModel;

@optional
//controller
- (void)controllerInit:(__kindof HPKViewController *)controller;
- (void)controllerViewDidLoad:(__kindof HPKViewController *)controller;
- (void)controllerViewWillAppear:(__kindof HPKViewController *)controller;
- (void)controllerViewDidAppear:(__kindof HPKViewController *)controller;
- (void)controllerViewWillDisappear:(__kindof HPKViewController *)controller;
- (void)controllerViewDidDisappear:(__kindof HPKViewController *)controller;

//data
- (void)controller:(__kindof HPKViewController *)controller
    didReceiveData:(NSObject *)data;

//webview
- (void)webViewDidFinishNavigation:(__kindof HPKWebView *)webView;
- (void)webViewDidShow:(__kindof HPKWebView *)webView;
- (void)webViewScrollViewDidScroll:(__kindof HPKWebView *)webView;

//component scroll
- (void)scrollViewWillDisplayComponentView:(__kindof UIView *)componentView
                            componentModel:(RNSObject *)componentModel;

- (void)scrollViewEndDisplayComponentView:(__kindof UIView *)componentView
                           componentModel:(RNSObject *)componentModel;

- (void)scrollViewWillPrepareComponentView:(__kindof UIView *)componentView
                            componentModel:(RNSObject *)componentModel;

- (void)scrollViewEndPrepareComponentView:(__kindof UIView *)componentView
                           componentModel:(RNSObject *)componentModel;

- (void)scrollViewRelayoutComponentView:(__kindof UIView *)componentView
                         componentModel:(RNSObject *)componentModel;
@end

typedef NS_ENUM(NSInteger, HPKComponentEvent) {
    //controller
    kHPKComponentEventControllerInit,
    kHPKComponentEventControllerViewDidLoad,
    kHPKComponentEventControllerViewWillAppear,
    kHPKComponentEventControllerViewDidAppear,
    kHPKComponentEventControllerViewWillDisappear,
    kHPKComponentEventControllerViewDidDisappear,
    //data
    kHPKComponentEventControllerDidReceiveData,
    //webview
    kHPKComponentEventWebViewDidFinishNavigation,
    kHPKComponentEventWebViewDidShow,
    kHPKComponentEventWebViewScrollViewDidScroll,
    //component scroll
    kHPKComponentEventWillDisplayComponentView,
    kHPKComponentEventEndDisplayComponentView,
    kHPKComponentEventWillPrepareComponentView,
    kHPKComponentEventEndPrepareComponentView,
    kHPKComponentEventRelayoutComponentView,
};

static SEL _getHPKComponentControllerDelegateByEventType(HPKComponentEvent event) {
    SEL mapping[] =
    {   [kHPKComponentEventControllerInit] = @selector(controllerInit:),
        [kHPKComponentEventControllerViewDidLoad] = @selector(controllerViewDidLoad:),
        [kHPKComponentEventControllerViewWillAppear] = @selector(controllerViewWillAppear:),
        [kHPKComponentEventControllerViewDidAppear] = @selector(controllerViewDidAppear:),
        [kHPKComponentEventControllerViewWillDisappear] = @selector(controllerViewWillDisappear:),
        [kHPKComponentEventControllerViewDidDisappear] = @selector(controllerViewDidDisappear:),
        [kHPKComponentEventControllerDidReceiveData] = @selector(controller:didReceiveData:),
        [kHPKComponentEventWebViewDidFinishNavigation] = @selector(webViewDidFinishNavigation:),
        [kHPKComponentEventWebViewDidShow] = @selector(webViewDidShow:),
        [kHPKComponentEventWebViewScrollViewDidScroll] = @selector(webViewScrollViewDidScroll:),
        [kHPKComponentEventWillDisplayComponentView] = @selector(scrollViewWillDisplayComponentView:componentModel:),
        [kHPKComponentEventEndDisplayComponentView] = @selector(scrollViewEndDisplayComponentView:componentModel:),
        [kHPKComponentEventWillPrepareComponentView] = @selector(scrollViewWillPrepareComponentView:componentModel:),
        [kHPKComponentEventEndPrepareComponentView] = @selector(scrollViewEndPrepareComponentView:componentModel:),
        [kHPKComponentEventRelayoutComponentView] =
        @selector(scrollViewRelayoutComponentView:componentModel:)
    };
    return mapping[event];
}
