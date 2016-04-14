//
//  MusicHotCell.m
//  HWMusic
//
//  Created by apple on 16/4/14.
//  Copyright © 2016年 he. All rights reserved.
//

#import "MusicHotCell.h"

@implementation MusicHotCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)initUIWithDataSource:(MusicModel *)model
{
    self.nameLabel.text = model.name;
    self.authorLabel.text = @"何万牡";
}

-(UILabel *)nameLabel
{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(38, 8, self.bounds.size.width-46, 20)];
        _nameLabel.font = [UIFont boldSystemFontOfSize:16];
        [self addSubview:_nameLabel];
    }
    return _nameLabel;
}
-(UILabel *)authorLabel
{
    if (!_authorLabel) {
        _authorLabel = [[UILabel alloc] initWithFrame:CGRectMake(38, 28, self.bounds.size.width-46, 20)];
        _authorLabel.font = [UIFont systemFontOfSize:15];
        [self addSubview:_authorLabel];
    }
    return _authorLabel;
}
@end
