//
//  SCustomView.m
//  training
//
//  Created by 1500244 on 2015/6/15.
//  Copyright (c) 2015年 andychan. All rights reserved.
//

#import "SCustomView.h"
#import "SMapViewController.h"
#import "SPhotoViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "SDefine.h"



@interface SCustomView()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIAlertViewDelegate>
{
    UIViewController *viewcontroller;
    UIImage *image;
    CGFloat keyboardHeight;
    NSString *strChat;
}
@property (strong, nonatomic) IBOutlet UIView *m_View;

@property (nonatomic, strong) UIToolbar *toolbar;
@end
@implementation SCustomView

- (instancetype)initWithvc:(UIViewController *)vc ChatName:(NSString *)strChatName{
    viewcontroller=vc;
    strChat=strChatName;
    self = [super initWithFrame:CGRectMake(0, -ScreenHeight, ScreenWidth, ScreenHeight)];
    if (self) {
        keyboardHeight=0;
        image=nil;
        [self setup];
    }
    
    return self;
}

-(void)setup{
    
    NSString *nibName = NSStringFromClass([self class]);
    UINib *nib = [UINib nibWithNibName:nibName bundle:nil];
    [nib instantiateWithOwner:self options:nil];
    CGRect newframe=self.m_View.frame;
    newframe.size.width=ScreenWidth;
    newframe.size.height=newframe.size.height*newframe.size.width/ScreenWidth;
    
    [self.m_View setFrame:newframe];
    
    [self addSubview:self.m_View];
    

}


-(void)showView{

    float adbvh=self.frame.size.height;
   
    
    [UIView transitionWithView:self duration:AnimationTime options:UIViewAnimationOptionTransitionNone animations: ^{
        CGRect newset;
        newset =CGRectMake(0, keyboardHeight, ScreenWidth, adbvh);
        
        self.frame=newset;
    }completion:^(BOOL finished){
        
    }];

}

-(void)hideView{

    float adbvh=self.frame.size.height;
    [UIView transitionWithView:self duration:AnimationTime options:UIViewAnimationOptionTransitionNone animations: ^{
        CGRect newset;
        newset =CGRectMake(0, -adbvh, ScreenWidth, adbvh);
        //
        self.frame=newset;
    }completion:^(BOOL finished){
        
    }];
}


- (IBAction)cameraPress:(id)sender {
    [self hideView];
    UIImagePickerController *pickerImageView =[[UIImagePickerController alloc] init];
    pickerImageView.delegate=self;
    //如果要使用相機要先測試iDevice是否有相機
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        pickerImageView.sourceType=UIImagePickerControllerSourceTypeCamera;
        [viewcontroller presentViewController:pickerImageView animated:YES completion:nil];
    }else if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]){
        UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"Your device don't have camera!" message:@"Please Choose one..." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Go Album", nil];
        [alertView show];
    }
    
}

- (IBAction)markerPress:(id)sender {
    [self hideView];
    SMapViewController *SMapViewController =[viewcontroller.storyboard instantiateViewControllerWithIdentifier:s_SMapViewControllerName];
    SMapViewController.g_bBrowseMode=NO;
    SMapViewController.g_strChatName=strChat;
    [viewcontroller.navigationController pushViewController:SMapViewController animated:YES];
}

#pragma mark --addimage
- (IBAction)photoPress:(id)sender {
    [self hideView];
    UIImagePickerController *pickerImageView =[[UIImagePickerController alloc] init];
    pickerImageView.delegate=self;
    pickerImageView.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
    pickerImageView.mediaTypes =@[(NSString *)kUTTypeImage,(NSString *)kUTTypeMovie];
    [viewcontroller presentViewController:pickerImageView animated:YES completion:nil];
}


#pragma mark    ControllerDelegate

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    picker.delegate = nil;
    image=info[UIImagePickerControllerOriginalImage];
    [viewcontroller dismissViewControllerAnimated:YES completion:nil];
    SPhotoViewController *SPhotoViewController =[viewcontroller.storyboard instantiateViewControllerWithIdentifier:s_SPhotoViewControllerName];
    SPhotoViewController.g_bDownloadMode=NO;
    SPhotoViewController.g_strChatName=strChat;
    SPhotoViewController.g_image=info[UIImagePickerControllerOriginalImage];    [viewcontroller presentViewController:SPhotoViewController animated:YES completion:nil];
}



-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    NSLog(@"touchesBegan:withEvent:");
    [self hideView];
    [super touchesBegan:touches withEvent:event];
}

-(void)setKeyBoardHeight:(CGFloat)Height{
    keyboardHeight=Height;
}

#pragma mark UIAlertViewDelegate
-(void)alertView:(UIAlertView * )alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:
            break;
        case 1:
            [self showAlbum];
            break;
        default:
            break;
    }
}

-(void)showAlbum{
    UIImagePickerController *pickerImageView =[[UIImagePickerController alloc] init];
    pickerImageView.delegate=self;
    
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]){
        pickerImageView.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
        pickerImageView.mediaTypes =@[(NSString *)kUTTypeImage,(NSString *)kUTTypeMovie];
        
        [viewcontroller presentViewController:pickerImageView animated:YES completion:nil];
    }
}
@end
