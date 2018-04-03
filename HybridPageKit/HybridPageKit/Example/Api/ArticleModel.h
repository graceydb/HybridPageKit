//
//  ArticleModel.h
//  HybridPageKit
//
//  Created by dequanzhu.
//  Copyright © 2018 HybridPageKit. All rights reserved.
//

@interface ArticleModel : NSObject

@property(nonatomic,copy,readonly)NSString *articleIdStr;

//template
@property(nonatomic,copy,readonly)NSString *contentTemplateString;

//component
@property(nonatomic,strong,readonly)NSArray<NSObject<RNSModelProtocol> *> *inWebViewComponents;
@property(nonatomic,strong,readonly)NSArray<NSObject<RNSModelProtocol> *> *outWebViewComponents;

- (instancetype)initWithDic:(NSDictionary *)dic;
@end
