//
//  HMusicSearchViewController.m
//  HWMusic
//
//  Created by admin on 16/4/9.
//  Copyright © 2016年 he. All rights reserved.
//

#import "HMusicSearchViewController.h"
#import "MusicDownCell.h"

#define CELLIDENTIFIER @"cell"

@interface HMusicSearchViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView * _tableView;
    NSMutableArray * _dataSource;
    HManger * _manager;
}
@end

@implementation HMusicSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _dataSource = [[NSMutableArray alloc] init];
    _manager = [HManger shareManager];
    
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-114)];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [_tableView setTableFooterView:[UIView new]];
    [_tableView registerClass:[MusicDownCell class] forCellReuseIdentifier:CELLIDENTIFIER];
    [self.view addSubview:_tableView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(down:) name:@"down" object:nil];
    
}

#pragma mark - UITableViewDataSource And TableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _manager.downArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MusicDownCell * cell = [tableView dequeueReusableCellWithIdentifier:CELLIDENTIFIER forIndexPath:indexPath];
    if (_manager.downArray.count!=0) {
        MusicModel * model = _manager.downArray[indexPath.row];
        [cell initUIWithDataSource:model];
    }
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55.0f;
}

#pragma mark - Help

-(void)down:(NSNotification *)no
{
    NSLog(@"%@",[no.userInfo objectForKey:@"url"]);
    [_tableView reloadData];
}



@end
