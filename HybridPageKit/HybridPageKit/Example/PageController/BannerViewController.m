//
//  BannerViewController.m
//  HybridPageKit
//
//  Created by dequanzhu.
//  Copyright © 2018 HybridPageKit. All rights reserved.
//

#import "BannerViewController.h"
#import "ArticleApi.h"
#import "ArticleModel.h"
#import "HotCommentController.h"
#import "RelateNewsController.h"
#import "MediaController.h"

@interface BannerViewController ()
@property(nonatomic,strong,readwrite)UILabel *bannerView;
@property(nonatomic,strong,readwrite)ArticleApi *api;
@property(nonatomic,strong,readwrite)ArticleModel *articleModel;
@property(nonatomic,strong,readwrite)HotCommentController *commentController;
@end

@implementation BannerViewController
-(instancetype)init{
    self = [super initWithWebView:NO];
    if (self) {
        [self _getRemoteData];
    }
    return self;
}

- (void)dealloc{
    if (_api) {
        [_api cancel];
        _api = nil;
    }
}

-(void)viewDidLoad{
    [super viewDidLoad];
    [self.view addSubview:({
        _bannerView  = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 200.f)];
        _bannerView.backgroundColor = [UIColor whiteColor];
        _bannerView.textAlignment = NSTextAlignmentCenter;
        _bannerView.numberOfLines = 0;
        _bannerView.font = [UIFont systemFontOfSize:40.f];
        _bannerView.text = @"HybridPageKit \n BannerView";
        _bannerView.textColor = [UIColor colorWithRed:28.f/255.f green:135.f/255.f blue:219.f/255.f alpha:1.f];
        
        [_bannerView.layer addSublayer:({
            CALayer *bottomLine = [[CALayer alloc]init];
            bottomLine.frame = CGRectMake(0, _bannerView.bounds.size.height -1, _bannerView.bounds.size.width, 1.f);
            bottomLine.backgroundColor = [UIColor lightGrayColor].CGColor;
            bottomLine;
        })];
        
        _bannerView;
    })];
}

- (NSArray<NSObject<HPKComponentControllerDelegate> *> *)getValidComponentControllers{
    
    if (!_commentController) {
        _commentController = [[HotCommentController alloc]init];
    }
    
    return @[
             [[RelateNewsController alloc]init],
             _commentController,
             [[MediaController alloc]init]
             ];
}

-(void)_getRemoteData{
    __weak typeof(self) wself = self;
    _api = [[ArticleApi alloc]initWithApiType:kArticleApiTypeArticle completionBlock:^(NSDictionary *responseDic, NSError *error) {

        wself.articleModel = [[ArticleModel alloc]initWithDic:responseDic];

        [wself setArticleDetailModel:wself.articleModel
                      topInsetOffset:wself.bannerView.frame.origin.y + wself.bannerView.frame.size.height
                 extensionComponents:wself.articleModel.extensionComponents];

        [wself reLayoutExtensionComponents];
    }];
}
@end
