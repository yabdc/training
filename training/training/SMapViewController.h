//
//  SMapViewController.h
//  training
//
//  Created by 1500244 on 2015/6/15.
//  Copyright (c) 2015年 andychan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ChatMessageItem.h>
@interface SMapViewController : UIViewController
@property(strong,nonatomic) ChatMessageItem *g_mapMessageItem;
@property (assign) BOOL g_bBrowseMode;          //YES，瀏覽模式。NO，傳送地址模式。
@end
