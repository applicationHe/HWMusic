//
//  Common.h
//  宝贝约约
//
//  Created by 郭鹏飞 on 14-4-27.
//  Copyright (c) 2014年 vhudong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>
#import <MBProgressHUD.h>
#define IOS7_OR_LATER   ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 7.0)

#define __BASE64( text )        [CommonFunc base64StringFromText:text]
#define __TEXT( base64 )        [CommonFunc textFromBase64String:base64]


typedef enum  {
    kCarRigster = 0,//注册进入爱车
    kCarAdd,//添加爱车
    kCarEdit//编辑爱车
} kCarType;


@interface Common : NSObject

+ (UIColor *) colorWithHexString:(NSString *)hexColor;
//邮箱规则验证
+ (BOOL)isValidateEmail:(NSString *)email;
//纯数字正则验证
+ (BOOL)isOnlyNumber:(NSString *)number;

+ (NSString *)md5String:(NSString *)str;
//弹动动画
+ (void)animationForTheView:(UIView*)viewLay;
//返回某条时间应该在聊天界面显示的字符串
+(NSString *)compareTalkTime:(NSDate *)compareDate;
//计算时间差，返回时间差字符串
+ (NSString *)compareCurrentTime:(NSString *)compareDate;
//计算足迹发表的时间
+(NSString *)compareFootTime:(NSString *)compareDate;
//计算年龄
+(NSString *)compareAge:(NSString *)compareDate;
//计算距离，返回公里，米数
+ (NSString *)comparePlace:(NSString *)place;
//得到实际文件存储文件夹的路径
+ (NSString *)getTargetFloderPath;
//得到临时文件存储文件夹的路径
+ (NSString *)getTempFolderPath;
//得到收藏和分享的图片的路径
+ (NSString *)getImagesFolderPath;
//得到设置文件夹的路径
+(NSString *)getSettingFolderPath;
//验证是否位11位纯数字切开头为1的正则
+ (BOOL)checkPhoneNumber:(NSString *)phoneNumber;
// 正则判断手机号码地址格式
+ (BOOL)isMobileNumber:(NSString *)mobileNum;
//图片压缩
+ (UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize;
//获取gps开关的开关状态
+ (BOOL)getGPSSwitch;

+ (NSString *)base64EncodedStringFrom:(NSData *)data;
/******************************************************************************
 函数名称 : + (NSString *)base64StringFromText:(NSString *)text
 函数描述 : 将文本转换为base64格式字符串
 输入参数 : (NSString *)text    文本
 输出参数 : N/A
 返回参数 : (NSString *)    base64格式字符串
 备注信息 :
 ******************************************************************************/
+(NSString *)base64StringFromText:(NSString *)text;

/******************************************************************************
 函数名称 : + (NSString *)textFromBase64String:(NSString *)base64
 函数描述 : 将base64格式字符串转换为文本
 输入参数 : (NSString *)base64  base64格式字符串
 输出参数 : N/A
 返回参数 : (NSString *)    文本
 备注信息 :
 ******************************************************************************/
+(NSString *)textFromBase64String:(NSString *)base64;


+ (void) shakeToShow:(UIView*)aView;

+ (void)alertNofunctionView:(UIView *)superView;

+ (MBProgressHUD *) showMBProgressHud:(id)sender SuperView:(UIView *)superView Msg:(NSString *)msg ShowTime:(CGFloat)showtime;
+ (MBProgressHUD *) showMBProgressHud:(id)sender SuperView:(UIView *)superView Msg:(NSString *)msg ShowTime:(CGFloat)showtime LeftOffset:(NSInteger)leftOffset;
+ (MBProgressHUD *) showMBProgressHud:(id)sender SuperView:(UIView *)superView Msg:(NSString *)msg;
+ (MBProgressHUD *) showMBProgressHud:(id)sender SuperView:(UIView *)superView Msg:(NSString *)msg VisibleRect:(CGRect)vRect;
+ (MBProgressHUD *) showMBProgressHud:(id)sender SuperView:(UIView *)superView Msg:(NSString *)msg LeftOffset:(NSInteger)leftOffset;
+ (MBProgressHUD *) showMBProgressHudHint:(id)sender SuperView:(UIView *)superView Msg:(NSString *)msg ShowTime:(CGFloat)showtime;

+ (NSString *)getCachSize:(NSUInteger)size ;

+ (NSString *)notRounding:(float)price afterPoint:(int)position;/**<四舍五入*/

//旋转uiimage为正
+ (UIImage *)rotateImage:(UIImage *)aImage;

/**
 *  根据内容获取label的rect
 *
 *  @param context   label内容
 *  @param textFont  字体大小
 *  @param labelSize label范围
 *
 *  @return 适配后的label高度和宽度
 */
+ (CGRect)getLabelFrameWithString:(NSString *)context
                             font:(UIFont *)textFont
                         sizeMake:(CGSize)labelSize;

/**
 *  图片等比例压缩
 *
 *  @param targetSize 目标size，
 *  @param img        传入指定image
 *
 *  @return 返回新的image
 */
- (UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize iamge:(UIImage *)img;

/**
 *  处理后台传来的时间
 *
 *  @param time 需要处理的时间
 *
 *  @return 处理后的结果
 */
+ (NSString *)formatTimeString:(NSString *)time;

/**
 *  将时间戳转化为时间
 *
 *  @param timeInterval 时间戳 
 *  @param format 转化成的格式
 *
 *  @return 时间
 */
+ (NSString *)formatDate:(NSTimeInterval)timeInterval andFormatter:(NSString *)format;

/**
 *  返回frame
 *
 *  @param lab     传入需要计算frame的lab
 *  @param content 传入lab的内容
 *  @param upLabel lab上面的label
 *  @param gap     距离上一个空间的间隔
 *
 *  @return 返回lab的frame
 */
+ (CGRect) getRectWithLabel:(UILabel *)lab
                withContent:(NSString *)content
                     upView:(UILabel *)upLabel
                    withGap:(float)gap;

+ (UIImage *)buttonImageFromColor:(UIColor *)color;

/**
 *  返回时间格式
 *
 *  @param timeInterval     时间戳
 *  @param format 要求数据格式 比如@"yyyy-MM-dd HH:mm:ss"
 *  @return 返回lab的frame
 */
+ (NSString *)getTimeStringWithInterval:(NSTimeInterval)timeInterval format:(NSString *)format;
@end
