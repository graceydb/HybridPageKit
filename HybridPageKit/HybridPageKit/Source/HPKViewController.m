//
//  HPKViewController.m
//  HybridPageKit
//
//  Created by dequanzhu.
//  Copyright © 2018 HybridPageKit. All rights reserved.
//

#import "HPKViewController.h"
#import "HPKWebViewPool.h"
#import "HPKWebViewHandler.h"
#import "HPKURLProtocol.h"
#import "MJRefresh.h"
#import "HPKContainerScrollView.h"
#import "HPKWebView.h"

@interface HPKViewController()<WKNavigationDelegate>
//container view
@property(nonatomic,strong,readwrite)HPKContainerScrollView *containerScrollView;
@property(nonatomic,strong,readwrite)RNSHandler *containerViewScrollViewhandler;
@property(nonatomic,copy,readwrite)NSArray *sortedExtensionComponents;
//webview
@property(nonatomic,assign,readwrite)BOOL needWebView;
@property(nonatomic,strong,readwrite)HPKWebView *webView;
@property(nonatomic,strong,readwrite)HPKWebViewHandler *webViewHandler;
@property(nonatomic,strong,readwrite)RNSHandler *webViewScrollViewhandler;
@property(nonatomic,copy,readwrite)NSArray *webViewComponents;

@property(nonatomic,copy,readwrite)NSArray<NSObject<HPKComponentControllerDelegate> *> *componentControllerArray;
@property(nonatomic,copy,readwrite)HPKViewControllerBottomPullRefreshBlock bottomPullRefreshBlock;
@property(nonatomic,assign,readwrite)CGFloat topInsetOffset;

@end

@implementation HPKViewController

- (instancetype)initWithWebView:(BOOL)needWebView{
    self = [super init];
    if (self) {
        _needWebView = needWebView;
        _componentsGap = 10.f;
        _topInsetOffset = 0.f;
        _componentControllerArray = [self getValidComponentControllers];
        [self triggerEvent:kHPKComponentEventControllerInit para1:self];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self triggerEvent:kHPKComponentEventControllerViewWillAppear];
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self triggerEvent:kHPKComponentEventControllerViewDidAppear];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self triggerEvent:kHPKComponentEventControllerViewWillDisappear];
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self triggerEvent:kHPKComponentEventControllerViewDidDisappear];
}

-(void)dealloc{
    
    if (_needWebView) {
        [_webView.scrollView removeObserver:_webViewHandler forKeyPath:@"contentSize"];
        [[HPKWebViewPool shareInstance] recycleReusedWebView:_webView];
        _webViewScrollViewhandler = nil;
        _webViewComponents = nil;
    }
    _containerViewScrollViewhandler = nil;
    _containerScrollView = nil;
    _componentControllerArray = nil;
    _sortedExtensionComponents = nil;
    _bottomPullRefreshBlock = nil;
}

#pragma mark - bottom pull
- (void)setBottomPullRefreshBlock:(HPKViewControllerBottomPullRefreshBlock)bottomPullRefreshBlock{
    _bottomPullRefreshBlock = [bottomPullRefreshBlock copy];
}
- (void)stopRefreshLoadingWithMoreData:(BOOL)hasMore{
    _containerScrollView.mj_footer.state = hasMore ? MJRefreshStateIdle:MJRefreshStateNoMoreData;
}

#pragma mark -

- (NSArray<NSObject<HPKComponentControllerDelegate> *> *)getValidComponentControllers{
    return @[];
}

- (void)viewDidLoad{
    [super viewDidLoad];
    [self triggerEvent:kHPKComponentEventControllerViewDidLoad];
    __weak typeof(self) wself = self;
    [self.view addSubview:({
        _containerScrollView = [[HPKContainerScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - 64) layoutBlock:^{
            if (wself.needWebView) {
                CGFloat webViewContentSizeY = wself.webView.scrollView.contentSize.height - wself.webView.frame.size.height;
                CGFloat offsetY = wself.containerScrollView.contentOffset.y;
                if (offsetY < 0) {
                    return;
                }
                if (offsetY < webViewContentSizeY) {
                    wself.webView.scrollView.contentOffset = CGPointMake(wself.webView.scrollView.contentOffset.x, offsetY);
                    wself.webView.frame = CGRectMake(wself.webView.frame.origin.x, offsetY, wself.webView.frame.size.width, wself.webView.frame.size.height);
                    [wself reLayoutExtensionComponents];
                }
            }
        }];
        
        if (self.bottomPullRefreshBlock) {
            __weak typeof(self) wself = self;
            _containerScrollView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                if (wself.bottomPullRefreshBlock) {
                    wself.bottomPullRefreshBlock();
                }
            }];
        }
        
        _containerViewScrollViewhandler = [[RNSHandler alloc]initWithScrollView:_containerScrollView externalScrollViewDelegate:nil scrollWorkRange:0 componentViewStateChangeBlock: ^(RNSComponentViewState state, RNSModel *componentItem, __kindof UIView *componentView) {
            [wself _triggerComponentEventWithState:state componentItem:componentItem componentView:componentView];
        }];
        _containerScrollView.backgroundColor = [UIColor lightGrayColor];
        _containerScrollView;
    })];
    
    if (_needWebView) {
        [_containerScrollView addSubview:({
            _webViewHandler = [[HPKWebViewHandler alloc] initWithController:self];
            _webView = [[HPKWebViewPool shareInstance] getReusedWebViewForHolder:self];
            _webView.frame = CGRectMake(0, 0, _containerScrollView.bounds.size.width, _containerScrollView.bounds.size.height);
            
            [HPKWebView fixWKWebViewMenuItems];
            
            [_webView useExternalNavigationDelegate];
            [_webView setMainNavigationDelegate:_webViewHandler];
            
            [HPKWebView supportProtocolWithHTTP:NO
                              customSchemeArray:@[HPKURLProtocolHandleScheme]
                               urlProtocolClass:[HPKURLProtocol class]];
                        
            [_webView.scrollView addObserver:_webViewHandler forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:NULL];
            
            _webView.scrollView.scrollEnabled = NO;
            _webView;
        })];
        
        _webViewScrollViewhandler = [[RNSHandler alloc]initWithScrollView:_webView.scrollView externalScrollViewDelegate:nil scrollWorkRange:100 componentViewStateChangeBlock:^(RNSComponentViewState state, RNSModel *componentItem, __kindof UIView *componentView) {
            [wself _triggerComponentEventWithState:state componentItem:componentItem componentView:componentView];
        }];
    }
}

#pragma mark -

// hybrid view controller
- (void)setArticleDetailModel:(NSObject *)model
                 htmlTemplate:(NSString *)htmlTemplate
      webviewExternalDelegate:(id<WKNavigationDelegate>)externalDelegate
            webViewComponents:(NSArray<RNSModel *> *)webViewComponents
          extensionComponents:(NSArray<RNSModel *> *)extensionComponents{
    
    [_webView addExternalNavigationDelegate:externalDelegate];

    [self _setArticleDetailModel:model webViewComponents:webViewComponents extensionComponents:extensionComponents];
    
    [self.webView loadHTMLString:htmlTemplate baseURL:nil];
}

// banner view controller & components view controller
- (void)setArticleDetailModel:(NSObject *)model
               topInsetOffset:(CGFloat)topInsetOffset
          extensionComponents:(NSArray<RNSModel *> *)extensionComponents{
    
    _topInsetOffset = MAX(topInsetOffset, 0.f);

    [self _setArticleDetailModel:model webViewComponents:nil extensionComponents:extensionComponents];
}
-(void)_setArticleDetailModel:(NSObject *)model
            webViewComponents:(NSArray<RNSModel *> *)webViewComponents
          extensionComponents:(NSArray<RNSModel *> *)extensionComponents{
    
    [self triggerEvent:kHPKComponentEventControllerDidReceiveData para1:self para2:model];
    _webViewComponents = [[self _filterComponents:webViewComponents] copy];
    _sortedExtensionComponents = [[self _filterComponents:extensionComponents] sortedArrayUsingComparator:^NSComparisonResult(id<RNSModelProtocol> obj1, id<RNSModelProtocol> obj2) {
        return ([obj1 getUniqueId] < [obj2 getUniqueId]) ? NSOrderedAscending : NSOrderedDescending;
    }];
}

-(NSArray *)_filterComponents:(NSArray *)components{
    return [components objectsAtIndexes:
                           [components indexesOfObjectsPassingTest:^BOOL(id _Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        for(NSObject *controller in _componentControllerArray){
            if ([controller isKindOfClass:[obj getComponentControllerClass]]) {
                return YES;
            }
        }
        return NO;
    }]];
}



- (void)reLayoutWebViewComponentsWithIndex:(NSString *)index
                             componentSize:(CGSize)componentSize{
    if (!index) {
        return;
    }
    __weak typeof(self) wself = self;
    [_webView safeAsyncEvaluateJavaScriptString:[HPKWebViewHandler setComponentJSWithIndex:index componentSize:componentSize] completionBlock:^(NSObject *result) {
        [wself reLayoutWebViewComponents];
    }];
}


- (void)reLayoutExtensionComponents{
    
    
    CGFloat bottom = (_needWebView ? (self.webView.frame.origin.y + self.webView.frame.size.height) : _topInsetOffset)
+ _componentsGap;
    
    for (int i = 0; i < _sortedExtensionComponents.count; i++) {
        RNSModel *component = [_sortedExtensionComponents objectAtIndex:i];
        [component setComponentOriginY:bottom];
        bottom += [component getComponentFrame].size.height + _componentsGap;
    }
    
    __weak typeof(self) wself = self;
    [_containerViewScrollViewhandler reloadComponentViewsWithProcessBlock:^NSDictionary<NSString *,RNSModel *> *(NSDictionary<NSString *,RNSModel *> *componentItemDic) {
        NSMutableDictionary *dic = @{}.mutableCopy;
        for (RNSModel *component in wself.sortedExtensionComponents) {
            [dic setObject:component forKey:[component getUniqueId]];
        }
        wself.containerScrollView.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, bottom - _componentsGap);
        return dic.copy;
    }];
    
}
- (void)reLayoutWebViewComponents{

    __weak typeof(self) wself = self;
    
    [_webView safeAsyncEvaluateJavaScriptString:@"HPKGetAllComponentFrame()" completionBlock:^(NSObject *result) {
        
        if (![result isKindOfClass:[NSArray class]]) {
            return;
        }
        
        for (RNSModel *component in wself.webViewComponents) {
            CGRect frame = CGRectZero;
            NSString *key = [component getUniqueId];
            for (NSDictionary *dic in ((NSArray *)result)) {
                if ([[dic objectForKey:@"index"] isEqualToString:key]) {
                    frame = CGRectMake(((NSString *)[dic objectForKey:@"left"]).floatValue, ((NSString *)[dic objectForKey:@"top"]).floatValue,((NSString *)[dic objectForKey:@"width"]).floatValue,((NSString *)[dic objectForKey:@"height"]).floatValue);
                    break;
                }
            }
            [component setComponentFrame:frame];
        }
        
        [_webViewScrollViewhandler reloadComponentViewsWithProcessBlock:^NSDictionary<NSString *,RNSModel *> *(NSDictionary<NSString *,RNSModel *> *componentItemDic) {
            NSMutableDictionary *dic = @{}.mutableCopy;
            for (RNSModel *component in wself.webViewComponents) {
                [dic setObject:component forKey:[component getUniqueId]];
            }
            return dic.copy;
        }];
        
        
        NSString *jsStr = [NSString stringWithFormat:@"document.documentElement.offsetHeight * %d / document.documentElement.clientWidth", (int)_containerScrollView.bounds.size.width];
        
        [_webView evaluateJavaScript:jsStr completionHandler:^(id data, NSError * _Nullable error) {
            CGFloat height = [data floatValue];
            _webView.frame = CGRectMake(0, 0, _containerScrollView.bounds.size.width, MIN(height, _containerScrollView.bounds.size.height));
            [wself reLayoutExtensionComponents];
        }];
    }];
}

#pragma mark - component event trigger

-(void)_triggerComponentEventWithState:(RNSComponentViewState)state
                         componentItem:(RNSModel *)componentItem
                         componentView:(__kindof UIView *)componentView{
    
    HPKComponentEvent event;
    if (state == kRNSComponentViewWillPreparedComponentView) {
        event = kHPKComponentEventWillPrepareComponentView;
    }else if(state == kRNSComponentViewWillDisplayComponentView){
        event = kHPKComponentEventWillDisplayComponentView;
    }else if(state == kRNSComponentViewEndDisplayComponentView){
        event = kHPKComponentEventEndDisplayComponentView;
    }else if(state == kRNSComponentViewEndPreparedComponentView){
        event = kHPKComponentEventEndPrepareComponentView;
    }else if(state == kRNSComponentViewReLayoutPreparedAndVisibleComponentView){
        event = kHPKComponentEventRelayoutComponentView;
    }else{
        return;
    }
    
    [self triggerEvent:event para1:componentView para2:componentItem];
}

- (void)triggerEvent:(HPKComponentEvent)event {
    [self triggerEvent:event para1:nil];
}
- (void)triggerEvent:(HPKComponentEvent)event para1:(NSObject *)para1{
    [self triggerEvent:event para1:para1 para2:nil];
}
- (void)triggerEvent:(HPKComponentEvent)event para1:(NSObject *)para1 para2:(NSObject *)para2{
    
    SEL protocolSelector = _getHPKComponentControllerDelegateByEventType(event);
    if (!protocolSelector) {
        NSAssert(NO, @"HPKViewController trigger invalid event:%@", @(event));
        return;
    }
    
    BOOL isComponentScrollEvent = event > kHPKComponentScrollEventIndexBegin && event < kHPKComponentScrollEventIndexEnd;
    
    for (__kindof NSObject<HPKComponentControllerDelegate> *component in _componentControllerArray) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        if (isComponentScrollEvent) {
            SEL sel = @selector(shouldResponseWithComponentView:componentModel:);
            if([component respondsToSelector:sel] && ![component performSelector:sel withObject:para1 withObject:para2]){
                continue;
            }
        }
        if ([component respondsToSelector:protocolSelector]) {
            [component performSelector:protocolSelector withObject:para1 withObject:para2];
        }
#pragma clang diagnostic pop
    }
}
@end
