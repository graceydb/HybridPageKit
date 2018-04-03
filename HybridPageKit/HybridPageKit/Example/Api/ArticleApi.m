//
//  ArticleApi.m
//  HybridPageKit
//
//  Created by dequanzhu.
//  Copyright © 2018 HybridPageKit. All rights reserved.
//

#import "ArticleApi.h"
#import "LocalServer.h"

@interface ArticleApi()
@property(nonatomic,strong,readwrite) NSURLSessionTask *task;
@end

@implementation ArticleApi

- (instancetype) initWithApiType:(ArticleApiType)type
                 completionBlock:(ArticleApiCompletionBlock)completionBlock{
    self = [super init];
    if (self) {
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@?type=%@",HPKLocalServerURL,@(type)]]];
        [request setHTTPMethod:@"GET"];
        _task = [[NSURLSession sharedSession]dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            if (completionBlock) {
                
                if (data) {
                    id obj = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
                    if ([obj isKindOfClass:[NSDictionary class]]) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                             completionBlock((NSDictionary *)obj,error);
                        });
                    }
                }
                
                
            }
        }];
        [_task resume];
    }
    return self;
}

-(void)cancel{
    [_task cancel];
    _task = nil;
}
@end
