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

-(void)initUI
{
    [self addSubview:self.bgView];
}

-(void)play
{
    isPlaying = YES;
    self.playerItem = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:@""]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerItemAction:) name:AVPlayerItemDidPlayToEndTimeNotification object:_playerItem];
    PlayerHelper * helper = [PlayerHelper sharePalyerHelper];
    [helper.aPlayer replaceCurrentItemWithPlayerItem:_playerItem];
    [helper.aPlayer play];
    self.playerTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(handleActionTime:) userInfo:_playerItem repeats:YES];
}

-(void)stop
{
    isPlaying = NO;
    
}

-(UIView *)bgView
{
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        [self addSubview:_bgView];
        _bgView.backgroundColor = [UIColor redColor];
        isPlaying = NO;
        UITapGestureRecognizer * tgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clicked:)];
        _bgView.userInteractionEnabled = YES;
        [_bgView addGestureRecognizer:tgr];
        __weak typeof(self)weakSelf = self;
        [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(weakSelf).insets(UIEdgeInsetsMake(0, 0, 0, 0));
        }];
    }
    return _bgView;
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
- (void)playerItemAction:(AVPlayerItem *)item {
    [self.playerTimer invalidate];
}

-(void)handleActionTime:(NSTimer *)timer
{
    AVPlayerItem * newItem = (AVPlayerItem *)timer.userInfo;
    if ([newItem status] == AVPlayerStatusReadyToPlay) {
        self.currentItem = newItem;
    }
}

@end
