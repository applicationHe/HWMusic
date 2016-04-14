//
//  HMusicHotViewController.m
//  HWMusic
//
//  Created by admin on 16/4/9.
//  Copyright © 2016年 he. All rights reserved.
//

#import "HMusicHotViewController.h"
#import "MusicHotCell.h"

#define CELLIDENTIFIER @"cell"

@interface HMusicHotViewController ()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>
{
    UITableView * _tableView;
    NSMutableArray * _dataSource;
    UIButton * _leftBtn;
    BOOL isediting;
    HManger * _manager;
}
@end

@implementation HMusicHotViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _manager = [HManger shareManager];
    isediting = NO;
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-114)];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [_tableView registerClass:[MusicHotCell class] forCellReuseIdentifier:CELLIDENTIFIER];
    [self.view addSubview:_tableView];
    _tableView.tableFooterView = [[UIView alloc] init];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _dataSource = [[NSMutableArray alloc] init];
    [self fetchDataFromNetwork];
    _leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 40)];
    [_leftBtn setTitle:@"编辑" forState:UIControlStateNormal];
    _leftBtn.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    [_leftBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_leftBtn addTarget:self action:@selector(edit:) forControlEvents:UIControlEventTouchUpInside];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.superVC.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_leftBtn];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.superVC.navigationItem.rightBarButtonItem = nil;
}

#pragma mark - UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataSource.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0f;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MusicHotCell * cell = [tableView dequeueReusableCellWithIdentifier:CELLIDENTIFIER forIndexPath:indexPath];
    if (_dataSource.count!=0) {
        MusicModel * model = _dataSource[indexPath.row];
        [cell initUIWithDataSource:model];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
#pragma mark - UITableViewDelegate
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

-(NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewRowAction *layTopRowAction1 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        NSLog(@"点击了删除");
        [_dataSource removeObjectAtIndex:indexPath.row];
        [_tableView reloadData];
//        [tableView setEditing:NO animated:YES];
    }];
    layTopRowAction1.backgroundColor = [UIColor redColor];
    
    UITableViewRowAction *layTopRowAction2 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"下载" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        NSLog(@"点击了下载");
        MusicModel * model = _dataSource[indexPath.row];
        [_manager.downArray addObject:model];
        NSDictionary * dict = @{@"url":model.url,@"name":model.name};
        NSNotification * no = [NSNotification notificationWithName:@"down" object:nil userInfo:dict];
        [[NSNotificationCenter defaultCenter] postNotification:no];
//        [tableView setEditing:NO animated:YES];
        
    }];
    layTopRowAction2.backgroundColor = [UIColor blueColor];
    
    NSArray *arr = @[layTopRowAction1,layTopRowAction2];
    return arr;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    _tableView.editing = YES;
}

#pragma mark - Event
-(void)edit:(id)sender
{
    isediting = !isediting;
    if (isediting) {
        _tableView.editing = YES;
        [_leftBtn setTitle:@"完成" forState:UIControlStateNormal];
    }else
    {
        _tableView.editing = NO;
        [_leftBtn setTitle:@"编辑" forState:UIControlStateNormal];
    }
}



#pragma mark - Help Handle
-(void)fetchDataFromNetwork
{
    NSString * path = [[NSBundle mainBundle] pathForResource:@"MusicList" ofType:@"plist"];
    NSArray * array = [NSArray arrayWithContentsOfFile:path];
    [_dataSource removeAllObjects];
    for (NSDictionary * dict in array) {
        MusicModel * model = [[MusicModel alloc] initWithDictionary:dict];
        [_dataSource addObject:model];
    }
}

@end
