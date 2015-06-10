//
//  iMFileDownloadUtility.h
//  iMessageUtility
//
//  Created by 1200432s on 13/9/24.
//  Copyright (c) 2013年 Arthur Tseng. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol iMDownloadDelegate <NSObject>
- (void)iMDownloadProgress:(NSNumber *)progress;
- (void)iMDownloadResponse:(NSData *)rtnFileData;
- (void)iMDownloadFailWithError:(NSString *)strError;
@end

@interface iMFileDownloadUtility : NSObject
{
    float m_fTotalFileSize;
    float m_fReceivedDataBytes;
    
    NSURLConnection *m_connection;
    NSMutableData   *httpResponse;
	id<iMDownloadDelegate> delegate;
}

@property (nonatomic, assign) id<iMDownloadDelegate> delegate;

- (void)downloadPictureName:(NSString *)strFileName withChatID:(NSString *)strChatID;

@end
