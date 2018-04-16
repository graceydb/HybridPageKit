//
//  LocalServer.m
//  HybridPageKit
//
//  Created by dequanzhu.
//  Copyright © 2018 HybridPageKit. All rights reserved.
//

#import "LocalServer.h"
#import "GCDWebServer.h"
#import "GCDWebServerDataResponse.h"
#import "ArticleApi.h"

@interface LocalServer ()
@property(nonatomic,strong,readwrite) GCDWebServer *server;
@end

@implementation LocalServer

+ (instancetype)sharedInstance {
    static id instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        _server = [[GCDWebServer alloc]init];
        __weak typeof(self) wself = self;
        [_server addDefaultHandlerForMethod:@"GET" requestClass:[GCDWebServerRequest class] processBlock:^GCDWebServerResponse *(__kindof GCDWebServerRequest *request) {
            return [GCDWebServerDataResponse responseWithText:[wself _getResponseJsonWithType:((NSString *)[request.query objectForKey:@"type"]).integerValue]];
        }];
        __unused BOOL startState =[_server startWithPort:HPKLocalServerPort bonjourName:nil];
    }
    return self;
}

#pragma mark -

- (NSString *)_getResponseJsonWithType:(ArticleApiType)type{
    if (type == kArticleApiTypeArticle) {
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"articleContent" ofType:@"txt"];
        return [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    } else if(type == kArticleApiTypeAD){
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"adContent" ofType:@"txt"];
        return [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    } else if(type == kArticleApiTypeHotComment){
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"hotCommentContent" ofType:@"txt"];
        return [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    } else if(type == kArticleApiTypeShortArticle){
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"shortArticleContent" ofType:@"txt"];
        return [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    }

    return @"";
}

@end
