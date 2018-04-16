//
//  HPKHtmlRenderHandler.h
//  HybridPageKit
//
//  Created by dequanzhu.
//  Copyright © 2018 HybridPageKit. All rights reserved.
//

typedef void (^HPKHtmlRenderCompleteBlock)(NSString *finalHTMLString, NSError *error);

@interface HPKHtmlRenderHandler : NSObject

+ (HPKHtmlRenderHandler *)shareInstance;

- (void)asyncRenderHTMLString:(NSString *)htmlString
               componentArray:(NSArray<RNSObject *> *)componentArray
                completeBlock:(HPKHtmlRenderCompleteBlock)completeBlock;
@end
