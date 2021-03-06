//
//  SPhotoViewController.h
//  training
//
//  Created by 1500244 on 2015/6/15.
//  Copyright (c) 2015年 andychan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iMessageUtility.h>

@interface SPhotoViewController : UIViewController

@property (strong,nonatomic) UIImage *g_image;
@property (assign) BOOL g_bDownloadMode;          //YES，下載模式。NO，預覽模式。
@property (strong, nonatomic)ChatMessageItem *g_photoMessageItem;
@property(strong,nonatomic) NSString *g_strChatName;
@end
