//
//  SDefine.h
//  training
//
//  Created by 1500244 on 2015/6/10.
//  Copyright (c) 2015年 andychan. All rights reserved.
//

#ifndef training_SDefine_h
#define training_SDefine_h

#define TestUserName @"0000002"
#define TestPassWord @"0000002"
#define KeyBoardMoveTime    0.25      //鍵盤移動時間
#define AnimationTime 0.25
#define MaxHeightOfTextView 80.0f
#define TestChat @"0000001"
//字數限制
#define StringLengthLimit 100
//螢幕
#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height
//地圖可見大小
#define MapArea 2000.0f
//預設Cell高度
#define PresetCellHeight 100
//按鈕預設生成大小
#define ButtonInit 100
//預載數量
#define PresetMessageCount 20
//字體大小
#define MessageFont 14.0
#define DateFont 11.0
//發話者
#define Self @"1"
//訊息類別
#define TextMessage @"0"
#define ImageMessage @"1"
#define AddressMessage @"2"
//訊息
#define Padding 10
#define ToCellLeft 10
#define ToCellTop 10
#define TopPaddingMessageContent 15
#define LeftPaddingMessageContent 20
#define MaxWidthOfLabel 240
#define MaxWidthOfAddress 200
//圖片延展
#define TopEdgeInset 15
#define LeftEdgeInset 25
#define BottomEdgeInset 30
#define RightEdgeInset 25
//storyboard上controller 名子
static NSString *s_SLoginViewControllerName=@"SloginView";
static NSString *s_SLoginNavigationName=@"loginNav";
static NSString *s_SMapViewControllerName=@"SMapView";
static NSString *s_SPhotoViewControllerName=@"SPhotoView";
//伺服器設定
static NSString *const s_AppId = @"FA00IM_iOS";
static NSString *const s_ServerSite = @"smuat.megatime.com.tw/WebServiceSsl";
//ios版本
#define IsIOS8Later [[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0
#endif
