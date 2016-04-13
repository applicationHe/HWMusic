//
//  HPlayView.m
//  HWMusic
//
//  Created by apple on 16/4/12.
//  Copyright © 2016年 he. All rights reserved.
//

#import "HPlayView.h"
#import <MediaPlayer/MediaPlayer.h>

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
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
    isPlaying = NO;
    MusicModel * model = self.dataSource[self.currentIndex];
    [self setModel:model];
    
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    [self becomeFirstResponder];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(listeningRemoteControl:) name:@"music" object:nil];
    
//    [self setBackImage];
}

-(void)listeningRemoteControl:(NSNotification *)sender
{
    NSDictionary * dict=sender.userInfo;
    NSInteger order=[[dict objectForKey:@"order"] integerValue];
    switch (order) {
            //暂停
        case UIEventSubtypeRemoteControlPause:
        {
           
            [self pauseStreamer];
            break;
        }
            //播放
        case UIEventSubtypeRemoteControlPlay:
        {
            
            [self playStreamer];
            break;
        }
            //暂停播放切换
        
            //下一首
        case UIEventSubtypeRemoteControlNextTrack:
        {
            [self playNextMusic];
            break;
        }
            //上一首
        case UIEventSubtypeRemoteControlPreviousTrack:
        {
            [self playPreMusic];
            break;
        }
        default:
            break;
    }
    
}

-(void)setlocakName
{
    NSMutableDictionary * songDict=[NSMutableDictionary dictionary];
    if (NSClassFromString(@"MPNowPlayingInfoCenter")) {
        MusicModel * model = self.dataSource[self.currentIndex];
    //歌名
    [songDict setObject:model.name forKey:MPMediaItemPropertyTitle];
    //歌手名
    [songDict setObject:@"何万牡" forKey:MPMediaItemPropertyArtist];
    //歌曲的总时间
    [songDict setObject:[NSNumber numberWithDouble:CMTimeGetSeconds(self.playerItem.duration)] forKeyedSubscript:MPMediaItemPropertyPlaybackDuration];
    //设置歌曲图片
    MPMediaItemArtwork *imageItem=[[MPMediaItemArtwork alloc]initWithImage:[UIImage imageNamed:@"default.jpg"]];
    [songDict setObject:imageItem forKey:MPMediaItemPropertyArtwork];
    //设置控制中心歌曲信息
    [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:songDict];
        
    }
    
}

-(void)setModel:(MusicModel *)model
{
    self.titleLabel.text = model.name;
    self.playerItem = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:model.url]];
    [self.helper.aPlayer replaceCurrentItemWithPlayerItem:self.playerItem];
    self.playerTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(handleActionTime:)userInfo:self.playerItem repeats:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerItemAction:) name:AVPlayerItemDidPlayToEndTimeNotification object:self.playerItem];
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
        _titleLabel.textColor = RGB(117, 46, 136);
        _titleLabel.lineBreakMode = NSLineBreakByCharWrapping;
        _titleLabel.font = [UIFont boldSystemFontOfSize:17];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

-(void)clicked:(id)sender
{
    isPlaying = !isPlaying;
    if (isPlaying) {
        [self.helper.aPlayer play];
        [self setlocakName];
        [self.bgView.layer addAnimation:_ani forKey:@"xuan"];
        self.playerTimer.fireDate = [NSDate date];
    }else
    {
        [self.helper.aPlayer pause];
        [self.bgView.layer removeAnimationForKey:@"xuan"];
        self.playerTimer.fireDate = [NSDate distantFuture];
    }
}

-(void)goMusic:(id)sender
{
    [self.playerTimer invalidate];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.currentItem = nil;
        self.playerItem = nil;
        self.currentIndex ++;
        NSLog(@"%ld",self.currentIndex);
        if (self.currentIndex == self.dataSource.count) {
            self.currentIndex = 0;
        }
        MusicModel * model = self.dataSource[self.currentIndex];
        [self setModel:model];
    });
}
- (void)playerItemAction:(AVPlayerItem *)item {
    [self.playerTimer invalidate];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.currentItem = nil;
        self.playerItem = nil;
        self.currentIndex ++;
        NSLog(@"%ld",self.currentIndex);
        if (self.currentIndex == self.dataSource.count) {
            self.currentIndex = 0;
        }
        MusicModel * model = self.dataSource[self.currentIndex];
        [self setModel:model];
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

-(void)didBecomeActive
{
    if (isPlaying) {
       [self.bgView.layer addAnimation:_ani forKey:@"xuan"];
    }
}

-(void)pauseStreamer
{
    [self.helper.aPlayer pause];
    [self.bgView.layer removeAnimationForKey:@"xuan"];
    self.playerTimer.fireDate = [NSDate distantFuture];
}

-(void)playStreamer
{
    [self.helper.aPlayer play];
    [self setlocakName];
    [self.bgView.layer addAnimation:_ani forKey:@"xuan"];
    self.playerTimer.fireDate = [NSDate date];
}

-(void)playNextMusic
{
    [self.playerTimer invalidate];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.currentItem = nil;
        self.playerItem = nil;
        self.currentIndex ++;
        NSLog(@"%ld",self.currentIndex);
        if (self.currentIndex == self.dataSource.count) {
            self.currentIndex = 0;
        }
        MusicModel * model = self.dataSource[self.currentIndex];
        [self setModel:model];
        [self setlocakName];
    });
//    MPMediaItemArtwork 
}

-(void)playPreMusic
{
    [self.playerTimer invalidate];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.currentItem = nil;
        self.playerItem = nil;
        self.currentIndex --;
        NSLog(@"%ld",self.currentIndex);
        if (self.currentIndex == -1) {
            self.currentIndex = self.dataSource.count-1;
        }
        MusicModel * model = self.dataSource[self.currentIndex];
        [self setModel:model];
        [self setlocakName];
    });
}

@end
