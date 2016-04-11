//
//  MusicTypeCell.m
//  HWMusic
//
//  Created by apple on 16/4/11.
//  Copyright © 2016年 he. All rights reserved.
//

#import "MusicTypeCell.h"
@implementation MusicTypeCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)initUIWith:(MusicTypeModel *)model
{
//    [self.photoImageView sd_setImageWithURL:[NSURL URLWithString:model.imgUrl] placeholderImage:nil];
    self.photoImageView.image = [UIImage imageNamed:model.typeImageName];
    self.photoImageView.layer.cornerRadius = 3;
    self.photoImageView.layer.masksToBounds = YES;
    self.titleLabel.text = model.typeName;
}

-(UIImageView *)photoImageView
{
    if (!_photoImageView) {
        _photoImageView = [[UIImageView alloc] init];
        [self addSubview:_photoImageView];
        __weak typeof(self)weakSelf = self;
        [_photoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(weakSelf).with.insets(UIEdgeInsetsMake(10, 5, 10, 5));
        }];
    }
    return _photoImageView;
}

-(UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor whiteColor];
        [self.photoImageView addSubview:_titleLabel];
        __weak typeof(self)weakSelf = self;
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(40, 100));
            make.left.equalTo(weakSelf.photoImageView).with.offset(2);
            make.bottom.equalTo(weakSelf.photoImageView).with.offset(10);
        }];
    }
    return _titleLabel;
}

@end
