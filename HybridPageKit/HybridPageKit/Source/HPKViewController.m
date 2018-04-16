//
//  HPKViewController.m
//  HybridPageKit
//
//  Created by dequanzhu.
//  Copyright © 2018 HybridPageKit. All rights reserved.
//

#import "HPKViewController.h"
#import "HPKHtmlRenderHandler.h"
#import "HPKWebViewPool.h"
#import "HPKWebViewHandler.h"
#import "HPKURLProtocol.h"
#import "MJRefresh.h"

@interface HPKViewController()<WKNavigationDelegate>

@property(nonatomic,strong,readwrite)RNSHandler *webViewScrollViewhandler;
@property(nonatomic,strong,readwrite)RNSHandler *containerViewScrollViewhandler;

@property(nonatomic,strong,readwrite)HPKWebView *webView;
@property(nonatomic,assign,readwrite)BOOL needWebView;
@property(nonatomic,strong,readwrite)HPKContainerScrollView *containerScrollView;
@property(nonatomic,strong,readwrite)HPKWebViewHandler *delegateHandler;

@property(nonatomic,copy,readwrite)NSArray<id>*componentControllerArray;

@property(nonatomic,copy,readwrite)NSArray *unSortedWebViewComponents;
@property(nonatomic,copy,readwrite)NSArray *sortedExtensionComponents;

@property(nonatomic,assign,readwrite)CGSize lastWebViewContentSize;


@property(nonatomic,copy,readwrite)HPKViewControllerBottomPullRefreshBlock bottomPullRefreshBlock;


@end

@implementation HPKViewController

- (instancetype)initWithDefaultWebView:(BOOL)needWebView{
    self = [super init];
    if (self) {
        _needWebView = needWebView;
        _componentControllerArray = [self getComponentControllerArray];
        _delegateHandler = [[HPKWebViewHandler alloc] initWithController:self];
        [self _triggerEvent:kHPKComponentEventControllerInit para1:self];
    }
    return self;
}

- (void)setBottomPullRefreshBlock:(HPKViewControllerBottomPullRefreshBlock)bottomPullRefreshBlock{
    _bottomPullRefreshBlock = [bottomPullRefreshBlock copy];
}

- (void)stopRefreshLoadingWithMoreData:(BOOL)hasMore{
    _containerScrollView.mj_footer.state = hasMore ? MJRefreshStateIdle:MJRefreshStateNoMoreData;
}

-(void)dealloc{
    
    if (_needWebView) {
        [_webView.scrollView removeObserver:self forKeyPath:@"contentSize"];
        [[HPKWebViewPool shareInstance] recycleReusedWebView:_webView];
        _webViewScrollViewhandler = nil;
        _unSortedWebViewComponents = nil;
    }
    
    _containerViewScrollViewhandler = nil;
    _containerScrollView = nil;
    _componentControllerArray = nil;
    _sortedExtensionComponents = nil;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    [self _triggerEvent:kHPKComponentEventControllerViewDidLoad];
    
    __weak typeof(self) wself = self;

    
    
    [self.view addSubview:({
        _containerScrollView = [[HPKContainerScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - 64) layoutBlock:^{
            if (_needWebView) {
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
        
        _containerScrollView.backgroundColor = [UIColor lightGrayColor];
        _containerScrollView;
    })];
    
    if (_needWebView) {
        [_containerScrollView addSubview:({
            _webView = [[HPKWebViewPool shareInstance] getReusedWebViewForHolder:self];
            _webView.frame = CGRectMake(0, 0, _containerScrollView.bounds.size.width, _containerScrollView.bounds.size.height);
            
            [HPKWebView fixWKWebViewMenuItems];
            
            [_webView useExternalNavigationDelegate];
            [_webView setMainNavigationDelegate:_delegateHandler];
            [_webView addExternalNavigationDelegate:[self getWebViewExternalNavigationDelegate]];
            
            [HPKWebView supportProtocolWithHTTP:NO
                              customSchemeArray:@[HPKURLProtocolHandleScheme]
                               urlProtocolClass:[HPKURLProtocol class]];
            
            [_webView injectHPKJavascriptWithDomClass:@"HPK-Component-PlaceHolder"];
            
            [_webView.scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:NULL];
            
            _webView.scrollView.scrollEnabled = NO;
            _webView;
        })];
        
        _webViewScrollViewhandler = [[RNSHandler alloc]initWithScrollView:_webView.scrollView externalScrollViewDelegate:nil scrollWorkRange:100 componentViewStateChangeBlock:^(RNSComponentViewState state, RNSObject *componentItem, __kindof UIView *componentView) {
            [wself triggerComponentEventWithState:state componentItem:componentItem componentView:componentView];
        }];
    }

    _containerViewScrollViewhandler = [[RNSHandler alloc]initWithScrollView:_containerScrollView externalScrollViewDelegate:nil scrollWorkRange:0 componentViewStateChangeBlock: ^(RNSComponentViewState state, RNSObject *componentItem, __kindof UIView *componentView) {
        [wself triggerComponentEventWithState:state componentItem:componentItem componentView:componentView];
    }];
}

-(void)triggerComponentEventWithState:(RNSComponentViewState)state
                        componentItem:(RNSObject *)componentItem
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
    
    [self _triggerEvent:event para1:componentView para2:componentItem];
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self _triggerEvent:kHPKComponentEventControllerViewWillAppear];
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self _triggerEvent:kHPKComponentEventControllerViewDidAppear];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self _triggerEvent:kHPKComponentEventControllerViewWillDisappear];
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self _triggerEvent:kHPKComponentEventControllerViewDidDisappear];
}


#pragma mark -

-(CGFloat)componentsGap{
    return 0.f;
}
-(id<WKNavigationDelegate>)getWebViewExternalNavigationDelegate{
    return nil;
}
- (NSArray *)getComponentControllerArray{
    return @[];
}

- (__kindof UIView *)getBannerView{
    return nil;
}


-(NSArray *)filterComponents:(NSArray *)components{
    
    NSArray * controllers = [self getComponentControllerArray];

    return [components objectsAtIndexes:
                           [components indexesOfObjectsPassingTest:^BOOL(id _Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        for(NSObject *controller in controllers){
            if ([controller isKindOfClass:[obj getComponentControllerClass]]) {
                return YES;
            }
        }
        return NO;
    }]];
}


- (void)setArticleDetailModel:(NSObject *)model
          WebViewComponents:(NSArray *)WebViewComponents
         ExtensionComponents:(NSArray *)ExtensionComponents{
    [self _triggerEvent:kHPKComponentEventControllerDidReceiveData para1:self para2:model];
    
    
    
    
    _unSortedWebViewComponents = [[self filterComponents:WebViewComponents] copy];
    _sortedExtensionComponents = [[self filterComponents:ExtensionComponents] sortedArrayUsingComparator:^NSComparisonResult(id<RNSModelProtocol> obj1, id<RNSModelProtocol> obj2) {
        return ([obj1 getUniqueId] < [obj2 getUniqueId]) ? NSOrderedAscending : NSOrderedDescending;
    }];
}
- (void)renderHtmlTemplate:(NSString *)htmlTemplate
            componentArray:(NSArray *)componentArray{
    [[HPKHtmlRenderHandler shareInstance] asyncRenderHTMLString:htmlTemplate componentArray:componentArray completeBlock:^(NSString *finalHTMLString, NSError *error) {
        
        [_webView loadHTMLString:finalHTMLString baseURL:nil];
    }];
}

- (void)reLayoutExtensionComponents{

    CGFloat componentGap = [self componentsGap];
    
    __kindof UIView *topView;
    
    if (_needWebView) {
        topView = self.webView;
    }else{
        topView = [self getBannerView];
    }
    
    CGFloat bottom = topView.frame.origin.y + topView.frame.size.height + componentGap;
    
    for (int i = 0; i < _sortedExtensionComponents.count; i++) {
        RNSObject *component = [_sortedExtensionComponents objectAtIndex:i];
        [component setComponentOriginY:bottom];
        bottom += [component getComponentFrame].size.height + componentGap;
    }
    
    __weak typeof(self) wself = self;
    [_containerViewScrollViewhandler reloadComponentViewsWithProcessBlock:^NSDictionary<NSString *,RNSObject *> *(NSDictionary<NSString *,RNSObject *> *componentItemDic) {
        NSMutableDictionary *dic = @{}.mutableCopy;
        for (RNSObject *component in wself.sortedExtensionComponents) {
            [dic setObject:component forKey:[component getUniqueId]];
        }
        wself.containerScrollView.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, bottom - componentGap);
        return dic.copy;
    }];
    
}
- (void)reLayExtensionComponents{

    __weak typeof(self) wself = self;
    [_webView evaluateJavaScript:@"HPKGetAllComponentFrame()" completionHandler:^(id _Nullable data, NSError * _Nullable error) {
        NSArray *array = data;
        for (RNSObject *component in wself.unSortedWebViewComponents) {
            CGRect frame = CGRectZero;
            NSString *key = [component getUniqueId];
            for (NSDictionary *dic in array) {
                if ([[dic objectForKey:@"index"] isEqualToString:key]) {
                    frame = CGRectMake(((NSString *)[dic objectForKey:@"left"]).floatValue, ((NSString *)[dic objectForKey:@"top"]).floatValue,((NSString *)[dic objectForKey:@"width"]).floatValue,((NSString *)[dic objectForKey:@"height"]).floatValue);
                    break;
                }
            }
            [component setComponentFrame:frame];
        }

        [_webViewScrollViewhandler reloadComponentViewsWithProcessBlock:^NSDictionary<NSString *,RNSObject *> *(NSDictionary<NSString *,RNSObject *> *componentItemDic) {
            NSMutableDictionary *dic = @{}.mutableCopy;
            for (RNSObject *component in wself.unSortedWebViewComponents) {
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

#pragma mark -
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    
    CGSize newSize = [((NSValue *)[change objectForKey:NSKeyValueChangeNewKey]) CGSizeValue];
    
    if(!CGSizeEqualToSize(newSize,_lastWebViewContentSize)){
        _lastWebViewContentSize = newSize;
        [self reLayExtensionComponents];
    } 
}

#pragma mark - component

- (void)triggerEvent:(HPKComponentEvent)event para1:(NSObject *)para1{
    [self _triggerEvent:event para1:para1];
}
- (void)_triggerEvent:(HPKComponentEvent)event {
    [self _triggerEvent:event para1:nil];
}
- (void)_triggerEvent:(HPKComponentEvent)event para1:(NSObject *)para1{
    [self _triggerEvent:event para1:para1 para2:nil];
}
- (void)_triggerEvent:(HPKComponentEvent)event para1:(NSObject *)para1 para2:(NSObject *)para2{
    
    SEL protocolSelector = _getHPKComponentControllerDelegateByEventType(event);
    if (!protocolSelector) {
        NSAssert(NO, @"HPKViewController trigger invalid event:%@", @(event));
        return;
    }
    for (__kindof NSObject<HPKComponentControllerDelegate> *component in _componentControllerArray) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        
#warning later
        if (para1 && para2 && para1 != self) {
            SEL sel = @selector(shouldResponseWithComponentView:componentModel:);
            if([component respondsToSelector:sel] && ![component performSelector:sel withObject:para1 withObject:para2]){
                continue;
            }
        }
        
        if ([component respondsToSelector:protocolSelector]) {
            
            if (para2 == nil) {
                [component performSelector:protocolSelector withObject:para1];
            }else{
                [component performSelector:protocolSelector withObject:para1 withObject:para2];
            }
            
            
        }
#pragma clang diagnostic poppara1
    }
}
@end
