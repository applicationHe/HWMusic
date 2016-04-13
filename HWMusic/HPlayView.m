//
//  HPlayView.m
//  HWMusic
//
//  Created by apple on 16/4/12.
//  Copyright © 2016年 he. All rights reserved.
//

#import "HPlayView.h"

@implementation HPlayView
{
    BOOL isPlaying;
    CAKeyframeAnimation * _ani;
}
+(instancetype)sharePlayView
{
    static HPlayView * playView = nil;
    static dispatch_once_t  predicate;
    dispatch_once(&predicate, ^{
        playView = [[HPlayView alloc] init];
    });
    return playView;
}

-(NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc] init];
        NSString * path = [[NSBundle mainBundle] pathForResource:@"MusicList" ofType:@"plist"];
        NSArray * arr = [NSArray arrayWithContentsOfFile:path];
        for (NSDictionary * dict in arr) {
            MusicModel * model = [[MusicModel alloc] initWithDictionary:dict];
            [_dataSource addObject:model];
        }
    }
    return _dataSource;
}

-(PlayerHelper *)helper
{
    if (!_helper) {
        _helper = [PlayerHelper sharePalyerHelper];
    }
    return _helper;
}

-(void)initUI
{
    [self addSubview:self.bgView];
    [self addSubview:self.titleLabel];
    self.currentIndex = 0;
    [self createAni];
}

-(void)play
{
    isPlaying = YES;
    [self.bgView.layer addAnimation:_ani forKey:@"xuan"];
    MusicModel * model = self.dataSource[self.currentIndex];
    self.titleLabel.text = model.name;
    self.playerItem = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:model.url]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerItemAction:) name:AVPlayerItemDidPlayToEndTimeNotification object:self.playerItem];
    [self.helper.aPlayer replaceCurrentItemWithPlayerItem:self.playerItem];
    [self.helper.aPlayer play];
    self.playerTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(handleActionTime:) userInfo:_playerItem repeats:YES];
}

-(void)stop
{
    isPlaying = NO;
    [self.helper.aPlayer pause];
    [self.bgView.layer removeAnimationForKey:@"xuan"];
}

-(UIImageView *)bgView
{
    if (!_bgView) {
        _bgView = [[UIImageView alloc] init];
        [self addSubview:_bgView];
        _bgView.backgroundColor = [UIColor redColor];
        _bgView.image = [UIImage imageNamed:@"default"];
        isPlaying = NO;
        UITapGestureRecognizer * tgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clicked:)];
        _bgView.userInteractionEnabled = YES;
        [_bgView addGestureRecognizer:tgr];
        UITapGestureRecognizer * doubletgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goMusic:)];
        doubletgr.numberOfTapsRequired = 2;
        [_bgView addGestureRecognizer:doubletgr];
        [tgr requireGestureRecognizerToFail:doubletgr];
        
        __weak typeof(self)weakSelf = self;
        [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(weakSelf).insets(UIEdgeInsetsMake(0, 0, 0, 0));
        }];
    }
    return _bgView;
}

-(UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 40, 80, 20)];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.font = [UIFont systemFontOfSize:14];
    }
    return _titleLabel;
}

-(void)clicked:(id)sender
{
    isPlaying = !isPlaying;
    if (isPlaying) {
        [self play];
    }else
    {
        [self stop];
    }
}

-(void)goMusic:(id)sender
{
    if ([self respondsToSelector:@selector(goMusic)]) {
        [self.delegate goMusic];
    }
}
- (void)playerItemAction:(AVPlayerItem *)item {
    [self.playerTimer invalidate];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.playerItem = nil;
        self.currentIndex ++;
        if (self.currentIndex == self.dataSource.count) {
            self.currentIndex = 0;
        }
        [self play];
    });
}

-(void)handleActionTime:(NSTimer *)timer
{
    AVPlayerItem * newItem = (AVPlayerItem *)timer.userInfo;
    if ([newItem status] == AVPlayerStatusReadyToPlay) {
        self.currentItem = newItem;
    }
}

-(void)createAni
{
    _ani = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation.z"];
    NSMutableArray * muArr = [[NSMutableArray alloc] init];
    for (int i=0; i<7; i++) {
        CGFloat rould = M_PI/180.0f*i*60;
        NSNumber * number = [NSNumber numberWithFloat:rould];
        [muArr addObject:number];
    }
    _ani.values = muArr;
    _ani.repeatCount = MAXFLOAT;
    _ani.duration = 2.0f;
}

@end
