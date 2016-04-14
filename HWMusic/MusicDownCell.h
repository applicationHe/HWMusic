//
//  MusicDownCell.h
//  HWMusic
//
//  Created by apple on 16/4/14.
//  Copyright © 2016年 he. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MusicDownCell : UITableViewCell

@property (nonatomic,strong)UIProgressView * progress;

@property (nonatomic,strong)UILabel * nameLabel;

@property (nonatomic,strong)UILabel * scaleLabel;

-(void)initUIWithDataSource:(MusicModel *)model;

@end
