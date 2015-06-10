//
//  IMStartUpData.h
//  iMessageUtility
//
//  Created by 1200432AArthur on 2014/9/18.
//  Copyright (c) 2014年 Arthur Tseng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IMStartUpData : NSObject
{
    NSUserDefaults *userDefaults;
}

@property (nonatomic, retain) NSString *CompanyName;        // 公司名稱
@property (nonatomic, retain) NSString *EIPUrl;             // EIP網址
@property (nonatomic, retain) NSString *ThemeColor;         // App色系
@property (nonatomic, retain) NSString *StartImageName;     // 啟動畫面背景圖檔名
@property (nonatomic, assign) NSInteger StartUpVersion;     // 啟動設定版本

+ (IMStartUpData *)shareData;



@end
