//
//  HotCommentModel.m
//  HybridPageKit
//
//  Created by dequanzhu.
//  Copyright © 2018 HybridPageKit. All rights reserved.
//

#import "HotCommentModel.h"
#import "HotCommentView.h"
#import "ArticleApi.h"

@interface HotCommentModel()
@property(nonatomic,copy,readwrite)NSString *index;
@property(nonatomic,copy,readwrite) NSArray * HotCommentArray;
@property(nonatomic,assign,readwrite)CGRect frame;
@property(nonatomic,strong,readwrite)ArticleApi *loadMoreApi;
@property(nonatomic,copy,readwrite)HotCommentModelLoadCompletionBlock completionBlock;
@property(nonatomic,assign,readwrite)BOOL hasMore;

@end
@implementation HotCommentModel
- (instancetype)initWithDic:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        _index = [dic objectForKey:@"index"];
        _hasMore = YES;
        [self setHotComments:[dic objectForKey:@"commentArray"]];
    }
    return self;
}

-(void)dealloc{
    if (_loadMoreApi) {
        [_loadMoreApi cancel];
        _loadMoreApi = nil;
    }
    _completionBlock = nil;
}

-(void)loadMoreHotCommentsWithCompletionBlock:(HotCommentModelLoadCompletionBlock)completionBlock{
    
    if (!completionBlock) {
        return;
    }
    
    if (_loadMoreApi) {
        [_loadMoreApi cancel];
        _loadMoreApi = nil;
    }
    
    _completionBlock = [completionBlock copy];
    
    __weak typeof(self) wself = self;
    _loadMoreApi = [[ArticleApi alloc] initWithApiType:kArticleApiTypeHotComment completionBlock:^(NSDictionary *responseDic, NSError *error) {
        
        NSMutableArray *arrayTmp = wself.HotCommentArray.mutableCopy;
        for (NSString * comment in [responseDic objectForKey:@"hotComment"]) {
            [arrayTmp addObject:[NSString stringWithFormat:@"%@ - %@",comment,@(arrayTmp.count + 1)]];
        }
        [wself setHotComments:arrayTmp.copy];
        wself.hasMore = wself.HotCommentArray.count <= 20;
        
        if(wself.completionBlock){
            wself.completionBlock();
        }
    }];
}
#pragma mark -

-(void)setHotComments:(NSArray *)hotComments{
    _HotCommentArray = hotComments;
    _frame = CGRectMake(_frame.origin.x, _frame.origin.y, [UIScreen mainScreen].bounds.size.width, hotComments.count * kHotCommentViewCellHeight);
}

#pragma mark - RNSModelProtocol

-(NSString *)getUniqueId{
    return _index;
}
-(CGRect)getComponentFrame{
    return _frame;
}
-(void)setComponentFrame:(CGRect)frame{
    _frame = frame;
}
-(Class)getComponentViewClass{
    return [HotCommentView class];
}
-(Class)getComponentControllerClass{
    return [HotCommentController class];
}
-(__kindof RNSComponentContext *)getCustomContext{
    return nil;
}
-(void)setComponentOriginY:(CGFloat)originY{
    _frame = CGRectMake(_frame.origin.x, originY, _frame.size.width, _frame.size.height);
}
-(void)setComponentOriginX:(CGFloat)originX{
    _frame = CGRectMake(originX, _frame.origin.y, _frame.size.width, _frame.size.height);
}
@end
