//
//  SCustomView.h
//  training
//
//  Created by 1500244 on 2015/6/15.
//  Copyright (c) 2015年 andychan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SCustomView : UIView

- (instancetype)initWithvc:(UIViewController *)vc;
-(void)showView;
-(void)hideView;
-(void)setKeyBoardHeight:(CGFloat)Height;
@end
