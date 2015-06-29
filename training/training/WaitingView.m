//
//  WaitingView.m
//  KingOfWorld
//
//  Created by HY.Yang on 2015/4/26.
//  Copyright (c) 2015年 MobileIT. All rights reserved.
//

#import "WaitingView.h"
#define IsIOS8Later [[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0
@implementation WaitingView
{
    float screenHeight, screenWidth;
}
-(WaitingView *) initWithMessage:(NSString *)msg andStyle:(MessageStyle)style delegate:(UIViewController *)vc{
    
    self.delegate = vc;
    
    //取得螢幕高度&寬度
    screenHeight = [UIScreen mainScreen].bounds.size.height;
    screenWidth = [UIScreen mainScreen].bounds.size.width;
    
    //打底的blurView
    if (IsIOS8Later) {
        self = [ super initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
    }else{
        
    }
    self.frame = CGRectMake(0, 0, screenWidth, screenHeight);
    
    //message Label
    self.msg = [[UILabel alloc] initWithFrame:CGRectZero];
    self.msg.text = msg;
    //self.msg.textColor = [UIColor whiteColor];
    self.msg.font = [UIFont boldSystemFontOfSize:18.0];
    [self.msg sizeToFit];
    self.msg.frame = CGRectMake(self.center.x - self.msg.frame.size.width / 2,
                                // -5 => msg與indicator之間的間距
                                self.center.y - self.msg.frame.size.height - 5,
                                self.msg.frame.size.width,
                                self.msg.frame.size.height);
    [self addSubview:self.msg];
    
    //style change
    switch (style) {
        case MessageStyleBlackStyle:
            //activityIndicatorView
            self.indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            self.msg.textColor = [UIColor darkGrayColor];
            break;
        default:
            self.indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
            self.msg.textColor = [UIColor whiteColor];
            break;
    }
    
    self.indicator.frame = CGRectMake(self.center.x - self.indicator.frame.size.width / 2,
                                      self.center.y,
                                      self.indicator.frame.size.width,
                                      self.indicator.frame.size.height);
    [self addSubview:self.indicator];

    return self;
}

-(void) showWaitingView {
    
    [self.indicator startAnimating];
    
    //將waitingView加入主畫面
    UIViewController *vc = (UIViewController *)self.delegate;
    [vc.view addSubview:self];
    
}

-(void) hideWaitingView {
    
    [self.indicator stopAnimating];
    
    //將waitingView從主畫面移除
    [self removeFromSuperview];
    
}

@end
