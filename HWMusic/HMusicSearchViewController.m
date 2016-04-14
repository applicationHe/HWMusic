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
}
@end

@implementation HMusicSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _dataSource = [[NSMutableArray alloc] init];

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
    return _dataSource.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MusicDownCell * cell = [tableView dequeueReusableCellWithIdentifier:CELLIDENTIFIER forIndexPath:indexPath];
    return cell;
}

#pragma mark - Help

-(void)down:(NSNotification *)no
{
    NSLog(@"%@",[no.userInfo objectForKey:@"url"]);
}



@end
