//
//  SPhotoViewController.m
//  training
//
//  Created by 1500244 on 2015/6/15.
//  Copyright (c) 2015年 andychan. All rights reserved.
//

#import "SPhotoViewController.h"
#import <iMessageUtility.h>
@interface SPhotoViewController ()
@property (weak, nonatomic) IBOutlet UILabel *m_promptLabel;
@property (weak, nonatomic) IBOutlet UIImageView *m_imageView;
@property (weak, nonatomic) IBOutlet UIButton *m_okButton;
@property (weak, nonatomic) IBOutlet UIButton *m_cancelButton;
@end

@implementation SPhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(messageNotification:)
                                                 name:@"R0000001"
                                               object:nil];
    self.m_imageView.image=_g_image;
    self.m_okButton.layer.cornerRadius=6;
    self.m_okButton.layer.borderWidth=3;
    self.m_okButton.layer.borderColor=[[UIColor colorWithRed:0.366 green:0.481 blue:0.314 alpha:1.000] CGColor];
    self.m_cancelButton.layer.cornerRadius=6;
    self.m_cancelButton.layer.borderWidth=3;
    self.m_cancelButton.layer.borderColor=[[UIColor colorWithRed:0.366 green:0.481 blue:0.314 alpha:1.000] CGColor];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (_g_bDownloadMode==YES) {
        self.m_promptLabel.text=@"圖片訊息";
        [self.m_okButton setImage:[UIImage imageNamed:@"Download"] forState:UIControlStateNormal];
    }else{
        self.m_promptLabel.text=@"預覽圖片";
        [self.m_okButton setImage:[UIImage imageNamed:@"Tick"] forState:UIControlStateNormal];
    }
}
- (void)messageNotification:(NSNotification *)notification{
    NSLog(@"%@",notification);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)okAction:(id)sender {
    if (_g_bDownloadMode==YES) {
        
    }else{
    [[iMessageUtility sharedManager] sendMsgWithImage:_g_image bySequenceID:nil account:@"0000001" isGroup:NO];
    [self dismissViewControllerAnimated:YES completion:nil];
    }
}
- (IBAction)cancelAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
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
