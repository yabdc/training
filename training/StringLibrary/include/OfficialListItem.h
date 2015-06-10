//
//  OfficialListItem.h
//  iMessageUtility
//
//  Created by 1200432s on 13/6/27.
//  Copyright (c) 2013年 Arthur Tseng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 * OfficialListItem
 * 最新訊息列表項目內容
 */
@interface OfficialListItem : NSObject

@property (nonatomic, retain) NSString *SayPhone;           // 發送人帳號
@property (nonatomic, retain) NSString *SayNickname;        // 發送人姓名
@property (nonatomic, retain) NSString *SendTime;           // 發送時間
@property (nonatomic, retain) NSString *LatestChatId;       // 最後一則訊息編號
@property (nonatomic, retain) NSString *LatestMsg;          // 最後一則訊息內容
@property (nonatomic, retain) NSString *LatestContentType;  // 最後一則訊息類別
@property (nonatomic, retain) NSString *UnreadCount;        // 最後一則訊息未讀則數
@property (nonatomic, retain) NSString *bGroupType;         // 是否為群組
@property (nonatomic, retain) NSString *nGMemberCount;      // 群組人數
@property (nonatomic, assign) NSInteger iBlockType;         // 封鎖狀態
@property (nonatomic, assign) NSInteger iGoodCount;          // 最後一則訊息按讚數
@property (nonatomic, assign) NSInteger iResponseCount;      // 最後一則訊息回應數
@end
