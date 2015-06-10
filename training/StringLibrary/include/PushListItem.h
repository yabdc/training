//
//  PushListItem.h
//  iMessageUtility
//
//  Created by 1200432s on 13/6/27.
//  Copyright (c) 2013年 Arthur Tseng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 * PushListItem
 * 企業訊息列表項目內容
 */
@interface PushListItem : NSObject

@property (nonatomic, retain) NSString *ChatID;     // 訊息編號
@property (nonatomic, retain) NSString *Type;       // 訊息類別
@property (nonatomic, retain) NSString *Title;      // 訊息標題
@property (nonatomic, retain) NSString *Content;    // 訊息內容
@property (nonatomic, retain) NSString *SendTime;   // 訊息發送時間
@property (nonatomic, retain) NSString *TypeTitle;  // 訊息類別名稱
@property (nonatomic, retain) NSString *LinkApp;    // 訊息連結
@property (nonatomic, retain) UIImage  *TypeImage;  // 訊息類別圖片
@property (nonatomic, assign) NSInteger BlockType;  // 封鎖狀態
@property (nonatomic, retain) NSString *GoodCount;      // 按讚次數
@property (nonatomic, retain) NSString *ResponseCount;  // 留言次數
@property (nonatomic, retain) NSString *IsSayGood;      // 已按讚
@end
