//
//  ChatMessageItem.h
//  iMessageUtility
//
//  Created by 1200432s on 13/6/24.
//  Copyright (c) 2013年 Arthur Tseng. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * ChatMessageItem
 * 對話內容
 */
@interface ChatMessageItem : NSObject

@property (nonatomic, retain) NSString *SequenceID;           // 訊息在資料庫中的編號順序
@property (nonatomic, retain) NSString *ChatID;               // 訊息在Server中的編號順序
@property (nonatomic, retain) NSString *MessageID;            // 訊息在Server中的編號順序
@property (nonatomic, retain) NSString *isMySpeaking;         // 此訊息發信人是否為自己
@property (nonatomic, retain) NSString *Content;              // 訊息內容
@property (nonatomic, retain) NSString *DataTime;             // 訊息發送日期
@property (nonatomic, retain) NSString *isReaded;             // 訊息讀取狀態
@property (nonatomic, retain) NSString *isSuccess;            // 訊息傳送狀態 0:傳送中/1:傳送失敗/2:傳送成功
@property (nonatomic, retain) NSString *SayPhone;             // 發信人帳號
@property (nonatomic, retain) NSString *ContentType;          // 訊息類別 文字/圖片/位置資訊/表情符號
@property (nonatomic, retain) NSString *Funkey;               // 訊息檔案形式
@property (nonatomic, retain) NSString *FunBody;              // 訊息檔案內容
@property (nonatomic, retain) NSString *Nickname;             // 發信人姓名
@property (nonatomic, retain) NSString *isMemberChairman;     // 發信人是否為主席
@property (nonatomic, retain) NSString *UnReadCount;          // 未讀訊息則數

@end
