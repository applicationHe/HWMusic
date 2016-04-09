//
//  HTTPManager.m
//  HWMusic
//
//  Created by admin on 16/4/9.
//  Copyright © 2016年 he. All rights reserved.
//

#import "HTTPManager.h"
#import <AFNetworking.h>
//#import <AFHTTPSessionManager.h>

@implementation HTTPManager


+(HTTPManager *)shareManager
{
    static HTTPManager * manager = nil;
    dispatch_once_t predict;
    dispatch_once(&predict, ^{
        manager = [[self alloc] init];
    });
    return manager;
}

-(instancetype)init
{
    if ([super init]) {
        
    }
    return self;
}

-(void)setPostUrl:(NSString *)url Params:(NSDictionary *)dict blockPostResult:(postResult)postresult
{
    NSString * apiUrl = [NSString stringWithFormat:@"%@%@",GOBASEURL,url];
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:apiUrl parameters:dict success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        NSString * result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        postresult(result,nil);
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        NSLog(@"%d", (int)error.code);
        postresult(nil,error);
    }];
    
}

-(void)setGetUrl:(NSString *)url Params:(NSDictionary *)dict blockGetResult:(getResult)getresult
{
    NSString * apiUrl = [NSString stringWithFormat:@"%@%@",GOBASEURL,url];
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager GET:apiUrl parameters:dict success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        NSString * result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        getresult(result,nil);
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        NSLog(@"%d", (int)error.code);
        getresult(nil,error);
    }];
}


@end
