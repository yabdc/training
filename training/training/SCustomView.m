//
//  SCustomView.m
//  training
//
//  Created by 1500244 on 2015/6/15.
//  Copyright (c) 2015年 andychan. All rights reserved.
//

#import "SCustomView.h"
#import <MobileCoreServices/MobileCoreServices.h>

static NSString *s_SMapViewControllerName=@"SMapView";
static NSString *s_SPhotoViewControllerName=@"SPhotoView";

@interface SCustomView()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    UIViewController *viewcontroller;
    UIImage *image;
    CGFloat keyboardHeight;
}
@property (strong, nonatomic) IBOutlet UIView *m_View;

@property (nonatomic, strong) UIToolbar *toolbar;
@end
@implementation SCustomView

- (instancetype)initWithvc:(UIViewController *)vc name:(NSString *)name{
    viewcontroller=vc;
    float vcw=vc.view.bounds.size.width;
    float vch=vc.view.bounds.size.height;
    self = [super initWithFrame:CGRectMake(0, -vch, vcw, vch)];
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
    
    [self addSubview:self.m_View];
    

}


-(void)showView{
    float scw=[UIScreen mainScreen].bounds.size.width;
    float adbvh=self.frame.size.height;
    float navh=viewcontroller.navigationController.navigationBar.frame.size.height;
    
    [UIView transitionWithView:self duration:0.4 options:UIViewAnimationOptionTransitionNone animations: ^{
        CGRect newset;
        newset =CGRectMake(0, navh+20+keyboardHeight, scw, adbvh);
        
        self.frame=newset;
    }completion:^(BOOL finished){
        
    }];

}

-(void)hideView{
    float scw=[UIScreen mainScreen].bounds.size.width;
    float adbvh=self.frame.size.height;
    [UIView transitionWithView:self duration:0.4 options:UIViewAnimationOptionTransitionNone animations: ^{
        CGRect newset;
        newset =CGRectMake(0, -adbvh, scw, adbvh);
        //
        self.frame=newset;
    }completion:^(BOOL finished){
        
    }];
}


- (IBAction)cameraPress:(id)sender {
    UIImagePickerController *pickerImageView =[[UIImagePickerController alloc] init];
    pickerImageView.delegate=self;
    //如果要使用相機要先測試iDevice是否有相機
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        pickerImageView.sourceType=UIImagePickerControllerSourceTypeCamera;
    }else if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]){
        pickerImageView.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
        pickerImageView.mediaTypes =@[(NSString *)kUTTypeImage,(NSString *)kUTTypeMovie];
        [viewcontroller presentViewController:pickerImageView animated:YES completion:nil];
    }
}

- (IBAction)markerPress:(id)sender {
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    NSLog(@"touchesBegan:withEvent:");
    [self hideView];
    [super touchesBegan:touches withEvent:event];
}

-(void)setKeyBoardHeight:(CGFloat)Height{
    keyboardHeight=Height;
}

#pragma mark --addimage
- (IBAction)photoPress:(id)sender {
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
}

@end
