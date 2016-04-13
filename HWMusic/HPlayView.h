//
//  HPlayView.h
//  HWMusic
//
//  Created by apple on 16/4/12.
//  Copyright © 2016年 he. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "PlayerHelper.h"

@protocol PlayDelegate <NSObject>

-(void)goMusic;

@end


@interface HPlayView : UIView

@property (nonatomic,assign)CGPoint center;

@property (nonatomic,strong)UIImageView * bgView;

@property (nonatomic,strong)AVPlayerItem * playerItem;

@property (nonatomic,strong)AVPlayerItem * currentItem;

@property (nonatomic,assign)NSInteger currentIndex;

@property (nonatomic,strong)NSTimer * playerTimer;

@property (nonatomic,strong)NSMutableArray * dataSource;

@property (nonatomic,strong)UILabel * titleLabel;

@property (nonatomic,strong)PlayerHelper * helper;

@property (nonatomic,weak)id<PlayDelegate>delegate;

+(instancetype)sharePlayView;

-(void)initUI;


@end
