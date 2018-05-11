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
#import "HPKContainerScrollView.h"
#import "HPKWebView.h"
#import "RNSHandler.h"
#import "UIView + HPKLayout.h"

@interface HPKViewController()<WKNavigationDelegate>
//container view
@property(nonatomic,strong,readwrite)HPKContainerScrollView *containerScrollView;
@property(nonatomic,strong,readwrite)RNSHandler *containerViewScrollViewhandler;
@property(nonatomic,copy,readwrite)NSArray<RNSModel *> *sortedExtensionComponents;
//webview
@property(nonatomic,assign,readwrite)BOOL needWebView;
@property(nonatomic,strong,readwrite)HPKWebView *webView;
@property(nonatomic,strong,readwrite)HPKWebViewHandler *webViewHandler;
@property(nonatomic,strong,readwrite)RNSHandler *webViewScrollViewhandler;
@property(nonatomic,copy,readwrite)NSArray<RNSModel *> *webViewComponents;

@property(nonatomic,assign,readwrite)CGFloat topInsetOffset;
@property(nonatomic,assign,readwrite)CGFloat bottomViewOriginY;
@end

@implementation HPKViewController

- (instancetype)initWithWebView:(BOOL)needWebView{
    self = [super init];
    if (self) {
        self.componentControllerArray = [self getValidComponentControllers];
        _needWebView = needWebView;
        _topInsetOffset = 0.f;
        _bottomViewOriginY = 0.f;
        _viewConfig = [[HPKViewConfig alloc] init];
        [self triggerEvent:kHPKComponentEventControllerInit para1:self];
    }
    return self;
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
    _sortedExtensionComponents = nil;
}


#pragma mark -

- (NSArray<NSObject<HPKComponentControllerDelegate> *> *)getValidComponentControllers{
    return @[];
}

- (void)_handleTopWebViewScroll{
    
    if (!self.needWebView) {
        return;
    }

    CGFloat webViewContentSizeY = self.webView.scrollView.hpk_contentSizeHeight - self.webView.hpk_height;
    CGFloat offsetY = self.containerScrollView.hpk_contentOffsetY;
    CGFloat webViewNewOffset = 0.f;
    
    if (webViewContentSizeY == 0 && offsetY == 0) {
        return;
    }

    if (offsetY < 0) {
        // 容错-快速滚动到顶部
        self.webView.scrollView.hpk_contentOffsetY = 0.f;
        return;
    }

    if (offsetY <= webViewContentSizeY) {
        webViewNewOffset = offsetY;
    }else if(self.webView.scrollView.hpk_contentOffsetY < webViewContentSizeY){
        // 容错-快速滚动到底部
        webViewNewOffset = webViewContentSizeY;
    }else{
        return;
    }

    self.webView.scrollView.hpk_contentOffsetY = webViewNewOffset;
    self.webView.hpk_top = webViewNewOffset;
    [self reLayoutExtensionComponents];
}

- (void)_handleBottomScrollViewScroll{
    
    if (self.containerScrollView.hpk_contentOffsetY <= 0) {
        return;
    }
    
    RNSModel *bottomComponentModel = [self.sortedExtensionComponents lastObject];
    __kindof UIView *bottomComponentView = [self.containerViewScrollViewhandler getComponentViewByItem:bottomComponentModel];
    
    if (![bottomComponentView isKindOfClass:[UIScrollView class]]) {
        return;
    }
    
    __kindof UIScrollView *bottomScrollView = (UIScrollView *)bottomComponentView;
    CGFloat bottomOffset = 0.f;
    
    if (bottomScrollView.hpk_contentSizeHeight <= _containerScrollView.hpk_height) {
        return;
    }
    
    if (bottomScrollView.hpk_contentOffsetY >= bottomScrollView.hpk_contentSizeHeight - bottomScrollView.hpk_height) {
        // 容错-快速滚动到底部
        if (self.containerScrollView.hpk_contentOffsetY >= self.containerScrollView.hpk_contentSizeHeight - self.containerScrollView.hpk_height) {
            bottomScrollView.hpk_contentOffsetY = bottomScrollView.hpk_contentSizeHeight - bottomScrollView.hpk_height;
            return;
        }
    }
    
    if (self.containerScrollView.hpk_contentOffsetY <= _bottomViewOriginY) {
        // 容错-快速滚动到bottomView之上
        if (bottomScrollView.hpk_contentOffsetY == 0) {
            return;
        }
        bottomOffset = 0;
    }else {
        bottomOffset = self.containerScrollView.hpk_contentOffsetY - _bottomViewOriginY;
    }
    
    bottomScrollView.hpk_contentOffsetY = bottomOffset;
    [self _reLayoutExtensionComponentsWithScrollOffset:bottomOffset];
}

- (void)viewDidLoad{
    [super viewDidLoad];
    __weak typeof(self) wself = self;
    [self.view addSubview:({
        _containerScrollView = [[HPKContainerScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - 64) layoutBlock:^{
            [wself _handleTopWebViewScroll];
            [wself _handleBottomScrollViewScroll];
        }];
        
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

    [self _setArticleDetailModel:model
               webViewComponents:webViewComponents
             extensionComponents:extensionComponents];
    
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
    __weak typeof(self) wself = self;
    return [components objectsAtIndexes:
                           [components indexesOfObjectsPassingTest:^BOOL(id _Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        for(NSObject *controller in wself.componentControllerArray){
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

- (void)_reLayoutExtensionComponentsWithScrollOffset:(CGFloat)offset{

    if(!_sortedExtensionComponents || _sortedExtensionComponents.count <= 0){
        if (_needWebView && _webView) {
            _containerScrollView.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width,_webView.scrollView.contentSize.height);
        }
        return;
    }
    
    CGFloat bottom = (_needWebView ? (self.webView.frame.origin.y + self.webView.frame.size.height) : _topInsetOffset)
    + self.viewConfig.componentsGap + offset;
    
    for (int i = 0; i < _sortedExtensionComponents.count; i++) {
        RNSModel *component = [_sortedExtensionComponents objectAtIndex:i];
        [component setComponentOriginY:bottom];
        bottom += [component getComponentFrame].size.height + self.viewConfig.componentsGap;
        
        if (i == _sortedExtensionComponents.count - 1) {
            _bottomViewOriginY = [component getComponentFrame].origin.y - offset;
        }
    }
    
    __weak typeof(self) wself = self;
    [_containerViewScrollViewhandler reloadComponentViewsWithProcessBlock:^NSDictionary<NSString *,RNSModel *> *(NSDictionary<NSString *,RNSModel *> *componentItemDic) {
        NSMutableDictionary *dic = @{}.mutableCopy;
        for (RNSModel *component in wself.sortedExtensionComponents) {
            [dic setObject:component forKey:[component getUniqueId]];
        }
        wself.containerScrollView.hpk_contentSizeHeight = bottom - wself.viewConfig.componentsGap;
        return dic.copy;
    }];
}
- (void)reLayoutExtensionComponents{
    [self _reLayoutExtensionComponentsWithScrollOffset:0.f];
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
        
        [wself.webViewScrollViewhandler reloadComponentViewsWithProcessBlock:^NSDictionary<NSString *,RNSModel *> *(NSDictionary<NSString *,RNSModel *> *componentItemDic) {
            NSMutableDictionary *dic = @{}.mutableCopy;
            for (RNSModel *component in wself.webViewComponents) {
                [dic setObject:component forKey:[component getUniqueId]];
            }
            return dic.copy;
        }];
        
        
        NSString *jsStr = [NSString stringWithFormat:@"document.documentElement.offsetHeight * %d / document.documentElement.clientWidth", (int)wself.containerScrollView.bounds.size.width];
        
        [wself.webView evaluateJavaScript:jsStr completionHandler:^(id data, NSError * _Nullable error) {
            CGFloat height = [data floatValue];
            wself.webView.frame = CGRectMake(0, 0, wself.containerScrollView.bounds.size.width, MIN(height, wself.containerScrollView.bounds.size.height));
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

@end
