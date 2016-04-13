//
//  PlayerHelper.m
//  HWMusic
//
//  Created by apple on 16/4/12.
//  Copyright © 2016年 he. All rights reserved.
//

#import "PlayerHelper.h"

@implementation PlayerHelper

+(instancetype)sharePalyerHelper
{
    static PlayerHelper * helper = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        helper = [[PlayerHelper alloc] init];
    });
    return helper;
}

-(instancetype)init
{
    if (self = [super init]) {
        self.aPlayer = [[AVQueuePlayer alloc] init];
    }
    AVAudioSession * session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    [session setActive:YES error:nil];
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    return self;
}

@end
