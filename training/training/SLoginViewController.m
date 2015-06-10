//
//  SLoginViewController.m
//  training
//
//  Created by 1500244 on 2015/6/10.
//  Copyright (c) 2015年 andychan. All rights reserved.
//

#import <iMessageUtility.h>

#import "SLoginViewController.h"
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)loginAction:(id)sender {
    [[iMessageUtility sharedManager] doLoginWithAccount:_m_userTextField.text andPassword:_m_passwordTextField.text];
}

#pragma mark - Login methods
-(void)loginSuccess:(NSDictionary *)userInfoDic{
    NSLog(@"%@",userInfoDic);
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
