//
//  HManger.h
//  HWMusic
//
//  Created by admin on 16/4/9.
//  Copyright © 2016年 he. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HManger : NSObject

@property (nonatomic,strong)NSMutableArray * downArray;

+(instancetype)shareManager;

@end
