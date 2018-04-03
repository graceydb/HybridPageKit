//
//  LocalServer.h
//  HybridPageKit
//
//  Created by dequanzhu.
//  Copyright © 2018 HybridPageKit. All rights reserved.
//

#import <Foundation/Foundation.h>

#if TARGET_IPHONE_SIMULATOR
#define HPKLocalServerPort 8080
#define HPKLocalServerURL @"http://127.0.0.1:8080"
#else
#define HPKLocalServerPort 80
#define HPKLocalServerURL @"http://127.0.0.1"
#endif

@interface LocalServer : NSObject

+ (instancetype)sharedInstance;

@end
