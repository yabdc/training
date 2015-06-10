//
//  iMessageUtility.h
//  iMessageUtility
//
//  Created by 1200432s on 13/6/11.
//  Copyright (c) 2013年 Arthur Tseng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "ConnUtility.h"
#import "IMInfoUtility.h"
#import "IMStartUpData.h"

#import "PushListItem.h"
#import "MessageListItem.h"
#import "BuddyListItem.h"
#import "ChatMessageItem.h"
#import "GroupListItem.h"
#import "StickerSerialItem.h"
#import "StickerItem.h"
#import "BlockListItem.h"
#import "OfficialListItem.h"

#import "iWowMsgParser.h"
#import "iMFileUploadUtility.h"

#define USER_INFO_NOTIFICATION          @"UserInfoNotification"
#define OFFICIAL_INFO_NOTIFICATION      @"OfficialInfoNotification"
#define PUSH_LIST_NOTIFICATION          @"PushListNotification"
#define AUTH_FAIL_NOTIFICATION          @"AuthFaildNotification"
#define MSG_LIST_NOTIFICATION           @"MessageListNotification"
#define BUDDY_LIST_NOTIFICATION         @"BuddyListNotification"
#define GROUP_MEMEBER_LIST_NOTIFICATION @"GroupMemberListNotification"

#define IMAGE_CONTENT_TAG               @"Image"

/*推播訊息 內容類別*/
typedef enum {
    Notification_Content_Personal = 0,  // 個人訊息
    Notification_Content_Tx01,
    Notification_Content_Group,         // 群組訊息
    Notification_Content_Tx03,
    Notification_Content_Enterprise,    // 企業訊息
} Notification_Content_Type;

/*對話訊息 內容類別*/
typedef enum {
    BubbleView_Content_Text = 0,        // 文字訊息
    BubbleView_Content_Picture,         // 圖片訊息
    BubbleView_Content_Location,        // 位置訊息
    BubbleView_Content_HTML,
    BubbleView_Content_Group,           // 群組提示訊息
    BubbleView_Content_Sticker,         // 貼圖訊息
    BubbleView_Content_URL,
    BubbleView_Content_XML,
} BubbleView_Content_Type;

@protocol iMessageUtilityDelegte <NSObject>
@optional
// 登入
- (void)loginSuccess:(NSDictionary *)userInfoDic;
- (void)loginFail:(NSString *)strErrorMsg;
// 取得啟動資料
- (void)getStartUpDataSuccess:(BOOL)bChange;
- (void)getStartUpDataFail:(NSString *)strErrorMsg;
// 取得版號
- (void)getAppVersionSuccess:(NSDictionary *)rtnDataDic;
- (void)getAppVersionFail:(NSString *)strErrorMsg;
// 取得貼圖資料
- (void)getStickerSuccess;
- (void)getStickerFail:(NSString *)strErrorMsg;
// 取得詳細企業訊息
- (void)getPushDetailContentSuccess:(NSDictionary *)rtnDataDic;
- (void)getPushDetailContentFail:(NSString *)strErrorMsg;
// 刪除企業訊息項目
- (void)deletePushListMsgSuccess;
- (void)deletePushListMsgFail:(NSString *)strErrorMsg;
// 刪除最新訊息
- (void)deleteLastestMsgSuccess;
- (void)deleteLastestMsgFail:(NSString *)strErrorMsg;
// 搜尋好友
- (void)searchBuddySuccess:(NSMutableArray *)arRtnData;
- (void)searchBuddyFail:(NSString *)strErrorMsg;
// 新增好友
- (void)addBuddySuccess;
- (void)addBuddyFail:(NSString *)strErrorMsg;
// 新增群組
- (void)addGroupSuccess:(NSDictionary *)rtnDataDic;
- (void)addGroupFail:(NSString *)strErrorMsg;
// 取得群組資訊
- (void)getGroupInfoSuccess:(BOOL)bIsGroupClosed;
- (void)getGroupInfoFail:(NSString *)strErrorMsg;
// 修改群組人數
- (void)setGroupMemberCount:(NSInteger)iGroupMemerCount;
// 設定群組
- (void)setGroupSuccess:(NSDictionary *)rtnDataDic;
- (void)setGroupFail:(NSString *)strErrorMsg;
// 關閉/離開群組
- (void)deleteGroupSuccess;
- (void)deleteGroupFail:(NSString *)strErrorMsg;
// 離開群組
- (void)leaveGroupSuccess;
- (void)leaveGroupFail:(NSString *)strErrorMsg;
// 刪除好友/群組
- (void)deleteBuddiesSuccess;
- (void)deleteBuddiesFail:(NSString *)strErrorMsg;
// 下載圖片
- (void)downloadFileProgress:(NSNumber *)progress;
- (void)downloadFileSuccess:(NSData *)fileData;
- (void)downloadFileFail:(NSString *)strErrorMsg;
// 更新user成員資訊
- (void)updateUsersInfo:(NSArray *)arUsersInfo;

// 對話設定
// 取得封鎖列表設定
- (void)getBlockListSuccess;
- (void)getBlockListFail:(NSString *)strErrorMsg;

// 設定封鎖狀態
- (void)setBlockTypeSuccess:(NSDictionary *)reqDataDic;
- (void)setBlockTypeFail:(NSString *)strErrorMsg;

// 推播通知聲音狀態
- (void)setChatSettingSoundsSuccess;
- (void)setChatSettingSoundsFail:(NSString *)strErrorMsg;
// 推播通知狀態
- (void)setChatSettingNotificationSuccess;
- (void)setChatSettingNotificationFail:(NSString *)strErrorMsg;
// 封鎖狀態
- (void)setChatSettingBlockSuccess;
- (void)setChatSettingBlockFail:(NSString *)strErrorMsg;

// 按讚
- (void)sayGoodSuccess:(NSDictionary *)rtnDataDic;
- (void)sayGoodFail:(NSString *)strErrorMsg;

// 留言
- (void)messageResponseSuccess:(NSDictionary *)rtnDataDic;
- (void)messageResponseFail:(NSString *)strErrorMsg;
- (void)getMessageResponseListSuccess:(NSDictionary *)rtnDataDic;
- (void)getMessageResponseListFail:(NSString *)strErrorMsg;

// 大頭照
- (void)setProfileSuccess:(NSDictionary *)rtnDataDic;
- (void)setProfileFail:(NSString *)strErrorMsg;

//登出
- (void)setLogoutSuccess:(NSDictionary *)rtnDataDic;
- (void)setLogoutFail:(NSString *)strErrorMsg;


// 同意書
- (void)setDocumentAgreementSuccess:(NSDictionary *)rtnDataDic;
- (void)setDocumentAgreementFail:(NSString *)strErrorMsg;

/**
 * 更新未讀訊息則數
 *
 * iBroadcast:企業訊息未讀則數
 * iTotal:所有訊息未讀則數
 */
- (void)getBroadcastUnReadCount:(NSInteger)iBroadcast TotalUnreadCount:(NSInteger)iTotal;
@end

@class FMDatabase;

@interface iMessageUtility : NSObject <iWMParserDelegate, iMUploadDelegate>
{
    FMDatabase* _db;
    id<iMessageUtilityDelegte> delegate;
    
    NSArray *m_arDeletePushMsgList;
    NSArray *m_arDeleteLastestMsgList;
    NSArray *m_arDeleteBuddies;
    NSArray *m_arDeleteGroups;
    
    NSMutableData *httpResponse;
    
    NSString *m_updateUsetInfoTag;
}

@property (nonatomic, assign) id<iMessageUtilityDelegte> delegate;
@property (nonatomic, retain) NSMutableArray *m_arStickerSerial;

+ (iMessageUtility*)sharedManager;
- (NSString *)getUUID;

/**
 * 設定Message Server 連線位址
 * IMWebServiceURL:Message server位址
 */
- (void)setMessageServerSite:(NSString *)strSite;


#pragma mark -
#pragma mark Path Methods
// 建立資料夾
- (void)loadPath;
- (UIImage*)loadPushListItemImage:(NSString*)title;

#pragma mark -
#pragma mark Database Methods
// 建立資料庫
- (void)loadDatabase;
// 刪除資料庫
- (void)deleteDatabase;
// 刪除原有資料庫並建立資料庫
- (void)reloadDatabase;
// 刪除資料表
- (BOOL)deleteTableWithName:(NSString *)tableName;
// 將資料庫內所對話table內的傳送中欄位改為傳送失敗
- (void)checkDataBaseAllTable;

#pragma mark -
#pragma mark PushList table methods

/**
 * 取得企業訊息列表Icon
 */
- (UIImage*)queryPushListIconWithAccount:(NSString*)account;

/**
 * 取得企業訊息列表資料總數
 */
- (int)queryPushListTableCount;

/**
 * 取得企業訊息列表資料總數
 * type為取得種類設定
 */
- (int)queryPushListTableCountWithType:(NSString*)type;

/**
 * 取得企業訊息列表資料
 * limit為取得筆數上限
 * 資料按照發送時間由新到舊排序
 */
- (NSMutableArray *)queryPushListTableWithLimit:(int)limit;

/**
 * 取得頭像
 */
- (NSMutableArray *)queryUsersInfoTable;
/**
 * 取得企業訊息列表資料(yuanta)
 * limit為取得筆數上限
 * type為取得種類設定
 * 資料按照發送時間由新到舊排序
 */
- (NSMutableArray *)queryPushListTableWithLimit:(int)limit WithType:(NSString*)type;


/**
 * 取得企業訊息列表回補最新資料
 * ChatId為所要取得資料基準
 * 資料按照發送時間由新到舊排序
 */
- (NSMutableArray *)queryPushListTableGreaterChatId:(NSString*)chatid;

/**
 * 取得企業訊息列表回補最新資料(load more)
 * ChatId為所要取得資料基準
 * 資料按照發送時間由新到舊排序
 */
- (NSMutableArray *)queryPushListTableGreaterChatId:(NSString*)chatid WithType:(NSString*)type;

/**
 * 取得企業訊息列表舊資料(load more)
 * ChatId為所要取得資料基準
 * limit為取得筆數上限
 * 資料按照發送時間由新到舊排序
 */
- (NSMutableArray *)queryPushListTableLessThanChatId:(NSString*)chatid WithLimit:(int)limit;

/**
 * 取得企業訊息列表舊資料(load more)(yuanta)
 * ChatId為所要取得資料基準
 * limit為取得筆數上限
 * 資料按照發送時間由新到舊排序
 */
- (NSMutableArray *)queryPushListTableLessThanChatId:(NSString*)chatid WithLimit:(int)limit WithType:(NSString*)type;

/**
 * 取得企業訊息未讀則數
 * limit為筆數限制上限
 */
- (NSString *)queryUnreadMsgCountFromPushListTable:(int)limit;


// 檢查企業訊息table訊息筆數是否超過上限
- (void)checkPushListTableTotalRecordsWithLimit:(int)limit;

// 檢查企業訊息table訊息所有種類筆數是否超過上限
- (void)checkPushListTableTotalTypeRecordsWithLimit:(int)limit;

#pragma mark -
#pragma mark MessageList table methods
/**
 * 取得最新訊息列表資料
 * limit為取得筆數上限
 * 資料按照發送時間由新到舊排序
 */
- (NSMutableArray *)queryMessageListTableWithLimit:(int)limit;

/**
 * 取得最新訊息未讀則數
 */
- (NSString *)queryUnreadMsgCountFromMessageListTable;

// 刪除最新訊息列表內單一訊息，並清空此聯絡人之對話記錄
- (void)deleteLastestMsgFromMessageListTableByPhone:(NSString *)phone withLatestChatId:(NSString*)chatId;
// 檢查最新訊息table訊息筆數是否超過上限
- (void)checkMessageListTableTotalRecordsWithLimit:(int)limit;

#pragma mark -
#pragma mark BuddyList table methods
// 取得群組列表
- (NSMutableArray *)queryGroupFromBuddyListTable;
// 取得好友列表
- (NSMutableArray *)queryBuddyFromBuddyListTable;
// 刪除單一好友
- (void)deleteBuddyFromBuddyListTableByPhone:(NSString *)phone;
// 此好友是否在好友列表中
- (BOOL)isBuddyPhoneExistInBuddyListTable:(NSString *)buddyPhone;

#pragma mark -
#pragma mark Group methods
/*群組*/
// 確認群組成員table是否存在
- (void)checkGroupMemberTableIsExisted:(NSString *)tableName;

/**
 * 取得群組主席
 * groupID為群組編號
 */
- (NSMutableArray *)queryChairmanFromGroupListTable:(NSString *)groupID;

/**
 * 取得群組成員
 * groupID為群組編號
 */
- (NSMutableArray *)queryMemberFromGroupListTable:(NSString *)groupID;

/**
 * 判斷手機使用者是否為主席
 * groupID為群組編號
 */
- (BOOL)isChairmanOfGroup:(NSString *)groupID;

// 取得使用者帳號所建立的群組列表
- (NSMutableArray *)queryGroupFromGroupIndex;
// 由GroupID取得成員列表
- (NSArray *)queryBuddyListByGroupID:(NSString *)groupID;
// 回補群組對話訊息
- (NSMutableArray *)queryRecordsFromGroupTable:(NSString *)groupID withLimit:(int)limit;

#pragma mark -
#pragma mark Chat table methods
// 確認對話table是否存在
- (void)checkChatTableIsExisted:(NSString *)account isGroup:(BOOL)bIsGroup;
// 回補對話訊息(含群組)
- (NSMutableArray *)queryChatsFromTableByAccount:(NSString *)account isGroup:(BOOL)bISGroup withLimit:(int)limit;
// 載入之前訊息(含群組)
- (NSMutableArray *)queryChatsFromTableByAccount:(NSString *)account isGroup:(BOOL)bISGroup withLimit:(int)limit beforeSequenceID:(int)sequenceID;
// 載入之後訊息(含群組)
- (NSMutableArray *)queryChatsFromTableByAccount:(NSString *)account isGroup:(BOOL)bISGroup withLimit:(int)limit afterSequenceID:(int)sequenceID;
// 取得訊息總筆數(含群組)
- (NSInteger)queryRecordsCountFromChatTable:(NSString *)account isGroup:(BOOL)bISGroup;
// 取得所有未讀訊息之chatID(含群組)
- (NSMutableArray *)queryUnreadMsgChatIDFromChatTable:(NSString *)account isGroup:(BOOL)bISGroup;
// 刪除單一訊息(含群組)
- (void)deleteRecordFromChatTable:(NSString *)account isGroup:(BOOL)bISGroup bySequenceID:(int)sequenceID;
// 檢查對話table訊息筆數是否超過上限(含群組)
- (void)checkChatTableTotalRecords:(NSString *)account isGroup:(BOOL)bISGroup withLimit:(int)limit;
// 取得最後一筆訊息之chatID (含群組)
- (NSString *)queryLastChatIDFromChatTable:(NSString *)account isGroup:(BOOL)bISGroup;
// 取得群組名稱
- (NSString *)queryGroupNameByGroupID:(NSString *)groupID;
// 取得群組成員人數
- (NSInteger)queryGroupMemberCountByGroupID:(NSString *)groupID;

//===================
// 回補對話訊息
- (NSMutableArray *)queryRecordsFromChatTable:(NSString *)tableName withLimit:(int)limit;
// 載入之前訊息
- (NSMutableArray *)queryRecordsFromChatTable:(NSString *)tableName withLimit:(int)limit beforeSequenceID:(int)sequenceID;
- (NSMutableArray *)queryRecordsFromChatTable:(NSString *)tableName withLimit:(int)limit afterSequenceID:(int)sequenceID;
// 取得訊息總筆數
- (NSInteger)queryRecordsCountFromChatTable:(NSString *)tableName;
// 取得所有未讀訊息之chatID
- (NSMutableArray *)queryUnreadMsgChatIDFromChatTable:(NSString *)tableName;
// 刪除單一訊息
- (void)deleteRecordFromChatTable:(NSString *)tableName bySequenceID:(int)sequenceID;
// 檢查對話table訊息筆數是否超過上限
- (void)checkChatTableTotalRecords:(NSString *)tableName withLimit:(int)limit;
// 取得最後一筆訊息之chatID
- (NSString *)queryLastChatIDFromChatTable:(NSString *)account;
// 取得群組對話最後一筆訊息之chatID
- (NSString *)queryLastChatIDFromGroupChatTable:(NSString *)strGroupID;
//====================

#pragma mark - Web serivce Methods

// 註冊Token
- (void)updateToken:(NSData *)deviceToken;


#pragma mark
#pragma mark - Logout methods
/**
 * 登出認證 <iMessageUtilityDelegte>
 * 成功  - (void)setLogoutSuccess:(NSDictionary *)rtnDataDic;
 * 失敗  - (void)setLogoutFail:(NSString *)strErrorMsg;
 */
- (void)doLogoutFromWS;
#pragma mark
#pragma mark - Login methods
/**
 * 登入認證 <iMessageUtilityDelegte>
 * 成功 -(void)loginSuccess:(NSDictionary *)userInfoDic;
 * 失敗 -(void)loginFail:(NSString *)strErrorMsg;
 */
- (void)doLoginWithAccount:(NSString *)account andPassword:(NSString *)password;

/**
 * 登入認證(元大) <iMessageUtilityDelegte>
 * 成功 -(void)loginSuccess:(NSDictionary *)userInfoDic;
 * 失敗 -(void)loginFail:(NSString *)strErrorMsg;
 */
- (void)doLoginWithAccount:(NSString *)account andPassword:(NSString *)password andChannel:(NSString *)channel;

#pragma mark
#pragma mark - StartUp methods
/**
 * 取得啟動資料 <iMessageUtilityDelegte>
 * 成功 -(void)getStartUpDataSuccess:(BOOL)change;
 * 失敗 -(void)getStartUpDataFail:(NSString *)strErrorMsg;
 */
- (void)getStartUpDataFromeWSScreenCX:(CGFloat)width ScreenCY:(CGFloat)height;

/**
 * 取得版號 <iMessageUtilityDelegte>
 * 成功 -(void)getAppVersionSuccess:(NSDictionary *)rtnDataDic;
 * 失敗 -(void)getAppVersionFail:(NSString *)strErrorMsg;
 */
- (void)getAppVersionFromWS;


#pragma mark - Sticker methods
/**
 * 取得貼圖所有系列資料 <iMessageUtilityDelegte>
 * 成功 -(void)getStickerSuccess;
 * 失敗 -(void)getStickerFail:(NSString *)strErrorMsg;
 */
- (void)getStickerSerialListFromWS;

/**
 * 從資料庫內取得貼圖所有系列資料
 */
- (NSMutableArray *)queryStickerSerialListTable;

/**
 * 從資料庫中取得stickerTableName貼圖系列的個數
 */
- (NSInteger)queryStickerNumberByTableName:(NSString *)stickerTableName;

/**
 * 從資料庫中取得stickerTableName貼圖系列資料
 */
- (NSMutableArray *)queryStickerListByTableName:(NSString *)stickerTableName;

/**
 * 從資料庫中取得stickerTableName貼圖系列中編號index的貼圖
 */
- (UIImage *)queryStickerImageByByTableName:(NSString *)stickerTableName index:(NSInteger)index;

#pragma mark -
#pragma mark UserInfo methods
/**
 */
- (void)getUserInfoFromWS:(NSArray *)arUserAccounts;

#pragma mark -
#pragma mark PushList methods
/**
 * 取得企業訊息及所有訊息未讀則數 <iMessageUtilityDelegte>
 * - (void)getBroadcastUnReadCount:(NSInteger)iBroadcast TotalUnreadCount:(NSInteger)iTotal;
 */
- (void)getUnreadCountFromWS;

/**
 * 取得企業訊息列表
 * 需註冊NSNotificationCenter defaultCenter
 * Name:PUSH_LIST_NOTIFICATION
 */
- (void)getPushListFromWS;

/**
 * 刪除企業訊息列表項目 <iMessageUtilityDelegte>
 * 成功 -(void)deletePushListMsgSuccess;
 * 失敗 -(void)deletePushListMsgFail:(NSString *)strErrorMsg;
 */
- (void)deletePushMsgListFromWS:(NSArray *)arPushMsgList;

/**
 * 取得企業訊息詳細內容 <iMessageUtilityDelegte>
 * 成功 -(void)getPushDetailContentSuccess:(NSDictionary *)rtnDataDic;
 * 失敗 -(void)getPushDetailContentFail:(NSString *)strErrorMsg;
 */
- (void)getPushDetailContentFromWS:(NSString *)strChatID;

#pragma mark -
#pragma mark MessageList methods
/**
 * 取得最新訊息列表
 * 需註冊NSNotificationCenter defaultCenter
 * Name:MSG_LIST_NOTIFICATION
 */
- (void)getMessageListFromWS;

/**
 * 刪除最新訊息列表訊息項目 <iMessageUtilityDelegte>
 * 成功 -(void)deleteLastestMsgSuccess;
 * 失敗 -(void)deleteLastestMsgFail:(NSString *)strErrorMsg;
 */
- (void)deleteLastestMsgListFromWS:(NSArray *)arLastestMsgList;


#pragma mark -
#pragma mark OfficialList methods

/**
 * 取得官方狀態列表
 * 需註冊NSNotificationCenter defaultCenter
 * Name:MSG_LIST_NOTIFICATION
 */
- (void)getOfficialListFromWS;


/**
 * 從資料庫中取得官方狀態列表資料
 */
- (NSMutableArray *)queryOfficialTable;

#pragma mark -
#pragma mark BuddyList methods
/**
 * 取得好友列表
 * 需註冊NSNotificationCenter defaultCenter
 * Name:BUDDY_LIST_NOTIFICATION
 */
- (void)getBuddyListFromWS;

/**
 * 取得群組列表
 * 需註冊NSNotificationCenter defaultCenter
 * Name:BUDDY_LIST_NOTIFICATION
 */
- (void)getGroupListFromWS;

/**
 * 刪除好友/會議室列表項目 <iMessageUtilityDelegte>
 * 成功 -(void)deleteBuddiesSuccess;
 * 失敗 -(void)deleteBuddiesFail:(NSString *)strErrorMsg;
 */
- (void)deleteBuddiesFromWSWithGroupList:(NSArray *)arGroupAccounts buddyList:(NSArray *)arBuddyAccounts;
// 刪除好友
- (void)deleteBuddiesFromWS:(NSArray *)arBuddyList;

/**
 * 新增好友 <iMessageUtilityDelegte>
 * 成功 -(void)addBuddySuccess;
 * 失敗 -(void)addBuddyFail:(NSString *)strErrorMsg;
 */
// 單選新增好友
- (void)addNewBuddyFromWSByName:(NSString*)Nickname andAccount:(NSString*)Phone;
// 多選新增好友
- (void)addNewBuddyFromWS:(NSArray *)arBuddyList;

/**
 * 搜尋好友 <iMessageUtilityDelegte>
 * 成功 -(void)searchBuddySuccess:(NSMutableArray *)arRtnData;
 * 失敗 -(void)searchBuddyFail:(NSString *)strErrorMsg;
 */
- (void)searchBuddyWithKeywordFromWS:(NSString *)strKeyword;

// 取得自己建立的群組列表
- (void)getGroupIndexFromWS;

#pragma mark -
#pragma mark Group methods
/**
 * 新增群組 <iMessageUtilityDelegte>
 * 成功 -(void)addGroupSuccess;
 * 失敗 -(void)addGroupFail:(NSString *)strErrorMsg;
 */
- (void)addGroupFromWSByGroupName:(NSString *)groupName andMember:(NSArray *)arBuddyList;

/**
 * 修改/設定群組 <iMessageUtilityDelegte>
 * 成功 -(void)setGroupSuccess;
 * 失敗 -(void)setGroupFail:(NSString *)strErrorMsg;
 */
- (void)setGroupFromWSByGroupID:(NSString *)groupID GroupName:(NSString *)groupName addMemeber:(NSArray *)arAddBuddyList deleteMember:(NSArray *)arDeleteBuddyList;

/**
 * 取得群組資訊 <iMessageUtilityDelegte>
 * 成功 -(void)getGroupInfoSuccess:(BOOL)bIsGroupClosed;
 * 失敗 -(void)getGroupInfoFail:(NSString *)strErrorMsg;
 */
- (void)getGroupInfoFromWS:(NSString *)GroupAccount;

/**
 * 關閉/離開群組 <iMessageUtilityDelegte>
 * 成功 (void)deleteGroupSuccess;
 * 失敗 (void)deleteGroupFail:(NSString *)strErrorMsg;
 */
// 關閉群組
- (void)deleteGroupFromWSByGroupID:(NSString *)groupID;
// 離開群組
- (void)leaveGroupFromWSByGroupID:(NSString *)groupID;

#pragma mark -
#pragma mark ChatList methods
/**
 * 取得個人對話
 * 需註冊NSNotificationCenter defaultCenter
 * Name:N+聊天對象帳號
 */
- (void)getChatListByPhoneFromWS:(NSString *)strPhone;

/**
 * 取得群組對話
 * 需註冊NSNotificationCenter defaultCenter
 * Name:N+GroupID
 */
- (void)getGroupChatListByGroupIDFromWS:(NSString *)strGroupID;

/**
 * 傳送訊息/傳送群組訊息
 * 需註冊NSNotificationCenter defaultCenter
 * Name:N+聊天對象帳號或GroupID
 *
 * 訊息類別參考:BubbleView_Content_Type
 */
- (ChatMessageItem *)sendMsgWithContent:(NSString *)content ContentType:(int)contentType bySequenceID:(NSString *)sequenceID toPhone:(NSString *)toPhone;
- (ChatMessageItem *)sendGroupMsgWithContent:(NSString *)content ContentType:(int)contentType SequenceID:(NSString *)sequenceID GroupID:(NSString *)groupID;

/**
 * 對話訊息讀取狀態
 * 需註冊NSNotificationCenter defaultCenter
 * Name:R+聊天對象帳號(GroupID)
 */
- (void)checkChatMsgIsReadedFromWS:(NSArray *)arChatID;

#pragma mark -
#pragma mark Upload Picture methods
// 傳送圖片訊息
- (ChatMessageItem *)sendMsgWithImage:(UIImage *)image bySequenceID:(NSString *)sequenceID toPhone:(NSString *)toPhone;

//========================
/**
 * 傳送圖片訊息(含群組)
 * 需註冊NSNotificationCenter defaultCenter
 * Name:R+聊天對象帳號(GroupID)
 */
- (ChatMessageItem *)sendMsgWithImage:(UIImage *)image bySequenceID:(NSString *)sequenceID account:(NSString *)account isGroup:(BOOL)bIsGroup;

#pragma mark - Chat Setting Methods

/**
 * 取得封鎖列表
 * 成功 -(void)getBlockListSuccess;
 * 失敗 -(void)getBlockListFail:(NSString *)strErrorMsg;
 */
- (void)getBlockListFromWS:(ChatBlockType)blockType;

/**
 * 封鎖帳號
 * 成功 - (void)setBlockTypeSuccess:(NSDictionary *)reqDataDic;
 * 失敗 -(void)setBlockTypeFail:(NSString *)strErrorMsg;
 */
- (void)setBlockTypeFromWS:(NSArray *)arBlockList;

/**
 * 從資料庫中取得此好友/會議室(群組)/企業訊息的封鎖狀態
 */
- (BlockListItem *)getBlockTypeWithAccount:(NSString *)account accountType:(ChatBlockAccountType)type;
- (NSMutableArray *)getBlockListFromBlockList;
- (NSMutableDictionary*)getAllBlockTypeFromBlockList;

/**
 * 對企業訊息按讚 <iMessageUtilityDelegte>
 * 成功 -(void)sayGoodSuccess:(NSDictionary *)rtnDataDic;
 * 失敗 -(void)sayGoodFail:(NSString *)strErrorMsg;
 */
- (void)sayGoodFromWS:(NSString *)strChatID isCancel:(BOOL)bIsCancel;

/**
 * 對企業訊息留言 <iMessageUtilityDelegte>
 * 成功 -(void)messageResponseSuccess:(NSDictionary *)rtnDataDic;
 * 失敗 -(void)messageResponseFail:(NSString *)strErrorMsg;
 */
- (void)messageResponseFromWS:(NSString *)strChatID message:(NSString *)strMessage;

/**
 * 取得企業訊息留言列表 <iMessageUtilityDelegte>
 * 成功 -(void)getMessageResponseListSuccess:(NSDictionary *)rtnDataDic;
 * 失敗 -(void)getMessageResponseListFail:(NSString *)strErrorMsg;
 */
- (void)getMessageResponseListFromWS:(NSString *)strChatID;

/**
 * 上傳大頭照<iMessageUtilityDelegte>
 * 成功 -(void)setProfileSuccess:(NSDictionary *)rtnDataDic;
 * 失敗 -(void)setProfileFail:(NSString *)strErrorMsg;
 */
- (void)setProfileFromWS:(UIImage *)avatarImage isGroup:(NSString *)strGroupId;

@end
