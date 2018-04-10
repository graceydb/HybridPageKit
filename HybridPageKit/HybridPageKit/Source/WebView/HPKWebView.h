//
//  HPKWebView.h
//  HybridPageKit
//
//  Created by dequanzhu.
//  Copyright © 2018 HybridPageKit. All rights reserved.
//

#import "WKWebViewExtensionsDef.h"

#define kHPKWebViewReuseUrlString @"HybridPageKit://"

@protocol HPKWebViewReuseProtocol
-(void)webViewWillReuse;
-(void)webViewEndReuse;
@end

@interface HPKWebView : WKWebView <HPKWebViewReuseProtocol>
//auto release in pool
@property(nonatomic, weak, readwrite) id holderObject;

- (void)injectHPKJavascriptWithDomClass:(NSString *)domClass;

#pragma mark - WKWebViewExtension

+ (void)fixWKWebViewMenuItems;

+ (void)supportProtocolWithHTTP:(BOOL)supportHTTP
              customSchemeArray:(NSArray<NSString *> *)customSchemeArray
               urlProtocolClass:(Class)urlProtocolClass;

+ (void)safeClearAllCache;

+ (void)configCustomUAWithType:(ConfigUAType)type
                  UAString:(NSString *)customString;

- (void)scrollToOffset:(CGFloat)offset
       maxRunloops:(NSUInteger)maxRunloops
   completionBlock:(SafeScrollToCompletionBlock)completionBlock;


- (void)safeAsyncEvaluateJavaScriptString:(NSString *)script;
- (void)safeAsyncEvaluateJavaScriptString:(NSString *)script completionBlock:(SafeEvaluateJSCompletion)block;

- (void)setCookieWithName:(NSString *)name
                value:(NSString *)value
               domain:(NSString *)domain
                 path:(NSString *)path
          expiresDate:(NSDate *)expiresDate;
- (void)deleteCookiesWithName:(NSString *)name;
- (NSSet<NSString *> *)getAllCustomCookiesName;
- (void)deleteAllCustomCookies;

@end
