//
//  HotCommentView.m
//  HybridPageKit
//
//  Created by dequanzhu.
//  Copyright © 2018 HybridPageKit. All rights reserved.
//

#import "HotCommentView.h"

@interface HotCommentView()<UITableViewDelegate, UITableViewDataSource>
@property(nonatomic,strong,readwrite)UITableView *tableView;
@property(nonatomic,copy,readwrite)NSArray *hotCommentData;
@end

@implementation HotCommentView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:({
            _tableView =  [[UITableView alloc]init];
            _tableView.delegate = self;
            _tableView.dataSource = self;
            _tableView;
        })];
    }
    return self;
}

-(void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    _tableView.frame = self.bounds;
    [_tableView reloadData];
}

-(void)layoutWithData:(HotCommentModel *)hotCommentModel{
    
    if (hotCommentModel == nil || hotCommentModel.HotCommentArray == nil) {
        return;
    }
    
    _hotCommentData = [hotCommentModel.HotCommentArray copy];
    [_tableView reloadData];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    cell.textLabel.text = [_hotCommentData objectAtIndex:indexPath.row];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return kHotCommentViewCellHeight;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _hotCommentData.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HotCommentView"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"HotCommentView"];
    }
    return cell;
}

@end
