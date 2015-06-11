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

@interface SLoginViewController ()<iMessageUtilityDelegte>
@property (weak, nonatomic) IBOutlet UITextField *m_userTextField;
@property (weak, nonatomic) IBOutlet UITextField *m_passwordTextField;

@end

@implementation SLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[iMessageUtility sharedManager] setDelegate:self];
    self.m_userTextField.text=TestUserName;
    self.m_passwordTextField.text=TestPassWord;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSLog(@"viewWillAppear");
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    NSLog(@"viewDidAppear");
}
-(void)viewWillDisappear:(BOOL)animated{
    NSLog(@"viewWillDisappear");
    [super viewWillDisappear:animated];
}
-(void)viewDidDisappear:(BOOL)animated{
    NSLog(@"viewDidDisappear");
    [super viewDidDisappear:animated];
}
-(void)dealloc{
    NSLog(@"dealloc");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)loginAction:(id)sender {
    [[iMessageUtility sharedManager] doLoginWithAccount:_m_userTextField.text andPassword:_m_passwordTextField.text];
}

#pragma mark - Login methods
-(void)loginSuccess:(NSDictionary *)userInfoDic{
//    NSLog(@"%@",userInfoDic);
    [IMInfoUtility setIMInfoTag:IMAccount   tagValue:userInfoDic[@"Phone"]];
    [IMInfoUtility setIMInfoTag:IMNickname  tagValue:userInfoDic[@"Nickname"]];
    [IMInfoUtility setIMInfoTag:IMGUID      tagValue:userInfoDic[@"Guid"]];
    [IMInfoUtility setIMInfoTag:IMClientID  tagValue:userInfoDic [@"ClientID"]];
    UINavigationController *loginNavigationController =[self.storyboard instantiateViewControllerWithIdentifier:@"loginNav"];
    [self presentViewController:loginNavigationController animated:YES completion:nil];
}

-(void)loginFail:(NSString *)strErrorMsg{
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


@end
