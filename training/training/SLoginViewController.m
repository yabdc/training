//
//  SLoginViewController.m
//  training
//
//  Created by 1500244 on 2015/6/10.
//  Copyright (c) 2015年 andychan. All rights reserved.
//

#import <iMessageUtility.h>

#import "SLoginViewController.h"
#import "SMessageViewController.h"
#import "SDefine.h"
#import "WaitingView.h"


@interface SLoginViewController ()<iMessageUtilityDelegte>
{
    WaitingView *m_waitingView;
}
@property (weak, nonatomic) IBOutlet UITextField *m_userTextField;
@property (weak, nonatomic) IBOutlet UITextField *m_passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *m_loginButton;

@end

@implementation SLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    m_waitingView = [[WaitingView alloc]initWithMessage:@"waiting..." andStyle:MessageStyleWhiteStyle delegate:self];
    [[iMessageUtility sharedManager] setDelegate:self];
    self.m_userTextField.text=TestUserName;
    self.m_passwordTextField.text=TestPassWord;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)loginAction:(id)sender {
    [m_waitingView showWaitingView];
    [[iMessageUtility sharedManager] doLoginWithAccount:_m_userTextField.text andPassword:_m_passwordTextField.text];
}

#pragma mark - Login methods
-(void)loginSuccess:(NSDictionary *)userInfoDic{
    if (![self isAccountSameAtLocal:_m_userTextField.text])
    {
        [IMInfoUtility clearUserAccountInfo];
        [[iMessageUtility sharedManager] reloadDatabase];
    }
    
    [IMInfoUtility setIMInfoTag:IMPassword  tagValue:_m_passwordTextField.text];
    
    [IMInfoUtility setIMInfoTag:IMAccount   tagValue:userInfoDic[@"Phone"]];
    [IMInfoUtility setIMInfoTag:IMNickname  tagValue:userInfoDic[@"Nickname"]];
    [IMInfoUtility setIMInfoTag:IMGUID      tagValue:userInfoDic[@"Guid"]];
    [IMInfoUtility setIMInfoTag:IMClientID  tagValue:userInfoDic [@"ClientID"]];
    UINavigationController *loginNavigationController =[self.storyboard instantiateViewControllerWithIdentifier:s_SLoginNavigationName];
    SMessageViewController *SMessageViewController = [[loginNavigationController viewControllers] objectAtIndex:0];
    SMessageViewController.g_strUserName = userInfoDic[@"Phone"];
    [self presentViewController:loginNavigationController
          animated:YES
          completion:nil];
}

-(void)loginFail:(NSString *)strErrorMsg{
    [m_waitingView hideWaitingView];
    [self showAlertView:NSLocalizedString(@"Fail", nil) message:strErrorMsg];
}

-(void)showAlertView:(NSString *)strTitle message:(NSString *)strMessage{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle
                                                    message:strMessage
                                                   delegate:self
                                          cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                          otherButtonTitles: nil];
    [alert show];
}


//比對輸入的帳號是否與手機記憶體中的帳號是否相同

- (BOOL)isAccountSameAtLocal:(NSString *)strAccount
{
    NSString *strLocalAccount = [IMInfoUtility getIMInfoTagValue:IMAccount];
    if (!strLocalAccount || [strAccount isEqualToString:strLocalAccount]) {
        return YES;
    }
    return NO;
}

@end
