//
//  WaitingView.h
//  KingOfWorld
//
//  Created by HY.Yang on 2015/4/26.
//  Copyright (c) 2015年 MobileIT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WaitingView : UIVisualEffectView
typedef enum messageStyleTypes
{
    MessageStyleWhiteStyle,
    MessageStyleBlackStyle
    
} MessageStyle;
@property (strong,nonatomic) UILabel *msg;
@property (strong,nonatomic) UIActivityIndicatorView *indicator;
@property (strong,nonatomic) id delegate;

-(WaitingView *) initWithMessage:(NSString *)msg andStyle:(MessageStyle)style delegate:(UIViewController *)vc;
-(void) showWaitingView;
-(void) hideWaitingView;

@end
