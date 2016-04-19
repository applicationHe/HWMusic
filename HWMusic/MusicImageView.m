//
//  MusicImageView.m
//  HWMusic
//
//  Created by apple on 16/4/19.
//  Copyright © 2016年 he. All rights reserved.
//

#import "MusicImageView.h"

@implementation MusicImageView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

#pragma mark 绘图
- (void)drawRect:(CGRect)rect{
    //1.获得图形上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self drawImage:context];
    [self drawText:context];
    
}
#pragma mark 绘制文本
- (void)drawText:(CGContextRef)context{
    //绘制到指定的区域内容
    NSString *str = self.text;
    CGRect rect = CGRectMake(0, 230, 250, 15);
    UIFont *font = [UIFont systemFontOfSize:13];//设置字体
    UIColor *color = [UIColor blackColor];//字体颜色
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];//段落样式
    style.alignment = NSTextAlignmentCenter;//对齐方式
    [str drawInRect:rect withAttributes:@{NSFontAttributeName:font,
                                          NSForegroundColorAttributeName:color,
                                          NSParagraphStyleAttributeName:style}];
    CGImageRef imageref = CGBitmapContextCreateImage(context);
    self.myimage = [UIImage imageWithCGImage:imageref];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"123" object:nil];
}
#pragma mark 绘制图片
- (void)drawImage:(CGContextRef)context{
    
    UIImage *image = [UIImage imageNamed:self.imageName];
    //从某一点开始绘制
    [image drawAtPoint:CGPointMake(10, 50)];
    //绘制到指定的矩形中，注意如果大小不合适会会进行拉伸，图像会形变
    [image drawInRect:CGRectMake(10, 50, 300, 450)];
    //平铺绘制
    [image drawAsPatternInRect:CGRectMake(0, 0, 250, 250)];
}
@end
