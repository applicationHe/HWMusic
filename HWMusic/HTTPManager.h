//
//  HTTPManager.h
//  HWMusic
//
//  Created by admin on 16/4/9.
//  Copyright © 2016年 he. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HTTPConstant.h"

typedef void(^postResult)(NSString * result,NSError * error);

typedef void(^getResult)(NSString * result,NSError * error);

@interface HTTPManager : NSObject

+(HTTPManager *)shareManager;

-(void)setPostUrl:(NSString *)url Params:(NSDictionary *)dict blockPostResult:(postResult)postresult;

-(void)setGetUrl:(NSString *)url Params:(NSDictionary *)dict blockGetResult:(getResult)getresult;



@end
