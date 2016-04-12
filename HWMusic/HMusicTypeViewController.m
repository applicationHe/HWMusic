//
//  HMusicTypeViewController.m
//  HWMusic
//
//  Created by admin on 16/4/9.
//  Copyright © 2016年 he. All rights reserved.
//

#import "HMusicTypeViewController.h"
#import "MusicTypeCell.h"
#import "HPlayView.h"

#define CELLID @"musictypecell"

@interface HMusicTypeViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView * _tableView;
    NSMutableArray * _dataSource;
}
@end

@implementation HMusicTypeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _dataSource = [[NSMutableArray alloc] init];
    
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-114)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    [self.view addSubview:_tableView];
    [_tableView registerClass:[MusicTypeCell class] forCellReuseIdentifier:CELLID];
    
    [self fetchDataFromNetwork];
}

-(void)viewWillAppear:(BOOL)animated
{
    HPlayView * playView = [HPlayView sharePlayView];
    playView.frame = CGRectMake(SCREEN_WIDTH-110, 10, 100, 100);
    playView.layer.cornerRadius = 50.0f;
    playView.layer.masksToBounds = YES;
    [playView initUI];
    [self.view addSubview:playView];
}

#pragma mark - UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataSource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MusicTypeCell * cell = [tableView dequeueReusableCellWithIdentifier:CELLID forIndexPath:indexPath];
    if (_dataSource.count!=0) {
        MusicTypeModel * model = _dataSource[indexPath.row];
        [cell initUIWith:model];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 200.0f;
}

#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark - Help Handle
/**
 *  获取数据源
 */
-(void)fetchDataFromNetwork
{
    NSString * path = [[NSBundle mainBundle] pathForResource:@"musicType" ofType:@"plist"];
    NSArray * array = [NSArray arrayWithContentsOfFile:path];
    for (NSDictionary * dict in array) {
        MusicTypeModel * model = [[MusicTypeModel alloc] initWithDictionary:dict];
        [_dataSource addObject:model];
    }
    [_tableView reloadData];
}


@end
