//
//  SPhotoViewController.m
//  training
//
//  Created by 1500244 on 2015/6/15.
//  Copyright (c) 2015年 andychan. All rights reserved.
//

#import "SPhotoViewController.h"
#import <iMFileDownloadUtility.h>
#import "SDefine.h"
@interface SPhotoViewController ()<iMDownloadDelegate>
@property (weak, nonatomic) IBOutlet UILabel *m_promptLabel;
@property (weak, nonatomic) IBOutlet UIImageView *m_imageView;
@property (weak, nonatomic) IBOutlet UIProgressView *m_progressView;
@property (weak, nonatomic) IBOutlet UIButton *m_okButton;
@property (weak, nonatomic) IBOutlet UIButton *m_cancelButton;
@property (strong, nonatomic) iMFileDownloadUtility *m_fileDownload;
@end

@implementation SPhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.m_okButton.layer.cornerRadius=6;
    self.m_okButton.layer.borderWidth=3;
    self.m_okButton.layer.borderColor=[[UIColor colorWithRed:0.366 green:0.481 blue:0.314 alpha:1.000] CGColor];
    self.m_cancelButton.layer.cornerRadius=6;
    self.m_cancelButton.layer.borderWidth=3;
    self.m_cancelButton.layer.borderColor=[[UIColor colorWithRed:0.366 green:0.481 blue:0.314 alpha:1.000] CGColor];
    if (_g_bDownloadMode==YES) {
        self.m_fileDownload = [[iMFileDownloadUtility alloc] init];
        self.m_fileDownload.delegate = self;
        self.m_okButton.enabled = NO;
    }else{
        NSString *strMessageNotification=[NSString stringWithFormat:@"R%@",_g_strChatName];
        self.m_progressView.hidden=YES;
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(messageNotification:)
                                                     name:strMessageNotification
                                                   object:nil];
        self.g_image=[self imageWithImageSimple:_g_image scaledToSize:CGSizeMake(ScreenWidth, ScreenWidth/_g_image.size.width*_g_image.size.height)];
    }
    
    NSLog(@"%@",_g_image);
    self.m_imageView.image=_g_image;
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


- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (_g_bDownloadMode==YES) {
    [self.m_fileDownload downloadPictureName:self.g_photoMessageItem.FunBody withChatID:self.g_photoMessageItem.ChatID];
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
        UIImageWriteToSavedPhotosAlbum ( self.m_imageView.image, nil, nil, nil );
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        [[iMessageUtility sharedManager] sendMsgWithImage:_g_image bySequenceID:nil account:_g_strChatName isGroup:NO];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}
- (IBAction)cancelAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)iMDownloadProgress:(NSNumber *)progress{
    self.m_progressView.hidden = NO;
    
    self.m_progressView.progress = [progress floatValue];
    
    if (1.0 == [progress floatValue]) {
        self.m_progressView.hidden = YES;
        self.m_okButton.enabled = YES;
    }
}
- (void)iMDownloadFailWithError:(NSString *)strError{
    
}
- (void)iMDownloadResponse:(NSData *)rtnFileData{
    
    UIImage *image = [UIImage imageWithData:rtnFileData];
    
    [self.m_imageView  setImage:image];
    
}

- (UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize
{
    float width,height;
    if (image.size.width<newSize.width && image.size.height<newSize.height){
        //如果已經小於newSize則不縮小
        width=image.size.width;
        height=image.size.height;
    }else if (image.size.height >= (newSize.height/newSize.width)*image.size.width){
        width=image.size.width/image.size.height*newSize.height;
        height=newSize.height;
    }else{
        height=image.size.height/image.size.width*newSize.height;
        width=newSize.width;
    }
    newSize.width=width;
    newSize.height=height;
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    // Tell the old image to draw in this new context, with the desired
    // new size
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    // End the context
    UIGraphicsEndImageContext();
    // Return the new image.
    return newImage;
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
