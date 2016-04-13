//
//  AppDelegate.m
//  HWMusic
//
//  Created by admin on 16/4/9.
//  Copyright © 2016年 he. All rights reserved.
//

#import "AppDelegate.h"
#import "HMainViewController.h"
#import "HNavigationController.h"

//#import <>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    _window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _window.backgroundColor = [UIColor whiteColor];
    [_window makeKeyAndVisible];
    HMainViewController * mainVC = [[HMainViewController alloc] init];
    HNavigationController * nav = [[HNavigationController alloc] initWithRootViewController:mainVC];
    _window.rootViewController = nav;
//    [self setLock];
    [[UIApplication sharedApplication]beginReceivingRemoteControlEvents];
    return YES;
}

-(void)setLock
{
//    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    
//    MusicModel * model = self.dataSource[self.currentIndex];
//    //歌曲名称
//    [dict setObject:model.name forKey:MPMediaItemPropertyTitle];
//    
//    //演唱者
//    [dict setObject:@"何万牡" forKey:MPMediaItemPropertyArtist];
    
    //专辑名
    //[dict setObject:[info ObjectNullForKey:@"album"] forKey:MPMediaItemPropertyAlbumTitle];
    
    //专辑缩略图
    //    NSString *imagePath = [info ObjectNullForKey:@"thumb"];
    //    imagePath = [NSString stringWithFormat:@"EGOImageLoader-%lu", (unsigned long)[[imagePath description] hash]];
    //    NSString *imageLocalPath = [NSString stringWithFormat:@"%@/%@", EGOCacheDirectory(),imagePath];
    
    //    NSData * thumbData = [NSData dataWithContentsOfFile:imageLocalPath];
    
    //    if (thumbData != nil) {
//    UIImage *image = [UIImage imageNamed:@""];
//    MPMediaItemArtwork *artwork = [[MPMediaItemArtwork alloc] initWithImage:image];
//    [dict setObject:artwork forKey:MPMediaItemPropertyArtwork];
//    //    }else
//    //    {
//    //        // FIXME: 无图的时候，读取图
//    //
//    //    }
//    //音乐剩余时长
//    [dict setObject:[NSNumber numberWithDouble:self.audioPlayer.duration] forKey:MPMediaItemPropertyPlaybackDuration];
//    
//    //音乐当前播放时间 在计时器中修改
//    [dict setObject:[NSNumber numberWithDouble:self.audioPlayer.progress] forKey:MPNowPlayingInfoPropertyElapsedPlaybackTime];
//    
//    //设置锁屏状态下屏幕显示播放音乐信息
//    //DLog(@"显示播放音乐信息：%@\n%@",dict,[info ObjectNullForKey:@"title"]);
//    
//    [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:dict];
}

-(void)remoteControlReceivedWithEvent:(UIEvent *)event
{
    if(event.type==UIEventTypeRemoteControl)
    {
        NSInteger order=-1;
        switch (event.subtype) {
            case UIEventSubtypeRemoteControlPause:
                order=UIEventSubtypeRemoteControlPause;
                break;
            case UIEventSubtypeRemoteControlPlay:
                order=UIEventSubtypeRemoteControlPlay;
                break;
            case UIEventSubtypeRemoteControlNextTrack:
                order=UIEventSubtypeRemoteControlNextTrack;
                break;
            case UIEventSubtypeRemoteControlPreviousTrack:
                order=UIEventSubtypeRemoteControlPreviousTrack;
                break;
            case UIEventSubtypeRemoteControlTogglePlayPause:
                order=UIEventSubtypeRemoteControlTogglePlayPause;
                break;
            default:
                order=-1;
                break;
        }
        NSDictionary * orderDict=@{@"order":@(order)};
        [[NSNotificationCenter defaultCenter] postNotificationName:@"music" object:nil userInfo:orderDict];
    }
    
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
