//
//  StickerSerialItem.h
//  iMessageUtility
//
//  Created by 1200432AArthur on 2014/9/23.
//  Copyright (c) 2014年 Arthur Tseng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 * StickerSerialItem
 * 貼圖系列總表項目
 */
@interface StickerSerialItem : NSObject

@property (nonatomic, assign) NSInteger     SerialId;           // 系列編號
@property (nonatomic, assign) NSInteger     Version;            // 版本編號
@property (nonatomic, assign) BOOL          IsClose;            // 此系列是否關閉
@property (nonatomic, retain) NSDate*       ExpirationDate;     // 有效期限
@property (nonatomic, retain) UIImage*      TabIcon;            // TabIcon圖片
@property (nonatomic, retain) NSString*     StickerTableName;   // 存放貼圖資料表名稱

@end
