//
//  ListViewController.m
//  HybridPageKit
//
//  Created by dequanzhu.
//  Copyright © 2018 HybridPageKit. All rights reserved.
//

#import "ListViewController.h"
#import "DetailViewController.h"

#define HPKCollectionViewCellIdentifier @"ViewControllerCollectionViewCell"
@interface ListViewController ()<UICollectionViewDelegate , UICollectionViewDataSource>
@property(nonatomic,strong,readwrite) UICollectionView *collectionView;

@end
@implementation ListViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"HybridPageKit";
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:28.f/255.f green:135.f/255.f blue:219.f/255.f alpha:1.f];

    [self.view addSubview:({
        _collectionView = [[UICollectionView alloc]initWithFrame:self.view.bounds collectionViewLayout:[[UICollectionViewFlowLayout alloc] init]];
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 110000
        if ([_collectionView respondsToSelector:@selector(setContentInsetAdjustmentBehavior:)]) {
            if (@available(iOS 11.0, *)) {
                _collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            }
        }
#endif
        _collectionView.backgroundColor = [UIColor colorWithRed:238.f/255.f green:239.f/255.f blue:240.f/255.f alpha:1.f];;
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        [_collectionView registerClass:[UICollectionViewCell class]
            forCellWithReuseIdentifier:HPKCollectionViewCellIdentifier];
        _collectionView;
    })];
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [self.navigationController pushViewController:[[DetailViewController alloc] init] animated:YES];
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{
    for (UIView *subView in cell.contentView.subviews){
        if ([subView isKindOfClass:[UILabel class]]) {
            if (indexPath.row == 0) {
                [((UILabel *)subView) setText:@"  1.Only WebView"];
            } else if (indexPath.row == 1){
                [((UILabel *)subView) setText:@"  2.WebView With Native Element"];
            }else if (indexPath.row == 2){
                [((UILabel *)subView) setText:@"  3.Banner View With Native Element"];
            }
            break;
        }
    }
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 3;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:HPKCollectionViewCellIdentifier forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    
    BOOL hasTitle = NO;
    for (UIView *subView in cell.contentView.subviews){
        if ([subView isKindOfClass:[UILabel class]]) {
            hasTitle = YES;
            break;
        }
    }
    if (!hasTitle) {
        [cell.contentView addSubview:({
            UILabel *label = [[UILabel alloc] initWithFrame:cell.contentView.bounds];
            label;
        })];
    }
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake([[UIScreen mainScreen] bounds].size.width, 75);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 1.f;
}
@end
