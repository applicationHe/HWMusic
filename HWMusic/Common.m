//
//  Common.m
//  宝贝约约
//
//  Created by 郭鹏飞 on 14-4-27.
//  Copyright (c) 2014年 vhudong. All rights reserved.
//

#import "Common.h"
//引入IOS自带密码库
#import <CommonCrypto/CommonCryptor.h>

//MBProgressHud
#define HUD_VIEW_WIDTH 200
#define HUD_VIEW_HEIGHT 100

//空字符串
#define     LocalStr_None           @""

static const char encodingTable[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";

@implementation Common

//邮箱规则验证
+ (BOOL)isValidateEmail:(NSString *)email{
	NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
	NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
	return [emailTest evaluateWithObject:email];
}

//纯数字正则验证
+ (BOOL)isOnlyNumber:(NSString *)number
{
    NSString *numberRegex = @"^[0-9]*$";
    NSPredicate *numberTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", numberRegex];
    return [numberTest evaluateWithObject:number];
}

//密码进行 MD5加密
+ (NSString *)md5String:(NSString *)str
{
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, strlen(cStr), result); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ]; 
}

//给view加弹动的动画
+(void) animationForTheView:(UIView*)viewLay
{
    CAKeyframeAnimation * animation;
    animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = 0.5;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.8, 0.8, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1, 1.1, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 0.9)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    animation.values = values;
    animation.timingFunction = [CAMediaTimingFunction functionWithName: @"easeInEaseOut"];
    [viewLay.layer addAnimation:animation forKey:nil];
    
}

/**
 * 计算聊天信息应该显示的时间
 * @param compareDate   某一指定时间
 * @return 多少(秒or分or天or月or年)+前 (比如，3天前、10分钟前)
 */
+(NSString *)compareTalkTime:(NSDate *)compareDate{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm"];
    NSMutableString *timeString = [NSMutableString stringWithFormat:@"%@",[formatter stringFromDate:compareDate]];
    
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *dateComps = [cal components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit | NSWeekCalendarUnit | NSWeekdayCalendarUnit fromDate:compareDate];
    NSInteger year = [dateComps year];
    NSInteger month = [dateComps month];
    NSInteger day = [dateComps day];
    NSInteger week = [dateComps weekday];

    
    NSDate *startDate = [NSDate date];
    NSDateComponents *nowComps = [cal components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit|NSWeekCalendarUnit | NSWeekdayCalendarUnit fromDate:startDate];
    NSInteger nowYear = [nowComps year];
    NSInteger nowMonth = [nowComps month];
    NSInteger nowDay = [nowComps day];
    NSInteger nowWeek = [nowComps weekday];
    
    NSString *result;
    if (year == nowYear && month == nowMonth && day == nowDay) {//今天
        result = [NSString stringWithFormat:@"%@",timeString];
    }else if (year == nowYear && month == nowMonth && week == nowWeek && nowDay - day == 1){//昨天
        result = [NSString stringWithFormat:@"昨天 %@",timeString];
    }else if (year == nowYear && month == nowMonth && nowDay - day > 1 && nowDay - day <= 5){//星期几
        result = [NSString stringWithFormat:@"%@ %@",[self getWhichday:week],timeString];
    }else if (year == nowYear){//超过5天
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"MM-dd HH:mm"];
        NSMutableString *timeString = [NSMutableString stringWithFormat:@"%@",[formatter stringFromDate:compareDate]];
        result = [NSString stringWithFormat:@"%@",timeString];
    }else {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        NSMutableString *timeString = [NSMutableString stringWithFormat:@"%@",[formatter stringFromDate:compareDate]];
        result = [NSString stringWithFormat:@"%@",timeString];
    }
    
    return  result;
}

//获取传递天为周几
+ (NSString *)getWhichday:(NSInteger)week
{
    NSString *result;
    if (week == 1) {
        result = @"星期一";
    }else if (week == 2){
        result = @"星期二";
    }else if (week == 3){
        result = @"星期三";
    }else if (week == 4){
        result = @"星期四";
    }else if (week == 5){
        result = @"星期五";
    }else if (week == 6){
        result = @"星期六";
    }else if (week == 7){
        result = @"星期日";
    }
    return result;
}

/**
 * 计算指定时间与当前的时间差(附近的人)
 * @param compareDate   某一指定时间
 * @return 多少(秒or分or天or月or年)+前 (比如，3天前、10分钟前)
 */
+(NSString *)compareCurrentTime:(NSString *)compareDate{
    NSTimeInterval agoTimeInterval = [compareDate doubleValue] / 1000;
    NSTimeInterval nowTimeInterval = [[NSDate date] timeIntervalSince1970];
    NSTimeInterval timeInterval = nowTimeInterval - agoTimeInterval;
    NSDate *ageDate = [NSDate dateWithTimeIntervalSince1970:agoTimeInterval];
    long temp = 0;
    NSString *result;
    if (timeInterval < 60) {
        result = [NSString stringWithFormat:@"刚刚"];
    }
    else if((temp = timeInterval/60) <60){
        result = [NSString stringWithFormat:@"%ld分前",temp];
    }
    
    else if((temp = temp/60) <24){
        result = [NSString stringWithFormat:@"%ld小时前",temp];
    }
    
    else{
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        result = [NSString stringWithFormat:@"%@",[formatter stringFromDate:ageDate]];
    }
    return  result;
}

/**
 * 计算指定时间与当前的时间差(足迹列表)
 * @param compareDate   某一指定时间
 * @return 多少(秒or分or天or月or年)+前 (比如，3天前、10分钟前)
 */
+(NSString *)compareFootTime:(NSString *)compareDate{
    NSTimeInterval agoTimeInterval = [compareDate integerValue];
    NSTimeInterval nowTimeInterval = [[NSDate date] timeIntervalSince1970];
    NSTimeInterval timeInterval = nowTimeInterval - agoTimeInterval;
    long temp = 0;
    NSString *result;
    if (timeInterval < 60) {
        result = [NSString stringWithFormat:@"刚刚"];
    }
    else if((temp = timeInterval/60) <60){
        result = [NSString stringWithFormat:@"%ld分钟",temp];
    }
    
    else if((temp = temp/60) <24){
        result = [NSString stringWithFormat:@"%ld小时",temp];
    }
    
    else if((temp = temp/24) <8){
        result = [NSString stringWithFormat:@"%ld天",temp];
    }else{
        if ((temp = temp/30) <12) {
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
            [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
            [dateFormatter setDateFormat:@"MM-dd"];
            NSDate *theday = [NSDate dateWithTimeIntervalSince1970:agoTimeInterval];
            result = [dateFormatter stringFromDate:theday];
        }else{
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
            [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
            [dateFormatter setDateFormat:@"yyyy-MM-dd"];
            NSDate *theday = [NSDate dateWithTimeIntervalSince1970:agoTimeInterval];
            result = [dateFormatter stringFromDate:theday];
        }
    }
    return  result;
}

/**
 * 改变制定距离米数的格式
 * @param place   距离米数
 * @return 距离的多远（如100米，1公里等）
*/

+ (NSString *)comparePlace:(NSString *)place
{
    NSString *result;
    NSInteger placeCount = [place integerValue];
    if(placeCount >= 100000) {
        result = [NSString stringWithFormat:@"%d公里",placeCount / 1000];
    }else if (placeCount >= 10000 && placeCount < 100000) {
        result = [NSString stringWithFormat:@"%.1f公里",(CGFloat)placeCount / 1000.0];
    }else if (placeCount >= 1000 && placeCount < 10000){
        result = [NSString stringWithFormat:@"%.1f公里",(CGFloat)placeCount / 1000.0];
    }else{
        result = [NSString stringWithFormat:@"%ld米",(long)placeCount];
    }
    return result;
}

//+ (NSString *)getDistance:(NSString *)str
//{
//    NSString *s = [Common notRounding:[str floatValue] afterPoint:1];
//    NSString *s1 = [Common notRounding:[s  floatValue]/1000 afterPoint:1];
//    return s1;
//}

/**
 * 计算年龄
 * @param compareDate   某一指定时间
 * @return 多少(秒or分or天or月or年)+前 (比如，3天前、10分钟前)
 */
+(NSString *)compareAge:(NSString *)compareDate{
    NSTimeInterval agoTimeInterval = [compareDate doubleValue];
    NSTimeInterval nowTimeInterval = [[NSDate date] timeIntervalSince1970];
    NSTimeInterval timeInterval = nowTimeInterval - agoTimeInterval;
    long temp = 0;
    NSString *result;
    if (timeInterval < 60) {
        result = [NSString stringWithFormat:@"0岁"];
    }
    else if((temp = timeInterval/60) <60){
        result = [NSString stringWithFormat:@"0岁"];
    }
    
    else if((temp = temp/60) <24){
        result = [NSString stringWithFormat:@"0岁"];
    }
    
    else if((temp = temp/24) <30){
        result = [NSString stringWithFormat:@"%ld天",temp];
    }
    
    else if((temp = temp/30) <12){
        result = [NSString stringWithFormat:@"%ld月",temp];
    }
    else{
        temp = temp/12;
        result = [NSString stringWithFormat:@"%ld岁",temp];
    }
    
    return  result;
}

+(NSString *)getDocumentPath
{
    return [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
}

+(NSString *)getTargetFloderPath
{
    return [self getDocumentPath];
}

+(NSString *)getTempFolderPath
{
    return [[self getDocumentPath] stringByAppendingPathComponent:@"Temp"];
}

+(NSString *)getImagesFolderPath{
	return [[self getDocumentPath] stringByAppendingPathComponent:@"Images"];
}

+(NSString *)getSettingFolderPath{
	return [[self getDocumentPath] stringByAppendingPathComponent:@"Set"];
}

//验证是否位11位纯数字切开头为1的正则
+ (BOOL)checkPhoneNumber:(NSString *)phoneNumber {
    NSString *strRegex = @"^1[3-9]\\d{9}$";
    NSPredicate *emailPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", strRegex];
    
    return [emailPredicate evaluateWithObject:phoneNumber];
}

// 正则判断手机号码地址格式
+ (BOOL)isMobileNumber:(NSString *)mobileNum
{
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189
     */
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12         */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186
     17         */
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,189
     22         */
    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    /**
     25         * 大陆地区固话及小灵通
     26         * 区号：010,020,021,022,023,024,025,027,028,029
     27         * 号码：七位或八位
     28         */
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:mobileNum] == YES)
        || ([regextestcm evaluateWithObject:mobileNum] == YES)
        || ([regextestct evaluateWithObject:mobileNum] == YES)
        || ([regextestcu evaluateWithObject:mobileNum] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}


//对图片尺寸进行压缩--
+ (UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize
{
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    
    // Tell the old image to draw in this new context, with the desired
    // new size
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // End the context
    UIGraphicsEndImageContext();
    
    // Return the new image.
    return newImage;
}

//获取gps开关的开关状态
+ (BOOL)getGPSSwitch
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"gpsSwitch"];
}

#pragma mark - BASE64加密处理
+ (NSString *)base64StringFromText:(NSString *)text
{
    if (text && ![text isEqualToString:LocalStr_None]) {
        //取项目的bundleIdentifier作为KEY  改动了此处
        //NSString *key = [[NSBundle mainBundle] bundleIdentifier];
        NSData *data = [text dataUsingEncoding:NSUTF8StringEncoding];
        //IOS 自带DES加密 Begin  改动了此处
        //data = [self DESEncrypt:data WithKey:key];
        //IOS 自带DES加密 End
        return [self base64EncodedStringFrom:data];
    }
    else {
        return LocalStr_None;
    }
}

+ (NSString *)textFromBase64String:(NSString *)base64
{
    if (base64 && ![base64 isEqualToString:LocalStr_None]) {
        //取项目的bundleIdentifier作为KEY   改动了此处
        //NSString *key = [[NSBundle mainBundle] bundleIdentifier];
        NSData *data = [self dataWithBase64EncodedString:base64];
        //IOS 自带DES解密 Begin    改动了此处
        //data = [self DESDecrypt:data WithKey:key];
        //IOS 自带DES加密 End
        return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    }
    else {
        return LocalStr_None;
    }
}

/******************************************************************************
 函数名称 : + (NSData *)DESEncrypt:(NSData *)data WithKey:(NSString *)key
 函数描述 : 文本数据进行DES加密
 输入参数 : (NSData *)data
 (NSString *)key
 输出参数 : N/A
 返回参数 : (NSData *)
 备注信息 : 此函数不可用于过长文本
 ******************************************************************************/
+ (NSData *)DESEncrypt:(NSData *)data WithKey:(NSString *)key
{
    char keyPtr[kCCKeySizeAES256+1];
    bzero(keyPtr, sizeof(keyPtr));
    
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    NSUInteger dataLength = [data length];
    
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    
    size_t numBytesEncrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt, kCCAlgorithmDES,
                                          kCCOptionPKCS7Padding | kCCOptionECBMode,
                                          keyPtr, kCCBlockSizeDES,
                                          NULL,
                                          [data bytes], dataLength,
                                          buffer, bufferSize,
                                          &numBytesEncrypted);
    if (cryptStatus == kCCSuccess) {
        return [NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted];
    }
    
    free(buffer);
    return nil;
}

/******************************************************************************
 函数名称 : + (NSData *)DESEncrypt:(NSData *)data WithKey:(NSString *)key
 函数描述 : 文本数据进行DES解密
 输入参数 : (NSData *)data
 (NSString *)key
 输出参数 : N/A
 返回参数 : (NSData *)
 备注信息 : 此函数不可用于过长文本
 ******************************************************************************/
+ (NSData *)DESDecrypt:(NSData *)data WithKey:(NSString *)key
{
    char keyPtr[kCCKeySizeAES256+1];
    bzero(keyPtr, sizeof(keyPtr));
    
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    NSUInteger dataLength = [data length];
    
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    
    size_t numBytesDecrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt, kCCAlgorithmDES,
                                          kCCOptionPKCS7Padding | kCCOptionECBMode,
                                          keyPtr, kCCBlockSizeDES,
                                          NULL,
                                          [data bytes], dataLength,
                                          buffer, bufferSize,
                                          &numBytesDecrypted);
    
    if (cryptStatus == kCCSuccess) {
        return [NSData dataWithBytesNoCopy:buffer length:numBytesDecrypted];
    }
    
    free(buffer);
    return nil;
}

/******************************************************************************
 函数名称 : + (NSData *)dataWithBase64EncodedString:(NSString *)string
 函数描述 : base64格式字符串转换为文本数据
 输入参数 : (NSString *)string
 输出参数 : N/A
 返回参数 : (NSData *)
 备注信息 :
 ******************************************************************************/
+ (NSData *)dataWithBase64EncodedString:(NSString *)string
{
    if (string == nil)
        [NSException raise:NSInvalidArgumentException format:nil];
    if ([string length] == 0)
        return [NSData data];
    
    static char *decodingTable = NULL;
    if (decodingTable == NULL)
    {
        decodingTable = malloc(256);
        if (decodingTable == NULL)
            return nil;
        memset(decodingTable, CHAR_MAX, 256);
        NSUInteger i;
        for (i = 0; i < 64; i++)
            decodingTable[(short)encodingTable[i]] = i;
    }
    
    const char *characters = [string cStringUsingEncoding:NSASCIIStringEncoding];
    if (characters == NULL)     //  Not an ASCII string!
        return nil;
    char *bytes = malloc((([string length] + 3) / 4) * 3);
    if (bytes == NULL)
        return nil;
    NSUInteger length = 0;
    
    NSUInteger i = 0;
    while (YES)
    {
        char buffer[4];
        short bufferLength;
        for (bufferLength = 0; bufferLength < 4; i++)
        {
            if (characters[i] == '\0')
                break;
            if (isspace(characters[i]) || characters[i] == '=')
                continue;
            buffer[bufferLength] = decodingTable[(short)characters[i]];
            if (buffer[bufferLength++] == CHAR_MAX)      //  Illegal character!
            {
                free(bytes);
                return nil;
            }
        }
        
        if (bufferLength == 0)
            break;
        if (bufferLength == 1)      //  At least two characters are needed to produce one byte!
        {
            free(bytes);
            return nil;
        }
        
        //  Decode the characters in the buffer to bytes.
        bytes[length++] = (buffer[0] << 2) | (buffer[1] >> 4);
        if (bufferLength > 2)
            bytes[length++] = (buffer[1] << 4) | (buffer[2] >> 2);
        if (bufferLength > 3)
            bytes[length++] = (buffer[2] << 6) | buffer[3];
    }
    
    bytes = realloc(bytes, length);
    return [NSData dataWithBytesNoCopy:bytes length:length];
}

/******************************************************************************
 函数名称 : + (NSString *)base64EncodedStringFrom:(NSData *)data
 函数描述 : 文本数据转换为base64格式字符串
 输入参数 : (NSData *)data
 输出参数 : N/A
 返回参数 : (NSString *)
 备注信息 :
 ******************************************************************************/
+ (NSString *)base64EncodedStringFrom:(NSData *)data
{
    if ([data length] == 0)
        return @"";
    
    char *characters = malloc((([data length] + 2) / 3) * 4);
    if (characters == NULL)
        return nil;
    NSUInteger length = 0;
    
    NSUInteger i = 0;
    while (i < [data length])
    {
        char buffer[3] = {0,0,0};
        short bufferLength = 0;
        while (bufferLength < 3 && i < [data length])
            buffer[bufferLength++] = ((char *)[data bytes])[i++];
        
        //  Encode the bytes in the buffer to four characters, including padding "=" characters if necessary.
        characters[length++] = encodingTable[(buffer[0] & 0xFC) >> 2];
        characters[length++] = encodingTable[((buffer[0] & 0x03) << 4) | ((buffer[1] & 0xF0) >> 4)];
        if (bufferLength > 1)
            characters[length++] = encodingTable[((buffer[1] & 0x0F) << 2) | ((buffer[2] & 0xC0) >> 6)];
        else characters[length++] = '=';
        if (bufferLength > 2)
            characters[length++] = encodingTable[buffer[2] & 0x3F];
        else characters[length++] = '=';
    }
    
    return [[NSString alloc] initWithBytesNoCopy:characters length:length encoding:NSASCIIStringEncoding freeWhenDone:YES];
}

+ (UIColor *) colorWithHexString:(NSString *)hexColor
{
    unsigned int ired, igreen, iblue;
    NSRange range;
    range.length = 2;
    
    range.location = 1;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&ired];
    range.location = 3;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&igreen];
    range.location = 5;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&iblue];
    
    return [UIColor colorWithRed:(float)(ired/255.0f) green:(float)(igreen/255.0f) blue:(float)(iblue/255.0f) alpha:1.0f];
}

//弹出又缩小动画
+ (void) shakeToShow:(UIView*)aView{
    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = 0.5;
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1, 1.1, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    animation.values = values;
    [aView.layer addAnimation:animation forKey:nil];
}


+ (BOOL) isPad {
    return UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad;
}

+ (void)alertNofunctionView:(UIView *)superView
{
    [self showMBProgressHud:self SuperView:superView Msg:@"程序猿玩儿命开发中, 我就来，等我~~" ShowTime:1.0];
}

+ (MBProgressHUD *) showMBProgressHud:(id)sender SuperView:(UIView *)superView Msg:(NSString *)msg ShowTime:(CGFloat)showtime {

   MBProgressHUD *hudView;
    if ([self isPad]) {
        CGRect rect = superView.bounds;
        rect.origin.x = rect.size.width / 2 - HUD_VIEW_WIDTH / 2;
        rect.origin.y = rect.size.height / 2 - HUD_VIEW_HEIGHT / 2;
        rect.size.width = HUD_VIEW_WIDTH;
        rect.size.height = HUD_VIEW_HEIGHT;
        hudView = [[MBProgressHUD alloc] initWithFrame:rect];
        hudView.userInteractionEnabled = NO;
        [superView addSubview:hudView];
    }else {
        CGRect rect = superView.bounds;
        rect.origin.x = rect.size.width / 2 - HUD_VIEW_WIDTH / 2;
        rect.origin.y = rect.size.height / 2 - HUD_VIEW_HEIGHT / 2;
        rect.size.width = HUD_VIEW_WIDTH;
        rect.size.height = HUD_VIEW_HEIGHT;
        hudView = [[MBProgressHUD alloc] initWithFrame:rect];
        hudView.userInteractionEnabled = NO;
        [superView addSubview:hudView];
        //hudView = [MBProgressHUD showHUDAddedTo:superView animated:YES];
    }

    hudView.delegate = sender;    
    hudView.mode = MBProgressHUDModeText;
    hudView.labelText = msg;
    hudView.margin = 10.f;
    //hudView.yOffset = 150.f;
    
    [hudView show:YES];
    [hudView hide:YES afterDelay:showtime];
    return hudView;
}

+ (MBProgressHUD *) showMBProgressHud:(id)sender SuperView:(UIView *)superView Msg:(NSString *)msg ShowTime:(CGFloat)showtime LeftOffset:(NSInteger)leftOffset {
    MBProgressHUD *hudView;
    if ([self isPad]) {
        CGRect rect = superView.bounds;
        rect.origin.x = rect.size.width / 2 - HUD_VIEW_WIDTH / 2 - leftOffset;
        rect.origin.y = rect.size.height / 2 - HUD_VIEW_HEIGHT / 2;
        rect.size.width = HUD_VIEW_WIDTH;
        rect.size.height = HUD_VIEW_HEIGHT;
        hudView = [[MBProgressHUD alloc] initWithFrame:rect];
        hudView.userInteractionEnabled = NO;
        [superView addSubview:hudView];
    }else {
        hudView = [MBProgressHUD showHUDAddedTo:superView animated:YES];
    }
    
    hudView.delegate = sender;
    
    hudView.mode = MBProgressHUDModeText;
    hudView.labelText = msg;
    hudView.margin = 10.f;
    //hudView.yOffset = 150.f;
    
    [hudView show:YES];
    [hudView hide:YES afterDelay:showtime];
    return hudView;
}

+ (MBProgressHUD *) showMBProgressHud:(id)sender SuperView:(UIView *)superView Msg:(NSString *)msg {
    MBProgressHUD *hudView;
    if ([self isPad]) {
        CGRect rect = superView.bounds;
        rect.origin.x = rect.size.width / 2 - HUD_VIEW_WIDTH / 2;
        rect.origin.y = rect.size.height / 2 - HUD_VIEW_HEIGHT / 2;
        rect.size.width = HUD_VIEW_WIDTH;
        rect.size.height = HUD_VIEW_HEIGHT;
        hudView = [[MBProgressHUD alloc] initWithFrame:rect];
        hudView.userInteractionEnabled = NO;
        [superView addSubview:hudView];
    }else {
        CGRect rect = superView.bounds;
        rect.origin.x = rect.size.width / 2 - HUD_VIEW_WIDTH / 2;
        rect.origin.y = rect.size.height / 2 - HUD_VIEW_HEIGHT / 2;
        rect.size.width = HUD_VIEW_WIDTH;
        rect.size.height = HUD_VIEW_HEIGHT;
        hudView = [[MBProgressHUD alloc] initWithFrame:rect];
        hudView.userInteractionEnabled = NO;
        [superView addSubview:hudView];
        //hudView = [MBProgressHUD showHUDAddedTo:superView animated:YES];
    }
    
    hudView.delegate = sender;
    
    hudView.mode = MBProgressHUDModeIndeterminate;
    hudView.labelText = msg;
    hudView.margin = 10.f;
    //hudView.yOffset = 150.f;
    
    [hudView show:YES];
    return hudView;
}

+ (MBProgressHUD *) showMBProgressHud:(id)sender SuperView:(UIView *)superView Msg:(NSString *)msg VisibleRect:(CGRect)vRect {
    MBProgressHUD *hudView;
    if ([self isPad]) {
        hudView = [[MBProgressHUD alloc] initWithFrame:vRect];
        [superView addSubview:hudView];
    }else {
        hudView = [[MBProgressHUD alloc] initWithFrame:vRect];
        [superView addSubview:hudView];
    }
    hudView.delegate = sender;
    
    hudView.mode = MBProgressHUDModeIndeterminate;
    hudView.labelText = msg;
    hudView.margin = 10.f;
    //hudView.yOffset = 150.f;
    
    [hudView show:YES];
    NSLog(@"%@", NSStringFromCGRect(hudView.frame));
    return hudView;
}

+ (MBProgressHUD *) showMBProgressHud:(id)sender SuperView:(UIView *)superView Msg:(NSString *)msg LeftOffset:(NSInteger)leftOffset {
    MBProgressHUD *hudView;
    if ([self isPad]) {
        CGRect rect = superView.bounds;
        rect.origin.x = rect.size.width / 2 - 50 - leftOffset;
        rect.origin.y = rect.size.height / 2 - 50;
        rect.size.width = 100;
        rect.size.height = 100;
        hudView = [[MBProgressHUD alloc] initWithFrame:rect];
        hudView.userInteractionEnabled = NO;
        [superView addSubview:hudView];
    }else {
        //hudView = [MBProgressHUD showHUDAddedTo:superView animated:YES];
        CGRect rect = superView.bounds;
        rect.origin.x = rect.size.width / 2 - 50;
        rect.origin.y = rect.size.height / 2 - 50;
        rect.size.width = 100;
        rect.size.height = 100;
        hudView = [[MBProgressHUD alloc] initWithFrame:rect];
        hudView.userInteractionEnabled = NO;
        [superView addSubview:hudView];
    }
    
    hudView.delegate = sender;
    
    hudView.mode = MBProgressHUDModeIndeterminate;
    hudView.labelText = msg;
    hudView.margin = 10.f;
    //hudView.yOffset = 150.f;
    
    [hudView show:YES];
    return hudView;
}

+ (MBProgressHUD *) showMBProgressHudHint:(id)sender SuperView:(UIView *)superView Msg:(NSString *)msg ShowTime:(CGFloat)showtime {
    MBProgressHUD *hudView = [MBProgressHUD showHUDAddedTo:superView animated:YES];
    hudView.delegate = sender;
    
    hudView.mode = MBProgressHUDModeText;
    hudView.labelText = msg;
    hudView.margin = 10.f;
    //hudView.yOffset = 150.f;
    
    [hudView hide:YES afterDelay:showtime];
    return hudView;
}

//四舍五入

/*
 price:需要处理的数字，
 position：保留小数点第几位
 */
+ (NSString *)notRounding:(float)price afterPoint:(int)position{
    NSDecimalNumberHandler* roundingBehavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundPlain scale:position raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
    NSDecimalNumber *ouncesDecimal;
    NSDecimalNumber *roundedOunces;
    ouncesDecimal = [[NSDecimalNumber alloc] initWithFloat:price];
    roundedOunces = [ouncesDecimal decimalNumberByRoundingAccordingToBehavior:roundingBehavior];
    return [NSString stringWithFormat:@"%@",roundedOunces];
}

+ (NSString *)getCachSize:(NSUInteger)size {
    float sizeFlo = [[NSString stringWithFormat:@"%lu",(unsigned long)size] floatValue];
    NSString *float1 =[self notRounding:sizeFlo/1024.0 afterPoint:1];//KB，转换成kb后保留一位有效数字
    NSString *float2 = [self notRounding:sizeFlo /(1024.0 * 1024.0) afterPoint:1];//M，转换成M保留一位有效数字
    NSString *getString;
    if ([float1 intValue] <= 100) {
        getString = [NSString stringWithFormat:@"%@KB",float1];
    }else{
        getString = [NSString stringWithFormat:@"%@M",float2];
    }
    return getString;
}

//旋转uiimage为正
+ (UIImage *)rotateImage:(UIImage *)aImage{
    CGImageRef imgRef = aImage.CGImage;
    CGFloat width = CGImageGetWidth(imgRef);
    CGFloat height = CGImageGetHeight(imgRef);
    CGAffineTransform transform = CGAffineTransformIdentity;
    CGRect bounds = CGRectMake(0, 0, width, height);
    CGFloat scaleRatio = 1;
    CGFloat boundHeight;
    UIImageOrientation orient = aImage.imageOrientation;
    switch(orient)
    {
        case UIImageOrientationUp: //EXIF = 1
            transform = CGAffineTransformIdentity;
            break;
        case UIImageOrientationUpMirrored: //EXIF = 2
            transform = CGAffineTransformMakeTranslation(width, 0.0);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            break;
        case UIImageOrientationDown: //EXIF = 3
            transform = CGAffineTransformMakeTranslation(width, height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
        case UIImageOrientationDownMirrored: //EXIF = 4
            transform = CGAffineTransformMakeTranslation(0.0, height);
            transform = CGAffineTransformScale(transform, 1.0, -1.0);
            break;
        case UIImageOrientationLeftMirrored: //EXIF = 5
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(height, width);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
        case UIImageOrientationLeft: //EXIF = 6
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(0.0, width);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
        case UIImageOrientationRightMirrored: //EXIF = 7
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeScale(-1.0, 1.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
        case UIImageOrientationRight: //EXIF = 8
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(height, 0.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
        default:
            [NSException raise:NSInternalInconsistencyException format:@"Invalid image orientation"];
    }
    UIGraphicsBeginImageContext(bounds.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    if (orient == UIImageOrientationRight || orient == UIImageOrientationLeft) {
        CGContextScaleCTM(context, -scaleRatio, scaleRatio);
        CGContextTranslateCTM(context, -height, 0);
    }else {
        CGContextScaleCTM(context, scaleRatio, -scaleRatio);
        CGContextTranslateCTM(context, 0, -height);
    }
    CGContextConcatCTM(context, transform);
    CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, width, height), imgRef);
    UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return imageCopy;
}


+ (CGRect)getLabelFrameWithString:(NSString *)context
                             font:(UIFont *)textFont
                         sizeMake:(CGSize)labelSize{
    CGRect tmpRect;
    
    if (IOS7_OR_LATER) {
        tmpRect = [context boundingRectWithSize:labelSize
                                        options:NSStringDrawingUsesLineFragmentOrigin
                                     attributes:[NSDictionary dictionaryWithObjectsAndKeys:textFont,NSFontAttributeName, nil]
                                        context:nil];
    }
    return tmpRect;
}

- (UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize iamge:(UIImage *)img
{
    UIImage *sourceImage = img;
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat heightp = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / heightp;
        if (widthFactor > heightFactor)
            scaleFactor = widthFactor; // scale to fit height
        else
            scaleFactor = heightFactor; // scale to fit width
        scaledWidth= width * scaleFactor;
        scaledHeight = heightp * scaleFactor;
        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else if (widthFactor < heightFactor)
        {
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    UIGraphicsBeginImageContext(targetSize); // this will crop
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width= scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    [sourceImage drawInRect:thumbnailRect];
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil)
        NSLog(@"could not scale image");
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    return newImage;
}

+ (NSString *)formatTimeString:(NSString *)time
{
    NSArray *arr = [time componentsSeparatedByString:@"."];
    if ([arr count] > 0)
    {
        return [arr objectAtIndex:0];
    }
    else
    {
        return time;
    }
}

+ (CGRect) getRectWithLabel:(UILabel *)lab withContent:(NSString *)content upView:(UILabel *)upLabel withGap:(float)gap{
    
    CGRect rect = [self getLabelFrameWithString:content font:lab.font sizeMake:CGSizeMake(lab.frame.size.width, 60)];
    
    CGRect frame;
    if (upLabel) {
        frame = CGRectMake(CGRectGetMinX(lab.frame), CGRectGetMaxY(upLabel.frame)+gap, CGRectGetMidX(lab.frame), rect.size.height);
    }else{
        frame = CGRectMake(CGRectGetMinX(lab.frame), CGRectGetMinY(lab.frame)+gap, CGRectGetMidX(lab.frame), rect.size.height);
    }
    return frame;
}

+ (NSString *)formatDate:(NSTimeInterval)timeInterval andFormatter:(NSString *)format
{
    if (timeInterval <= 0)
    {
        return @"";
    }
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];

    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    
    NSString *dateString = [formatter stringFromDate:date];
    
    return dateString;
}

//根据颜色获取纯色image
+ (UIImage *)buttonImageFromColor:(UIColor *)color{
    
    CGRect rect = CGRectMake(0, 0, 50, 50);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext(); return img;
}

+ (NSString *)getTimeStringWithInterval:(NSTimeInterval)timeInterval format:(NSString *)format
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSCalendar *calendar=[[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    [dateFormatter setCalendar:calendar];
    [dateFormatter setLocale:[NSLocale systemLocale]];
    [dateFormatter setDateFormat:format];
    NSString *currentDateStr = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:timeInterval]];
    return currentDateStr;
}
@end
