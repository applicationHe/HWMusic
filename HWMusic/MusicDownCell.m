//
//  MusicDownCell.m
//  HWMusic
//
//  Created by apple on 16/4/14.
//  Copyright © 2016年 he. All rights reserved.
//

#import "MusicDownCell.h"

@implementation MusicDownCell

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
    self.progress.progress = 0;
    self.scaleLabel.text = @"0.00％";
    
}

-(UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(38, 8, self.bounds.size.width-46, 20)];
        _nameLabel.font = [UIFont boldSystemFontOfSize:16];
        [self addSubview:_nameLabel];
    }
    return _nameLabel;
}

-(UIProgressView *)progress
{
    if (!_progress) {
        _progress = [[UIProgressView alloc] initWithFrame:CGRectMake(38, 28, self.bounds.size.width-126, 20)];
        [self addSubview:_progress];
    }
    return _progress;
}

-(UILabel *)scaleLabel
{
    if (!_scaleLabel) {
        _scaleLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.bounds.size.width-88, 28,80, 20)];
        [self addSubview:_scaleLabel];
    }
    return _scaleLabel;
}

@end
