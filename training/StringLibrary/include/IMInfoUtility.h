//
//  IMInfoUtility.h
//  iMessageUtility
//
//  Created by 1200432s on 13/8/2.
//  Copyright (c) 2013年 Arthur Tseng. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, IMInfo_TYPE)
{
    IMAPPID = 0,        // AppID,識別App
    IMAccount,          // 使用者帳號
    IMPassword,         // 使用者密碼
    IMNickname,         // 使用者姓名
    IMGUID,             // 使用者身分識別碼 (主要)
    IMClientID,         // 使用者身分識別碼 (次要)
    IMToken,            // APNS Token
    IMServerSite,       // Message server 位址
    IMWebServiceURL,    // Message server web service 連線位址
    IMFileUploadURL,    // Message server 上傳檔案 連線位址
    IMFileDownLoadURL,  // Message server 下載檔案 連線位址
    IMAccountRemember,  // 使用者帳號記憶Tag
    IMLastCheckDate,    // 最後一次從背景開啟APP時間
    IMLastReleaseNote,  // 最後一次APP版號
    
};

/**
 * IMInfoUtility
 * 負責存取手機端記憶體的資料介面
 */
@interface IMInfoUtility : NSObject

+ (NSString *)getKeyByType:(IMInfo_TYPE)type;

/**
 * 確認GUID是否存在
 */
+ (BOOL)checkGUID;

/**
 * 取得AppID
 */
+ (NSString *)getAppID;

/**
 * 清除使用者帳號相關資訊
 */
+ (void)clearUserAccountInfo;

/**
 * 清除訊息伺服器位址相關資訊
 */
+ (void)clearServerSiteInfo;

/**
 * 設定推播服務是否開啟
 */
+ (void)setRemoteNotificationServiceStatus:(BOOL)bOn;

/**
 * 取得推播服務狀態
 */
+ (BOOL)getRemoteNoficationServiceStatus;

/**
 * 清除使用者最後停留的頁籤
 */
+ (void)clearSelectedTab;

/**
 * 設定使用者最後停留的頁籤
 */
+ (void)setSelectedTab:(NSInteger)index;

/**
 * 取得使用者最後停留的頁籤
 */
+ (NSInteger)getSelectedTab;

// 儲存手機端記憶體的資料
+ (void)setIMInfoTag:(IMInfo_TYPE)type tagValue:(NSString*)strValue;
// 取得手機端記憶體的資料
+ (NSString *)getIMInfoTagValue:(IMInfo_TYPE)type;



@end
