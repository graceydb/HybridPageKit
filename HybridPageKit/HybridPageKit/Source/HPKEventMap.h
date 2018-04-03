//
//  HPKEventMap.h
//  HybridPageKit
//
//  Created by dequanzhu.
//  Copyright © 2018 HybridPageKit. All rights reserved.
//
#import "HPKComponentControllerDelegate.h"

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
    kHPKComponentEventEndPrepareComponentView
};

static SEL _getSelectorForEventType(HPKComponentEvent event) {
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
    };
    return mapping[event];
}

