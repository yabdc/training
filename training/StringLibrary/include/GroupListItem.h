//
//  GroupListItem.h
//  iMessageUtility
//
//  Created by 1200432s on 14/2/17.
//  Copyright (c) 2014年 Arthur Tseng. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 * GroupListItem
 * 群組列表項目內容
 */
@interface GroupListItem : NSObject

@property (nonatomic, retain) NSString *GroupID;            // 群組ID
@property (nonatomic, retain) NSString *GroupName;          // 群組名字
@property (nonatomic, retain) NSString *State;              // 群組狀態
@property (nonatomic, retain) NSString *isBusy;             // 是否為忙碌
@property (nonatomic, retain) NSString *nGMemberCount;      // 群組人數
@property (nonatomic, retain) NSString *ChairManAccount;    // 群組主席帳號
@property (nonatomic, retain) NSString *ChairManNickname;   // 群組主席姓名
@property (nonatomic, assign) NSInteger iBlockType;         // 封鎖狀態

@end
