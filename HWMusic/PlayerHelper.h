//
//  PlayerHelper.h
//  HWMusic
//
//  Created by apple on 16/4/12.
//  Copyright © 2016年 he. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface PlayerHelper : NSObject

@property (nonatomic,strong)AVQueuePlayer * aPlayer;

+(instancetype)sharePalyerHelper;

@end
