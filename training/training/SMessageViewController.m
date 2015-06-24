//
//  SMessageViewController.m
//  training
//
//  Created by 1500244 on 2015/6/10.
//  Copyright (c) 2015年 andychan. All rights reserved.
//
#import <iMessageUtility.h>
#import <ChatMessageItem.h>
#import <MessageUI/MessageUI.h>
#import "MLEmojiLabel.h"

#import "SMessageViewController.h"
#import "SDefine.h"
#import "SCustomView.h"
#import "SPhotoViewController.h"
#import "SMapViewController.h"

@interface SMessageViewController ()<iMessageUtilityDelegte,UITextViewDelegate,MLEmojiLabelDelegate,MFMailComposeViewControllerDelegate>
{
    SCustomView *vc;
    ChatMessageItem *m_MessageItem;
    NSMutableArray *m_aryMessageItem;
    CGRect m_initialFrameOfmessageTextView;     //TextView的初始frame
    NSString *m_strMessageNotification;
    NSString *m_strUserName;
    NSString *m_strChatName;
    CGRect m_oldFrameOfsendView;
    CGRect m_oldFrameOfmainView;
    CGSize m_kbSize;
    UITapGestureRecognizer *m_tapCellGestureRecognizer;
    float leftOrRight;
}
@property (weak, nonatomic) IBOutlet UITableView *m_TableView;
@property (weak, nonatomic) IBOutlet UIView *m_mainView;
@property (weak, nonatomic) IBOutlet UITextView *m_messageTextView;
@property (weak, nonatomic) IBOutlet UIView *m_sendView;


@end

@implementation SMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([_g_strUserName isEqualToString:TestUserName]) {
        m_strUserName=TestUserName;
        m_strChatName=TestChat;
    }else{
        m_strUserName=TestChat;
        m_strChatName=TestUserName;
    }
    m_strMessageNotification = [NSString stringWithFormat:@"N%@", m_strChatName];
    //註冊鍵盤監聽
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(messageNotification:)
                                                 name:m_strMessageNotification
                                               object:nil];
    
    m_aryMessageItem=[NSMutableArray new];
    self.m_sendView.clipsToBounds=NO;
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self
                    action:@selector(handleRefresh:)
                    forControlEvents:UIControlEventValueChanged];
    [self.m_TableView addSubview:refreshControl];
    
    _m_messageTextView.delegate=self;
    vc=[[SCustomView alloc] initWithvc:self];
    [self.view addSubview:vc];
}
//下拉更新
-(void)handleRefresh:(UIRefreshControl *)refreshControl{
    [self.m_TableView reloadData];
    [refreshControl endRefreshing];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[iMessageUtility sharedManager] setDelegate:self];
    
    m_aryMessageItem=[[iMessageUtility sharedManager] queryChatsFromTableByAccount:m_strChatName
                                                      isGroup:NO
                                                      withLimit:PresetMessageCount];
    [[iMessageUtility sharedManager] checkChatTableIsExisted:m_strUserName
                                     isGroup:NO];
    [[iMessageUtility sharedManager] getChatListByPhoneFromWS:m_strChatName];
    [super viewWillAppear:animated];
    
    
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    m_initialFrameOfmessageTextView=_m_messageTextView.frame;
    m_oldFrameOfmainView=_m_mainView.frame;
}


- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    NSLog(@"viewWillLayoutSubviews");
    NSIndexPath* indexPath = [NSIndexPath indexPathForRow:m_aryMessageItem.count-1 inSection: 0];
    [self.m_TableView scrollToRowAtIndexPath:indexPath
                      atScrollPosition:UITableViewScrollPositionBottom
                      animated:NO];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//接收到訊息通知
- (void)messageNotification:(NSNotification *)notification{
    NSLog(@"%@",notification);
    m_aryMessageItem=[[iMessageUtility sharedManager] queryChatsFromTableByAccount:m_strChatName
                                                      isGroup:NO
                                                      withLimit:20];
    [self.m_TableView reloadData];
    NSIndexPath* indexPath = [NSIndexPath indexPathForRow:m_aryMessageItem.count-1 inSection: 0];
    [self.m_TableView scrollToRowAtIndexPath:indexPath
                            atScrollPosition:UITableViewScrollPositionBottom
                                    animated:NO];
}
//傳送訊息
- (IBAction)sendBtnAction:(UIButton *)sender {
    if (_m_messageTextView.text.length>0) {
        [[iMessageUtility sharedManager] sendMsgWithContent:_m_messageTextView.text
                                         ContentType:[TextMessage intValue]
                                         bySequenceID:nil
                                         toPhone:m_strChatName];
        self.m_messageTextView.text=@"";
        [self.m_messageTextView resignFirstResponder];
        [self.m_messageTextView setFrame:m_initialFrameOfmessageTextView];
        [self.m_sendView setFrame:m_oldFrameOfsendView];
    }
}
//新增圖片，位置訊息的view控制
- (IBAction)otherBtnAction:(UIButton *)sender {
    [vc showView];
    NSLog(@"%@",vc);
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return m_aryMessageItem.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellSelf" forIndexPath:indexPath];
    if(cell==nil){
        cell = [tableView dequeueReusableCellWithIdentifier:@"CellSelf" forIndexPath:indexPath];
    }else{
        NSArray *subviews = [[NSArray alloc] initWithArray:cell.contentView.subviews];
        for (UIView *subview in subviews) {
            [subview removeFromSuperview];
        }
    }
    UIImage *img=nil;
    UIImageView *imgView=nil;
    m_MessageItem = m_aryMessageItem[indexPath.row];
    leftOrRight=[UIScreen mainScreen].bounds.size.width;
    if ([m_MessageItem.isMySpeaking isEqualToString: Self]) {
        img=[UIImage imageNamed:@"BubbleSelf"];
    }else{
        img=[UIImage imageNamed:@"BubbleSomeone"];
    }
    UIEdgeInsets insets = UIEdgeInsetsMake(TopEdgeInset, LeftEdgeInset, BottomEdgeInset, RightEdgeInset);
    img=[img resizableImageWithCapInsets:insets];
    imgView=[[UIImageView alloc]initWithImage:img];
    imgView.userInteractionEnabled=YES;
    
    
    
    
    if ([m_MessageItem.ContentType isEqualToString: ImageMessage ]) {
        UIButton *imageButton = [[UIButton alloc] initWithFrame:CGRectMake(LeftPaddingMessageContent , TopPaddingMessageContent, ButtonInit, ButtonInit)];
        imageButton.contentMode = UIViewContentModeScaleAspectFit;
        [imageButton setBackgroundImage:[UIImage imageWithData:[self hexStringToData:m_MessageItem.Content]] forState:UIControlStateNormal];
        [imageButton sizeToFit];
        [imageButton addTarget:self action:@selector(imageButtonPress:) forControlEvents:UIControlEventTouchUpInside];
        [imgView addSubview:imageButton];
        if ([m_MessageItem.isMySpeaking isEqualToString: Self]) {
        [imgView setFrame:CGRectMake(leftOrRight-(imageButton.frame.size.width+2*LeftPaddingMessageContent) , ToCellTop, imageButton.frame.size.width+2*LeftPaddingMessageContent, imageButton.frame.size.height+2*TopPaddingMessageContent)];
        }else{
        [imgView setFrame:CGRectMake(ToCellLeft , ToCellTop, imageButton.frame.size.width+2*LeftPaddingMessageContent, imageButton.frame.size.height+2*TopPaddingMessageContent)];
        }
        
    }else if([m_MessageItem.ContentType isEqualToString: TextMessage ]){
        
        MLEmojiLabel *textLabel=[[MLEmojiLabel alloc] init];
        textLabel.emojiDelegate=self;
        textLabel.text=m_MessageItem.Content;
        textLabel.isNeedAtAndPoundSign=YES;
        [textLabel setEmojiText:m_MessageItem.Content];
        textLabel.font=[UIFont systemFontOfSize:MessageFont];
        textLabel.numberOfLines=0;
        [textLabel sizeThatFits:CGSizeMake(MAXFLOAT, 0)];
        CGSize a=[textLabel sizeThatFits:CGSizeMake(MaxWidthOfLabel, MAXFLOAT)];
        [textLabel setFrame:CGRectMake(LeftPaddingMessageContent, TopPaddingMessageContent,a.width, a.height)];
        
        [imgView addSubview:textLabel];
        
        if ([m_MessageItem.isMySpeaking isEqualToString: Self]) {
            [imgView setFrame:CGRectMake(leftOrRight-(textLabel.frame.size.width+2*LeftPaddingMessageContent), ToCellTop, textLabel.frame.size.width+2*LeftPaddingMessageContent, textLabel.frame.size.height+2*TopPaddingMessageContent)];
        }else{
        
        [imgView setFrame:CGRectMake(0, ToCellTop, textLabel.frame.size.width+2*LeftPaddingMessageContent, textLabel.frame.size.height+2*TopPaddingMessageContent)];
        }
    }else if([m_MessageItem.ContentType isEqualToString: AddressMessage ]){
        NSArray *aryContent = [m_MessageItem.Content componentsSeparatedByString:@"//"];
        NSString *strAddress = aryContent[0];
        UILabel *textLabel=[[UILabel alloc] init];
        textLabel.text=strAddress;
        textLabel.font=[UIFont systemFontOfSize:MessageFont];
        textLabel.numberOfLines=0;
        [textLabel sizeThatFits:CGSizeMake(MAXFLOAT, 0)];
        CGSize a=[textLabel sizeThatFits:CGSizeMake(MaxWidthOfAddress, MAXFLOAT)];
        [textLabel setFrame:CGRectMake(LeftPaddingMessageContent, TopPaddingMessageContent,a.width, a.height)];
        
        UIButton *adressButton = [[UIButton alloc] initWithFrame:CGRectMake(LeftPaddingMessageContent, TopPaddingMessageContent, a.height, a.height)];
        adressButton.contentMode = UIViewContentModeScaleAspectFit;
        [adressButton setBackgroundImage:[UIImage imageNamed:@"Flag"] forState:UIControlStateNormal];
        [adressButton addTarget:self action:@selector(adressButtonPress:) forControlEvents:UIControlEventTouchUpInside];
        [imgView addSubview:adressButton];
        [textLabel setFrame:CGRectMake(a.height+LeftPaddingMessageContent, TopPaddingMessageContent,a.width, a.height)];
        [imgView addSubview:textLabel];
        
        if ([m_MessageItem.isMySpeaking isEqualToString: Self]) {
            [imgView setFrame:CGRectMake(leftOrRight-(a.height+textLabel.frame.size.width+2*LeftPaddingMessageContent), ToCellTop, a.height+textLabel.frame.size.width+2*LeftPaddingMessageContent, textLabel.frame.size.height+2*TopPaddingMessageContent)];
        }else{
        [imgView setFrame:CGRectMake(ToCellLeft, ToCellTop, a.height+textLabel.frame.size.width+2*LeftPaddingMessageContent, textLabel.frame.size.height+2*TopPaddingMessageContent)];
        }
        
    }
    UILabel *label = [[UILabel alloc]init];
    label.text = m_MessageItem.DataTime;
    label.font = [UIFont systemFontOfSize:DateFont];
    
    CGRect labelFrame = label.frame;
    labelFrame.size=[label sizeThatFits:CGSizeMake(MAXFLOAT, 0)];
    if ([m_MessageItem.isMySpeaking isEqualToString: Self]) {
        labelFrame.origin = CGPointMake(leftOrRight-labelFrame.size.width, imgView.frame.size.height+ToCellTop);
    }else{
        labelFrame.origin = CGPointMake(ToCellLeft, imgView.frame.size.height+ToCellTop);
    }
    
    [label setFrame:labelFrame];
    [cell.contentView addSubview:label];
    [cell.contentView addSubview:imgView];
    
    return cell;
}
//圖片訊息被點擊
-(void)imageButtonPress:(UIButton *)button{
    SPhotoViewController *SPhotoViewController =[self.storyboard instantiateViewControllerWithIdentifier:s_SPhotoViewControllerName];
    SPhotoViewController.g_bDownloadMode=YES;
    SPhotoViewController.g_image=button.currentBackgroundImage;
    
    //然后使用indexPathForCell方法，就得到indexPath了~
    UITableViewCell *cell = (UITableViewCell *)button.superview.superview.superview;
    NSIndexPath *indexPath = [self.m_TableView indexPathForCell:cell];
    
    SPhotoViewController.g_photoMessageItem=m_aryMessageItem[indexPath.row];
    [self presentViewController:SPhotoViewController animated:YES completion:nil];
}
//位置訊息被點擊
-(void)adressButtonPress:(UIButton *)button{
    SMapViewController *SMapViewController =[self.storyboard instantiateViewControllerWithIdentifier:s_SMapViewControllerName];
    SMapViewController.g_bBrowseMode=YES;
    
    UITableViewCell *cell = (UITableViewCell *)button.superview.superview.superview;
    NSIndexPath *indexPath = [self.m_TableView indexPathForCell:cell];
    
    SMapViewController.g_mapMessageItem =m_aryMessageItem[indexPath.row];
    [self.navigationController pushViewController:SMapViewController animated:YES];
    
}


#pragma mark - UITableViewDelegate
//計算cell高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UIImage *img=nil;
    UIImageView *imgView=nil;
    m_MessageItem = m_aryMessageItem[indexPath.row];
    leftOrRight=[UIScreen mainScreen].bounds.size.width;
    if ([m_MessageItem.isMySpeaking isEqualToString: Self]) {
        img=[UIImage imageNamed:@"BubbleSelf"];
    }else{
        img=[UIImage imageNamed:@"BubbleSomeone"];
    }
    UIEdgeInsets insets = UIEdgeInsetsMake(TopEdgeInset, LeftEdgeInset, BottomEdgeInset, RightEdgeInset);
    img=[img resizableImageWithCapInsets:insets];
    imgView=[[UIImageView alloc]initWithImage:img];
    imgView.userInteractionEnabled=YES;
    
    
    
    
    if ([m_MessageItem.ContentType isEqualToString: ImageMessage ]) {
        UIButton *imageButton = [[UIButton alloc] initWithFrame:CGRectMake(LeftPaddingMessageContent , TopPaddingMessageContent, ButtonInit, ButtonInit)];
        imageButton.contentMode = UIViewContentModeScaleAspectFit;
        [imageButton setBackgroundImage:[UIImage imageWithData:[self hexStringToData:m_MessageItem.Content]] forState:UIControlStateNormal];
        [imageButton sizeToFit];
        [imageButton addTarget:self action:@selector(imageButtonPress:) forControlEvents:UIControlEventTouchUpInside];
        [imgView addSubview:imageButton];
        if ([m_MessageItem.isMySpeaking isEqualToString: Self]) {
            [imgView setFrame:CGRectMake(leftOrRight-(imageButton.frame.size.width+2*LeftPaddingMessageContent) , ToCellTop, imageButton.frame.size.width+2*LeftPaddingMessageContent, imageButton.frame.size.height+2*TopPaddingMessageContent)];
        }else{
            [imgView setFrame:CGRectMake(ToCellLeft , ToCellTop, imageButton.frame.size.width+2*LeftPaddingMessageContent, imageButton.frame.size.height+2*TopPaddingMessageContent)];
        }
        
    }else if([m_MessageItem.ContentType isEqualToString: TextMessage ]){
        
        MLEmojiLabel *textLabel=[[MLEmojiLabel alloc] init];
        textLabel.emojiDelegate=self;
        textLabel.text=m_MessageItem.Content;
        textLabel.isNeedAtAndPoundSign=YES;
        [textLabel setEmojiText:m_MessageItem.Content];
        textLabel.font=[UIFont systemFontOfSize:MessageFont];
        textLabel.numberOfLines=0;
        [textLabel sizeThatFits:CGSizeMake(MAXFLOAT, 0)];
        CGSize a=[textLabel sizeThatFits:CGSizeMake(MaxWidthOfLabel, MAXFLOAT)];
        [textLabel setFrame:CGRectMake(LeftPaddingMessageContent, TopPaddingMessageContent,a.width, a.height)];
        
        [imgView addSubview:textLabel];
        
        if ([m_MessageItem.isMySpeaking isEqualToString: Self]) {
            [imgView setFrame:CGRectMake(leftOrRight-(textLabel.frame.size.width+2*LeftPaddingMessageContent), ToCellTop, textLabel.frame.size.width+2*LeftPaddingMessageContent, textLabel.frame.size.height+2*TopPaddingMessageContent)];
        }else{
            
            [imgView setFrame:CGRectMake(0, ToCellTop, textLabel.frame.size.width+2*LeftPaddingMessageContent, textLabel.frame.size.height+2*TopPaddingMessageContent)];
        }
    }else if([m_MessageItem.ContentType isEqualToString: AddressMessage ]){
        NSArray *aryContent = [m_MessageItem.Content componentsSeparatedByString:@"//"];
        NSString *strAddress = aryContent[0];
        UILabel *textLabel=[[UILabel alloc] init];
        textLabel.text=strAddress;
        textLabel.font=[UIFont systemFontOfSize:MessageFont];
        textLabel.numberOfLines=0;
        [textLabel sizeThatFits:CGSizeMake(MAXFLOAT, 0)];
        CGSize a=[textLabel sizeThatFits:CGSizeMake(MaxWidthOfAddress, MAXFLOAT)];
        [textLabel setFrame:CGRectMake(LeftPaddingMessageContent, TopPaddingMessageContent,a.width, a.height)];
        
        UIButton *adressButton = [[UIButton alloc] initWithFrame:CGRectMake(LeftPaddingMessageContent, TopPaddingMessageContent, a.height, a.height)];
        adressButton.contentMode = UIViewContentModeScaleAspectFit;
        [adressButton setBackgroundImage:[UIImage imageNamed:@"Flag"] forState:UIControlStateNormal];
        [adressButton addTarget:self action:@selector(adressButtonPress:) forControlEvents:UIControlEventTouchUpInside];
        [imgView addSubview:adressButton];
        [textLabel setFrame:CGRectMake(a.height+LeftPaddingMessageContent, TopPaddingMessageContent,a.width, a.height)];
        [imgView addSubview:textLabel];
        
        if ([m_MessageItem.isMySpeaking isEqualToString: Self]) {
            [imgView setFrame:CGRectMake(leftOrRight-(a.height+textLabel.frame.size.width+2*LeftPaddingMessageContent), ToCellTop, a.height+textLabel.frame.size.width+2*LeftPaddingMessageContent, textLabel.frame.size.height+2*TopPaddingMessageContent)];
        }else{
            [imgView setFrame:CGRectMake(ToCellLeft, ToCellTop, a.height+textLabel.frame.size.width+2*LeftPaddingMessageContent, textLabel.frame.size.height+2*TopPaddingMessageContent)];
        }
        
    }
    UILabel *label = [[UILabel alloc]init];
    label.text = m_MessageItem.DataTime;
    label.font = [UIFont systemFontOfSize:DateFont];
    
    CGRect labelFrame = label.frame;
    labelFrame.size=[label sizeThatFits:CGSizeMake(MAXFLOAT, 0)];
    if ([m_MessageItem.isMySpeaking isEqualToString: Self]) {
        labelFrame.origin = CGPointMake(leftOrRight-labelFrame.size.width, imgView.frame.size.height+ToCellTop);
    }else{
        labelFrame.origin = CGPointMake(ToCellLeft, imgView.frame.size.height+ToCellTop);
    }
    
    [label setFrame:labelFrame];
    
    
    return imgView.frame.size.height+label.frame.size.height+20;
    
    //        return [self heightForBasicCellAtIndexPath:indexPath];
    //    return 200;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return PresetCellHeight;
}

#pragma mark --keyboard method
//鍵盤將出現
-(void)keyboardWillShow:(NSNotification*)aNotification
{
    m_kbSize=[[[aNotification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    [vc setKeyBoardHeight:m_kbSize.height];
    [self moveCollectionView:m_kbSize];
    m_oldFrameOfsendView =_m_sendView.frame;
}


//鍵盤將消失
- (void)keyboardWillHide:(NSNotification*)aNotification
{
    m_kbSize=CGSizeZero;
    [vc setKeyBoardHeight:m_kbSize.height];
    [self moveCollectionView:m_kbSize];
}
//鍵盤是否遮住輸入格
-(void)moveCollectionView:(CGSize)keyboardSize
{
    CGRect newframe=_m_mainView.frame;
    CGFloat scrheight=[[UIScreen mainScreen] bounds].size.height;
    newframe.origin.y=scrheight-keyboardSize.height-newframe.size.height;
    [UIView animateWithDuration:KeyBoardMoveTime animations:^{
        [self.m_mainView setFrame:newframe];
    } completion:^(BOOL finished) {
        
    }];
    
}
#pragma mark - Text view Delegate
//textView內容改變
- (void)textViewDidChange:(UITextView *)textView
{
    CGFloat sad=m_oldFrameOfsendView.size.height+m_oldFrameOfsendView.origin.y;
    CGRect newframe=textView.frame;
    newframe.size.height=textView.contentSize.height;
    CGPoint offset = CGPointMake(0, textView.contentSize.height - textView.frame.size.height);
    [textView setContentOffset:offset animated:NO];
    if (newframe.size.height >= MaxHeightOfTextView)
        newframe.size.height = MaxHeightOfTextView;
    
    
    self.m_sendView.translatesAutoresizingMaskIntoConstraints=YES;
    
    self.m_sendView.frame=CGRectMake(m_oldFrameOfsendView.origin.x, sad-newframe.size.height-10, m_oldFrameOfsendView.size.width, newframe.size.height+10);
    
    textView.frame = newframe;
    if (textView.text.length==0) {
        [self.m_sendView setFrame:m_oldFrameOfsendView];
    }
}
//hex轉image
- (NSData *) hexStringToData:(NSString *) hexString
{
    unsigned char whole_byte;
    NSMutableData *returnData= [[NSMutableData alloc] init];
    char byte_chars[3] = {'\0','\0','\0'};
    int i;
    for (i=0; i < hexString.length/2; i++) {
        byte_chars[0] = [hexString characterAtIndex:i*2];
        byte_chars[1] = [hexString characterAtIndex:i*2+1];
        whole_byte = strtol(byte_chars, NULL, 16);
        [returnData appendBytes:&whole_byte length:1];
    }
    return (NSData *)returnData;
}
//文字超連結的delegate
#pragma mark -- MLEmojiLabelDelegate

- (void)mlEmojiLabel:(MLEmojiLabel*)emojiLabel didSelectLink:(NSString*)link withType:(MLEmojiLabelLinkType)type
{
    switch(type){
        case MLEmojiLabelLinkTypeURL:{
            NSRange a=[link rangeOfString:@"http://"];
            if (a.location>a.length) {
                link=[NSString stringWithFormat:@"http://%@",link];
            }
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString: link]];
            
            break;
        }
        case MLEmojiLabelLinkTypePhoneNumber:{
            NSURL *phoneUrl = [NSURL URLWithString:[NSString  stringWithFormat:@"tel://%@",link]];
            if ([[UIApplication sharedApplication] canOpenURL:phoneUrl]) {
                [[UIApplication sharedApplication] openURL:phoneUrl];
            } else{
                UIAlertView *calert = [[UIAlertView alloc]initWithTitle:@"錯誤" message:@"不支援播打電話" delegate:nil cancelButtonTitle:@"確認" otherButtonTitles:nil, nil];
                [calert show];
                NSLog(@"%@",link);
            }
            break;
        }
        case MLEmojiLabelLinkTypeEmail:{
            NSArray *toRecipents = [NSArray arrayWithObject:link];
            MFMailComposeViewController *mc = [[MFMailComposeViewController alloc]init];
            mc.mailComposeDelegate = self;
            [mc setToRecipients:toRecipents];
            
            // Present mail view controller on screen
            [self presentViewController:mc animated:YES completion:NULL];
            
            break;
        }
        case MLEmojiLabelLinkTypeAt:
            
            break;
        case MLEmojiLabelLinkTypePoundSign:
            
            break;
        default:
            
            break;
    }
    
}
//原生mail delegate
#pragma mark -- MFMailComposeViewControllerDelegate

- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];
}
@end
