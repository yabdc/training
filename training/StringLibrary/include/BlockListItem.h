//
//  BlockListItem.h
//  iMessageUtility
//
//  Created by 1200432AArthur on 2014/9/30.
//  Copyright (c) 2014年 Arthur Tseng. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 * 封鎖 內容類別
 */
typedef NS_ENUM(NSInteger, ChatBlockType)
{
    ChatBlockTypeNormal,            // 解除封鎖 //所有型別
    ChatBlockTypeUserDefine,        // 使用者自訂
    ChatBlockTypeSlient,            // 靜音
    ChatBlockTypeNotificationOff,   // 關閉推播
    ChatBlockTypeBlock,             // 封鎖
};

typedef NS_ENUM(NSInteger, ChatBlockAccountType)
{
    ChatBlockAccountTypeUser,       // 一般使用者
    ChatBlockAccountTypeGroup,      // 會議室(群組)
    ChatBlockAccountTypeEnt,        // 企業訊息
};

@interface BlockListItem : NSObject

@property (retain, nonatomic) NSString *BlockAccount;
@property (retain, nonatomic) NSString *BlockSound;
@property (assign, nonatomic) ChatBlockType BlockAccountType;
@property (assign, nonatomic) ChatBlockAccountType BlockBlockType;

@end
