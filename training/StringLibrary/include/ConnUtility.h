//
//  ConnUtility.h
//  iMessageUtility
//
//  Created by 1200432s on 13/6/27.
//  Copyright (c) 2013年 Arthur Tseng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Reachability.h"

@interface ConnUtility : NSObject

+(BOOL)isHostAlive:(NSString*)urlToReach;	//傳入nil 取得有連線能力

+(BOOL)isNetworkConnected;
// 20140728 add by Arthur Tseng
+ (BOOL)isConnectedToInternet;
+ (BOOL)stringFromStatus:(NetworkStatus)status;

//Http
+(NSMutableURLRequest*)genURLRequest:(NSString*)urlReq;
+(NSMutableURLRequest*)genCommonURLRequest:(NSString*)urlReq;

+(void)initConnectStatus;
+(NSString*)getIPAddress;

@end
