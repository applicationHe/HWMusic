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
#import "HPlayView.h"

@interface HMainViewController ()<SwipeViewDataSource,SwipeViewDelegate,UIGestureRecognizerDelegate>
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

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    HPlayView * playView = [HPlayView sharePlayView];
    playView.frame = CGRectMake(SCREEN_WIDTH-110, 10, 100, 100);
    playView.layer.cornerRadius = 50.0f;
    playView.layer.masksToBounds = YES;
    [playView initUI];
    [self.view addSubview:playView];
    UIPanGestureRecognizer * pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(move:)];
    [playView addGestureRecognizer:pan];
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
//    if (swipeView.currentItemIndex==1) {
//        self.navigationItem.rightBarButtonItem = nil;
//    }
    
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

-(void)swipeViewWillBeginDragging:(SwipeView *)swipeView
{
    if (swipeView.currentItemIndex==1) {
        self.navigationItem.rightBarButtonItem = nil;
    }
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
    _titleArr = @[@"音库",@"播放列表",@"下载",@"我的"];
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
    hotVC.superVC = self;
    HMusicSearchViewController * searchVC = [[HMusicSearchViewController alloc] init];
    HMineViewController * mineVC = [[HMineViewController alloc] init];
    _items = @[typeVC,hotVC,searchVC,mineVC];
}

-(void)move:(UIPanGestureRecognizer *)recognizer
{
    CGPoint translation = [recognizer translationInView:self.view];
    recognizer.view.center = CGPointMake(recognizer.view.center.x + translation.x,
                                         recognizer.view.center.y + translation.y);
    [recognizer setTranslation:CGPointZero inView:self.view];
    
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        
        CGPoint velocity = [recognizer velocityInView:self.view];
        CGFloat magnitude = sqrtf((velocity.x * velocity.x) + (velocity.y * velocity.y));
        CGFloat slideMult = magnitude / 200;
        NSLog(@"magnitude: %f, slideMult: %f", magnitude, slideMult);
        
        float slideFactor = 0.1 * slideMult; // Increase for more of a slide
        CGPoint finalPoint = CGPointMake(recognizer.view.center.x + (velocity.x * slideFactor),
                                         recognizer.view.center.y + (velocity.y * slideFactor));
        finalPoint.x = MIN(MAX(finalPoint.x, 0), self.view.bounds.size.width);
        finalPoint.y = MIN(MAX(finalPoint.y, 0), self.view.bounds.size.height);
        
        [UIView animateWithDuration:slideFactor*2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            recognizer.view.center = finalPoint;
            HPlayView * playView = [HPlayView sharePlayView];
            playView.center = finalPoint;
        } completion:nil];
        
    }
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    NSLog(@"%@", NSStringFromClass([touch.view class]));
    
    // 若为UITableViewCellContentView（即点击了tableViewCell），则不截获Touch事件
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        return YES;
    }
    return NO;
}

@end
