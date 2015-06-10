//
//  BuddyListItem.h
//  iMessageUtility
//
//  Created by 1200432s on 13/6/27.
//  Copyright (c) 2013年 Arthur Tseng. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * BuddyListItem
 * 好友列表項目內容
 */
@interface BuddyListItem : NSObject

@property (nonatomic, retain) NSString *Nickname;       // 好友姓名
@property (nonatomic, retain) NSString *Phone;          // 好友帳號
@property (nonatomic, retain) NSString *bGroupType;     // 是否為群組
@property (nonatomic, retain) NSString *nGMemberCount;  // 群組人數
@property (nonatomic, retain) NSString *State;          // 好友狀態
@property (nonatomic, retain) NSString *isBusy;         // 好友是否忙碌
@property (nonatomic, assign) NSInteger iBlockType;     // 封鎖狀態

@end
