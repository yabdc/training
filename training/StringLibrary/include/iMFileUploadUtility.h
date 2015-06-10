//
//  iMFileUploadUtility.h
//  iMessageUtility
//
//  Created by 1200432s on 13/9/25.
//  Copyright (c) 2013年 Arthur Tseng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@protocol iMUploadDelegate <NSObject>
@optional
- (void)iMUploadProgress:(NSNumber *)progress withFileInfo:(NSDictionary *)dic;
- (void)iMUploadResponse:(NSString *)strFileName withFileInfo:(NSDictionary *)dic;
- (void)iMUploadFailWithError:(NSString *)strError withFileInfo:(NSDictionary *)dic;
@end

@interface iMFileUploadUtility : NSObject <NSURLConnectionDelegate>
{
    bool            m_bFinished;
    NSDictionary    *fileInfoDic;
    NSMutableData   *httpResponse;
    NSURLConnection *m_connection;
    
    id<iMUploadDelegate> delegate;
}

@property (nonatomic, retain) NSDictionary  *fileInfoDic;
@property (nonatomic, assign) id<iMUploadDelegate> delegate;

- (void)uploadPicture:(UIImage *)image;

@end
