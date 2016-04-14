//
//  MusicHotCell.h
//  HWMusic
//
//  Created by apple on 16/4/14.
//  Copyright © 2016年 he. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MusicHotCell : UITableViewCell

@property (nonatomic,strong)UILabel * nameLabel;

@property (nonatomic,strong)UILabel * authorLabel;

@property (nonatomic,strong)UIView * bgView;

-(void)initUIWithDataSource:(MusicModel *)model;

@end
