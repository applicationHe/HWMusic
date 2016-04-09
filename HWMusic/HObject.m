//
//  HObject.m
//  HWMusic
//
//  Created by admin on 16/4/9.
//  Copyright © 2016年 he. All rights reserved.
//

#import "HObject.h"

@implementation HObject

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    if ([super init]) {
        if (dictionary) {
            [self setValuesForKeysWithDictionary:dictionary];
        }
    }
    return self;
}

-(void)setValuesForKeysWithDictionary:(NSDictionary<NSString *,id> *)keyedValues
{
    
}

@end
