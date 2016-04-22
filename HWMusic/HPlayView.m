//
//  HPlayView.m
//  HWMusic
//
//  Created by apple on 16/4/12.
//  Copyright © 2016年 he. All rights reserved.
//

#import "HPlayView.h"
#import "HSDownloadManager/HSDownloadManager.h"
#import "NSString+Hash.h"
#import <MediaPlayer/MediaPlayer.h>
#import "MusicImageView.h"

@implementation HPlayView
{
//    BOOL isPlaying;
    CAKeyframeAnimation * _ani;
    HSDownloadManager * _downManager;
    MusicImageView * _imageView;
    NSTimer *_timer;
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
    _downManager = [HSDownloadManager sharedInstance];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
    self.isPlaying = NO;
    MusicModel * model = self.dataSource[self.currentIndex];
    [self setModel:model];
    
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    [self becomeFirstResponder];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(listeningRemoteControl:) name:@"music" object:nil];
    _imageView = [[MusicImageView alloc] initWithFrame:CGRectMake(-250, -250, 250, 250)];
    _imageView.imageName = @"default";
    _imageView.text = @"我呵呵呵呵呵呵";
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(imageChange:) name:@"123" object:nil];
    [self addSubview:_imageView];
    _timer = [NSTimer scheduledTimerWithTimeInterval:3.0f target:self selector:@selector(changetext:) userInfo:nil repeats:YES];
    _timer.fireDate = [NSDate distantFuture];
//    [self setBackImage];
}

-(void)changetext:(id)sender
{
    static int time;
    time +=1;
    NSLog(@"时间:%d",time);
    if (time%3==0) {
        [_imageView removeFromSuperview];
        _imageView = [[MusicImageView alloc] initWithFrame:CGRectMake(-250, -250, 250, 250)];
        _imageView.text = @"我去去去去秋千";
         _imageView.imageName = @"default";
        [self addSubview:_imageView];
    }else if (time%3==1)
    {
        [_imageView removeFromSuperview];
        _imageView = [[MusicImageView alloc] initWithFrame:CGRectMake(-250, -250, 250, 250)];
        _imageView.text = @"我擦啊擦擦擦擦";
         _imageView.imageName = @"default";
        [self addSubview:_imageView];
    }else
    {
        [_imageView removeFromSuperview];
        _imageView = [[MusicImageView alloc] initWithFrame:CGRectMake(-250, -250, 250, 250)];
        _imageView.text = @"我呵呵呵呵呵呵";
         _imageView.imageName = @"default";
        [self addSubview:_imageView];
    }
    
}

-(void)imageChange:(id)sender
{
    [self setlocakName];
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
        case UIEventSubtypeRemoteControlTogglePlayPause:
        {
            [self playNextMusic];
            break;
        }
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
    [songDict setObject:[NSNumber numberWithDouble:CMTimeGetSeconds(self.playerItem.duration)] forKey:MPMediaItemPropertyPlaybackDuration];
//        [songDict setObject:[NSNumber numberWithFloat:1.22f] forKeyedSubscript:MPNowPlayingInfoPropertyElapsedPlaybackTime];
        [songDict setObject:[NSNumber numberWithDouble:CMTimeGetSeconds(self.playerItem.currentTime)] forKey:MPNowPlayingInfoPropertyElapsedPlaybackTime];
    //设置歌曲图片
//    UIImage * image = [self addText:_imageView.myimage text:@"我感动天,感动地"];
    MPMediaItemArtwork *imageItem=[[MPMediaItemArtwork alloc]initWithImage:_imageView.myimage];
    [songDict setObject:imageItem forKey:MPMediaItemPropertyArtwork];
    //设置控制中心歌曲信息
    [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:songDict];
        
    }
    
}

-(void)setModel:(MusicModel *)model
{
    self.titleLabel.text = model.name;
    BOOL isdown = [_downManager isCompletion:model.url];
    if (isdown) {
        NSString * path = (NSString *)HSFileFullpath(model.url);
        NSLog(@"缓存路径====%@",path);
//        AVQueuePlayer * player = [[AVQueuePlayer alloc] initWithURL:[NSURL fileURLWithPath:path]];
        self.playerItem = [AVPlayerItem playerItemWithURL:[[NSURL alloc] initFileURLWithPath:path]];
        AVQueuePlayer * player = [AVQueuePlayer playerWithURL:[NSURL fileURLWithPath:path]];
//        [self.helper.aPlayer ]
        self.helper.aPlayer = player;
    }else
    {
         self.playerItem = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:model.url]];
    }
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
        self.isPlaying = NO;
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
    self.isPlaying = !self.isPlaying;
    if (self.isPlaying) {
        [self.helper.aPlayer play];
        _timer.fireDate = [NSDate distantPast];
        [self setlocakName];
        [self.bgView.layer addAnimation:_ani forKey:@"xuan"];
        self.playerTimer.fireDate = [NSDate date];
    }else
    {
        [self.helper.aPlayer pause];
        _timer.fireDate = [NSDate distantFuture];
        [self.bgView.layer removeAnimationForKey:@"xuan"];
        self.playerTimer.fireDate = [NSDate distantFuture];
    }
}

-(void)goMusic:(id)sender
{
    if ([self performSelector:@selector(goMusic)]) {
        [self.delegate goMusic];
    }
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
    if (self.isPlaying) {
       [self.bgView.layer addAnimation:_ani forKey:@"xuan"];
    }
}

-(void)pauseStreamer
{
    [self.helper.aPlayer pause];
    _timer.fireDate  = [NSDate distantFuture];
    self.isPlaying = NO;
    [self.bgView.layer removeAnimationForKey:@"xuan"];
    self.playerTimer.fireDate = [NSDate distantFuture];
}

-(void)playStreamer
{
    [self.helper.aPlayer play];
    _timer.fireDate = [NSDate distantPast];
    [self setlocakName];
    self.isPlaying = YES;
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
