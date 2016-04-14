//
//  HManger.m
//  HWMusic
//
//  Created by admin on 16/4/9.
//  Copyright © 2016年 he. All rights reserved.
//

#import "HManger.h"

@implementation HManger

+(instancetype)shareManager
{
    static HManger * manager = nil;
    static dispatch_once_t  predicate;
    dispatch_once(&predicate, ^{
        manager = [[HManger alloc] init];
    });
    return manager;
}

@end
