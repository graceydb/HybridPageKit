//
//  WKWebView + SafeEvaluateJS.m
//  WKWebViewExtension
//
//  Created by dequanzhu
//  Copyright © 2018 HybridPageKit. All rights reserved.
//

#import "WKWebView + SafeEvaluateJS.h"

@implementation WKWebView (SafeEvaluateJS)

- (void)safeAsyncEvaluateJavaScriptString:(NSString *)script{
    [self safeAsyncEvaluateJavaScriptString:script completionBlock:nil];
}
- (void)safeAsyncEvaluateJavaScriptString:(NSString *)script completionBlock:(SafeEvaluateJSCompletion)block{
    if (!script) {
        return;
    }
    [self evaluateJavaScript:script
            completionHandler:^(id result, NSError *_Nullable error) {
                // retainify self
                __unused __attribute__((objc_ownership(strong))) __typeof__(self) self_retain_ = self;
                
                if (!error) {
                    if (block) {
                        
                        NSString *resultString = @"";
                        if (!result || [result isKindOfClass:[NSNull class]]) {
                            resultString = @"";
                        } else if ([result isKindOfClass:[NSString class]]) {
                            resultString = (NSString *)result;
                        } else if ([result isKindOfClass:[NSNumber class]]) {
                            resultString = ((NSNumber *)result).stringValue;
                        } else if ([result isKindOfClass:[NSData class]]) {
                            resultString = [[NSString alloc] initWithData:((NSData *)result) encoding:NSUTF8StringEncoding];
                        } else {
                            NSAssert(NO,@"WKWebView (SafeEvaluateJS) evaluate js return type:%@,js:%@",
                                      NSStringFromClass([result class]),
                                      script);
                        }
                        
                        block(resultString);
                    }
                } else {
                    NSLog(@"WKWebView evaluate js Error : %@ %@", error.description, script);
                    if (block) {
                        block(@"");
                    }
                }
            }];
}

@end
