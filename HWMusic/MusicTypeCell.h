//
//  MusicTypeCell.h
//  HWMusic
//
//  Created by apple on 16/4/11.
//  Copyright © 2016年 he. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MusicTypeCell : UITableViewCell

@property (nonatomic,strong)UIImageView * photoImageView;

@property (nonatomic,strong)UILabel * titleLabel;

-(void)initUI;

@end
