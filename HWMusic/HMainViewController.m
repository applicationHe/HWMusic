//
//  HMainViewController.m
//  HWMusic
//
//  Created by admin on 16/4/9.
//  Copyright © 2016年 he. All rights reserved.
//

#import "HMainViewController.h"
#import "SwipeView.h"
#import "VCHeader.h"

@interface HMainViewController ()<SwipeViewDataSource,SwipeViewDelegate>
{
    NSMutableArray * _btnArr;
    NSArray * _titleArr;
    SwipeView * _swipeView;
    NSArray * _items;
}
@end

@implementation HMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title  = @"音库";
    _btnArr = [[NSMutableArray alloc] init];
    [self createUI];
    UIButton * btn = _btnArr[0];
    [btn setTitleColor:RGB(242, 50, 84) forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont boldSystemFontOfSize:19];
}

#pragma mark - SwipeViewDataSource
- (NSInteger)numberOfItemsInSwipeView:(SwipeView *)swipeView
{
    return _items.count;
}
- (UIView *)swipeView:(SwipeView *)swipeView viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    return [_items[index] view];
}
-(CGSize)swipeViewItemSize:(SwipeView *)swipeView
{
    return _swipeView.bounds.size;
}
#pragma mark - SwipeViewDelegate
-(void)swipeViewDidScroll:(SwipeView *)swipeView
{
    UIButton * button = _btnArr[swipeView.currentItemIndex];
    for (UIButton * btn in _btnArr) {
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:18];
    }
    self.title = _titleArr[button.tag];
    [UIView animateWithDuration:0.2f animations:^{
        [button setTitleColor:RGB(242, 50, 84) forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont boldSystemFontOfSize:19];
    }];
}

#pragma mark - Event

-(void)chooseIndex:(UIButton *)button
{
    _swipeView.currentItemIndex = button.tag;
    for (UIButton * btn in _btnArr) {
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:18];
    }
    self.title = _titleArr[button.tag];
    [UIView animateWithDuration:0.2f animations:^{
        [button setTitleColor:RGB(242, 50, 84) forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont boldSystemFontOfSize:19];
    }];
}

#pragma mark - Help Handle
-(void)createUI
{
    _titleArr = @[@"音库",@"热听",@"搜索",@"我的"];
    for (int i=0; i<_titleArr.count; i++) {
        UIButton * button = [[UIButton alloc] initWithFrame:CGRectMake(i*SCREEN_WIDTH/4.0f, SCREEN_HEIGHT-64-50, SCREEN_WIDTH/4.0f, 50)];
        button.backgroundColor = RGB(117, 46, 136);
        [button setTitle:_titleArr[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:18];
        button.tag = i;
        [button addTarget:self action:@selector(chooseIndex:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
        [_btnArr addObject:button];
    }
    
    
    _swipeView = [[SwipeView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64-50)];
    [self.view addSubview:_swipeView];
    _swipeView.delegate = self;
    _swipeView.dataSource = self;
    _swipeView.pagingEnabled = YES;
    _swipeView.wrapEnabled = YES;
    [self setSwipeViews];
    [_swipeView reloadData];
}

-(void)setSwipeViews
{
    HMusicTypeViewController * typeVC = [[HMusicTypeViewController alloc] init];
    HMusicHotViewController * hotVC = [[HMusicHotViewController alloc] init];
    HMusicSearchViewController * searchVC = [[HMusicSearchViewController alloc] init];
    HMineViewController * mineVC = [[HMineViewController alloc] init];
    _items = @[typeVC,hotVC,searchVC,mineVC];
}

@end
