//
//  iWowMsgParser.h
//  iMessageUtility
//
//  Created by 1200432s on 13/7/29.
//  Copyright (c) 2013年 Arthur Tseng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONKit.h"

@protocol iWMParserDelegate <NSObject>
- (void)iWMServiceResponse:(NSString *)strFunc :(NSDictionary *)rtnDataDic;
- (void)iWMServiceFailWithError:(NSString *)strFunc :(NSString *)strError;
@optional
- (void)iWMServiceResponse:(NSString *)strFunc :(NSDictionary *)rtnDataDic :(NSDictionary *)reqDataDic;
- (void)iWMServiceSendMsgFail:(NSDictionary *)rtnDataDic;
- (void)iWMServiceSendGroupMsgFail:(NSDictionary *)rtnDataDic;
@end

@interface iWowMsgParser : NSObject
{
    bool            m_isFinished;
    NSString        *m_strFunc;
    
    NSDictionary    *m_sendMsgDic;
    NSDictionary    *m_sendGroupMsgDic;
    NSDictionary    *m_reqDic;
    
    NSURLConnection *m_connection;
    NSMutableData   *httpResponse;
	id<iWMParserDelegate>   delegate;
}
@property(nonatomic, assign) id<iWMParserDelegate>  delegate;
@property(nonatomic, retain) NSString               *m_strFunc;

- (void)PostMsgService:(NSString*)strFunc postData:(NSDictionary*)reqData;

@end
