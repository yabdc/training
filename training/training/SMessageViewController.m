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
#import "SLoginViewController.h"
#import "SChatMessageItemButton.h"

@interface SMessageViewController ()<iMessageUtilityDelegte,UITextViewDelegate,MLEmojiLabelDelegate,MFMailComposeViewControllerDelegate,UIAlertViewDelegate>
{
    SCustomView *m_CustomView;                  //下滑的View
    NSMutableArray *m_aryMessageItem;           //文字訊息的陣列
    NSMutableArray *m_aryMessageView;           //文字訊息View的陣列
    NSString *m_strUserName;                    //使用者自己
    NSString *m_strChatName;                    //對話對象
    CGRect m_initialFrameOfmessageTextView;     //TextView的初始frame
    CGRect m_oldFrameOfsendView;                //功能區位置
    CGRect m_oldFrameOfmainView;                //主畫面位置
    CGSize m_kbSize;                            //鍵盤大小
    float m_fHaveNewMessage;                    //訊息則數
    NSString *m_strMessageNotification;
    NSTimer *m_timer;
    UITapGestureRecognizer *m_tapCellGestureRecognizer;
    
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
    self.title=m_strChatName;
    m_initialFrameOfmessageTextView=CGRectZero;
    m_oldFrameOfsendView=CGRectZero;
    m_oldFrameOfmainView=CGRectZero;
    m_fHaveNewMessage=0;
    
    m_aryMessageItem=[NSMutableArray new];
    m_aryMessageView=[NSMutableArray new];
    
    self.m_sendView.clipsToBounds=NO;
    
    _m_messageTextView.delegate=self;
    
    m_CustomView=[[SCustomView alloc] initWithvc:self ChatName:m_strChatName];
    [self.view addSubview:m_CustomView];
    
    
    [[iMessageUtility sharedManager] setDelegate:self];
    [[iMessageUtility sharedManager] checkChatTableIsExisted:m_strChatName
                                                     isGroup:NO];
    m_fHaveNewMessage=[[iMessageUtility sharedManager] queryRecordsCountFromChatTable:m_strChatName isGroup:NO];
    [[iMessageUtility sharedManager] getChatListByPhoneFromWS:m_strChatName];
    while (m_fHaveNewMessage!=[[iMessageUtility sharedManager] queryRecordsCountFromChatTable:m_strChatName isGroup:NO])
    {
        m_fHaveNewMessage=[[iMessageUtility sharedManager] queryRecordsCountFromChatTable:m_strChatName isGroup:NO];
        [[iMessageUtility sharedManager] getChatListByPhoneFromWS:m_strChatName];
    }
    
    [self chatMessageItemTransformView:PresetMessageCount];
    [self.m_TableView reloadData];
    NSIndexPath* indexPath = [NSIndexPath indexPathForRow:m_aryMessageView.count-1 inSection: 0];
    [self.m_TableView scrollToRowAtIndexPath:indexPath
                            atScrollPosition:UITableViewScrollPositionBottom
                                    animated:NO];
//    //下拉更新
//    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
//    [refreshControl addTarget:self
//                    action:@selector(handleRefresh:)
//                    forControlEvents:UIControlEventValueChanged];
//    [self.m_TableView addSubview:refreshControl];
    
    
    
}
//下拉更新
//-(void)handleRefresh:(UIRefreshControl *)refreshControl{
//    [self.m_TableView reloadData];
//    [refreshControl endRefreshing];
//}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
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
    [self startTimer];
    
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
    
}

-(void)viewDidDisappear:(BOOL)animated{
    [self stopTimer];
    [[NSNotificationCenter defaultCenter]removeObserver:self
                                                   name:m_strMessageNotification
                                                 object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self
                                                   name:UIKeyboardWillShowNotification                                                 object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self
                                                   name:UIKeyboardWillHideNotification
                                                 object:nil];
    [super viewDidDisappear:animated];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//接收到訊息通知
- (void)messageNotification:(NSNotification *)notification{
    NSLog(@"%@",notification);
    [self chatMessageItemTransformView:[notification.userInfo[@"MsgCount"] intValue]];
    [self.m_TableView reloadData];
    NSIndexPath* indexPath = [NSIndexPath indexPathForRow:m_aryMessageView.count-1 inSection: 0];
    [self.m_TableView scrollToRowAtIndexPath:indexPath
                            atScrollPosition:UITableViewScrollPositionBottom
                                    animated:NO];
    NSLog(@"%lu",(unsigned long)m_aryMessageView.count);
    
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
    [m_CustomView showView];
}
//登出
- (IBAction)backToLoginView:(id)sender {
    if (IsIOS8Later) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"登出" message:@"是否登出?" preferredStyle:UIAlertControllerStyleActionSheet];
        
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"確認" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            SLoginViewController *SLoginViewController = [self.storyboard instantiateViewControllerWithIdentifier:s_SLoginViewControllerName];
            [self presentViewController:SLoginViewController animated:YES completion:nil];
        }];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
        }];
        [alertController addAction:okAction];
        [alertController addAction:cancelAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }else{
        UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"登出" message:@"是否登出?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"確認", nil];
        [alertView show];
    }
    
}
- (void)startTimer {
    m_timer = [NSTimer scheduledTimerWithTimeInterval:10
                                               target:self
                                             selector:@selector(refreshDB)
                                             userInfo:nil repeats:YES];
}
- (void) stopTimer{
    [m_timer invalidate];
    m_timer = nil;
}
-(void)refreshDB{
//    while (m_fHaveNewMessage!=[[iMessageUtility sharedManager] queryRecordsCountFromChatTable:m_strChatName isGroup:NO])
//    {
//        m_fHaveNewMessage=[[iMessageUtility sharedManager] queryRecordsCountFromChatTable:m_strChatName isGroup:NO];
//
//    }
    //問題
    [[iMessageUtility sharedManager] getChatListByPhoneFromWS:m_strChatName];

}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return m_aryMessageView.count;
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
    UIView *view=m_aryMessageView[indexPath.row];
    [cell.contentView addSubview:view];
    
    return cell;
}

-(void)chatMessageItemTransformView:(int)iMsgCount{
    m_aryMessageItem=[[iMessageUtility sharedManager] queryChatsFromTableByAccount:m_strChatName
                                                                           isGroup:NO
                                                                        withLimit:iMsgCount];
    UIView *view=nil;
    UIImageView *bubbleView=nil;
    SChatMessageItemButton *SPhotoButton=nil;
    MLEmojiLabel *MLEmojiLabel=nil;
    UIView *addressView=nil;
    UILabel *timeLabel=nil;
    for (ChatMessageItem *item in m_aryMessageItem) {
        
        bubbleView=[self chooseBubbleViewImage:item.isMySpeaking];
        if ([item.ContentType isEqualToString: ImageMessage]) {
            SPhotoButton=[self imageMessage:item];
            [self bubbleView:bubbleView addSubView:SPhotoButton isMySpeaking:item.isMySpeaking];
        }else if([item.ContentType isEqualToString: TextMessage]){
            MLEmojiLabel=[self textMessage:item];
            bubbleView=[self bubbleView:bubbleView addSubView:MLEmojiLabel isMySpeaking:item.isMySpeaking];
        }else if([item.ContentType isEqualToString: AddressMessage]){
            addressView =[self adressMessage:item];
            bubbleView=[self bubbleView:bubbleView addSubView:addressView isMySpeaking:item.isMySpeaking];
        }
        timeLabel = [self timeLabel:bubbleView ChatMessageItem:item];
        float totalHeight=timeLabel.frame.size.height+bubbleView.frame.size.height;
        
        UIView *setGestureView = [self gestureView:totalHeight];
        view=[[UIView alloc] initWithFrame:setGestureView.frame];
        [view addSubview:setGestureView];
        [view addSubview:timeLabel];
        [view addSubview:bubbleView];
        [m_aryMessageView addObject:view];
    }
}
//收鍵盤的View
-(UIView *)gestureView:(float)height{
    UIView *setGestureView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, height+2*Padding)];
    
    m_tapCellGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyBoard)];
    
    [m_tapCellGestureRecognizer setCancelsTouchesInView:NO];
    [setGestureView addGestureRecognizer:m_tapCellGestureRecognizer];
    return setGestureView;
}
//時間Label
-(UILabel *)timeLabel:(UIImageView *)bubbleView ChatMessageItem:(ChatMessageItem *)item{
    
    UILabel *timeLabel = [[UILabel alloc]init];
    timeLabel.text = item.DataTime;
    timeLabel.font = [UIFont systemFontOfSize:DateFont];
    CGRect labelFrame = timeLabel.frame;
    labelFrame.size=[timeLabel sizeThatFits:CGSizeMake(MAXFLOAT, 0)];
    if ([item.isMySpeaking isEqualToString: Self]) {
        labelFrame.origin = CGPointMake(ScreenWidth-labelFrame.size.width, bubbleView.frame.size.height+ToCellTop);
    }else{
        labelFrame.origin = CGPointMake(ToCellLeft, bubbleView.frame.size.height+ToCellTop);
    }
    [timeLabel setFrame:labelFrame];
    
    return timeLabel;
}
//選氣泡的圖片
-(UIImageView *)chooseBubbleViewImage:(NSString *)isMySpeaking{
    UIImage *img=nil;
    UIImageView *bubbleView=nil;
    UIEdgeInsets insets = UIEdgeInsetsMake(TopEdgeInset, LeftEdgeInset, BottomEdgeInset, RightEdgeInset);
    if ([isMySpeaking isEqualToString: Self]) {
        img=[UIImage imageNamed:@"BubbleSelf"];
    }else{
        img=[UIImage imageNamed:@"BubbleSomeone"];
    }
    img=[img resizableImageWithCapInsets:insets];
    bubbleView=[[UIImageView alloc]initWithImage:img];
    bubbleView.userInteractionEnabled=YES;
    return bubbleView;
}
//氣泡內加上內容，並放置到正確位置
-(UIImageView *)bubbleView:(UIImageView *)bubbleView addSubView:(UIView *)SubView isMySpeaking:(NSString *)isMySpeaking{
    [bubbleView addSubview:SubView];
    if ([isMySpeaking isEqualToString: Self]) {
        [bubbleView setFrame:CGRectMake(ScreenWidth-(SubView.frame.size.width+2*LeftPaddingMessageContent) , ToCellTop, SubView.frame.size.width+2*LeftPaddingMessageContent, SubView.frame.size.height+2*TopPaddingMessageContent)];
    }else{
        [bubbleView setFrame:CGRectMake(ToCellLeft , ToCellTop, SubView.frame.size.width+2*LeftPaddingMessageContent, SubView.frame.size.height+2*TopPaddingMessageContent)];
    }
    return bubbleView;
}
#pragma mark --DrawView
//圖片訊息（基礎）
-(SChatMessageItemButton *)imageMessage:(ChatMessageItem *)item{
    SChatMessageItemButton *imageButton = [[SChatMessageItemButton alloc] initWithFrame:CGRectMake(LeftPaddingMessageContent , TopPaddingMessageContent, ButtonInit, ButtonInit)];
    imageButton.contentMode = UIViewContentModeScaleAspectFit;
    [imageButton setBackgroundImage:[UIImage imageWithData:[self hexStringToData:item.Content]] forState:UIControlStateNormal];
    [imageButton sizeToFit];
    [imageButton addTarget:self action:@selector(imageButtonPress:) forControlEvents:UIControlEventTouchUpInside];
    imageButton.g_MessageItem=item;
    return imageButton;
}
//文字訊息（基礎）
-(MLEmojiLabel *)textMessage:(ChatMessageItem *)item{
    MLEmojiLabel *textLabel=[[MLEmojiLabel alloc] init];
    textLabel.emojiDelegate=self;
    textLabel.text=item.Content;
    textLabel.isNeedAtAndPoundSign=YES;
    [textLabel setEmojiText:item.Content];
    textLabel.font=[UIFont systemFontOfSize:MessageFont];
    textLabel.numberOfLines=0;
    [textLabel sizeThatFits:CGSizeMake(MAXFLOAT, 0)];
    CGSize realSize=[textLabel sizeThatFits:CGSizeMake(MaxWidthOfLabel, MAXFLOAT)];
    [textLabel setFrame:CGRectMake(LeftPaddingMessageContent, TopPaddingMessageContent,realSize.width, realSize.height)];
    return textLabel;
}
//位置訊息（基礎）
-(UIView *)adressMessage:(ChatMessageItem *)item{
    NSArray *aryContent = [item.Content componentsSeparatedByString:@"//"];
    NSString *strAddress = aryContent[0];
    
    UILabel *textLabel=[[UILabel alloc] init];
    textLabel.text=strAddress;
    textLabel.font=[UIFont systemFontOfSize:MessageFont];
    textLabel.numberOfLines=0;
    [textLabel sizeThatFits:CGSizeMake(MAXFLOAT, 0)];
    CGSize realSize=[textLabel sizeThatFits:CGSizeMake(MaxWidthOfAddress, MAXFLOAT)];
    [textLabel setFrame:CGRectMake(realSize.height+LeftPaddingMessageContent, TopPaddingMessageContent,realSize.width, realSize.height)];
    
    UIImageView *imageView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Flag"]];
    [imageView setFrame:CGRectMake(LeftPaddingMessageContent, TopPaddingMessageContent, realSize.height, realSize.height)];
    
    SChatMessageItemButton *adressButton = [[SChatMessageItemButton alloc] initWithFrame:CGRectMake(LeftPaddingMessageContent, TopPaddingMessageContent, realSize.height+realSize.width, realSize.height)];
    [adressButton addTarget:self action:@selector(adressButtonPress:) forControlEvents:UIControlEventTouchUpInside];
    adressButton.g_MessageItem=item;
    
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0,realSize.height+realSize.width, realSize.height)];
    [view addSubview:textLabel];
    [view addSubview:imageView];
    [view addSubview:adressButton];
    return view;
}

////判斷發話者，來決定氣泡位置
//-(CGRect)setBubbleViewFrame:(UIView *)a isMySpeaking:(NSString *)isMySpeaking{
//    CGRect newframe;
//    
//    return newframe;
//}

//圖片訊息被點擊
-(void)imageButtonPress:(SChatMessageItemButton *)button{
    SPhotoViewController *SPhotoViewController =[self.storyboard instantiateViewControllerWithIdentifier:s_SPhotoViewControllerName];
    SPhotoViewController.g_bDownloadMode=YES;
    SPhotoViewController.g_image=button.currentBackgroundImage;
    
    SPhotoViewController.g_photoMessageItem=button.g_MessageItem;
    [self.navigationController pushViewController:SPhotoViewController animated:YES];
}
//位置訊息被點擊
-(void)adressButtonPress:(SChatMessageItemButton *)button{
    SMapViewController *SMapViewController =[self.storyboard instantiateViewControllerWithIdentifier:s_SMapViewControllerName];
    SMapViewController.g_bBrowseMode=YES;

    SMapViewController.g_mapMessageItem =button.g_MessageItem;
    [self.navigationController pushViewController:SMapViewController animated:YES];
    
}


#pragma mark - UITableViewDelegate
//計算cell高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    

    UIView *view=m_aryMessageView[indexPath.row];
    
    return view.frame.size.height;
    

}

#pragma mark --keyboard method
- (void)hideKeyBoard{
    [self.m_messageTextView resignFirstResponder];
}
//鍵盤將出現
-(void)keyboardWillShow:(NSNotification*)aNotification
{
    m_kbSize=[[[aNotification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    [m_CustomView setKeyBoardHeight:m_kbSize.height];
    [self moveCollectionView:m_kbSize];
    m_oldFrameOfsendView =_m_sendView.frame;
}


//鍵盤將消失
- (void)keyboardWillHide:(NSNotification*)aNotification
{
    m_kbSize=CGSizeZero;
    [m_CustomView setKeyBoardHeight:m_kbSize.height];
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
-(BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    NSIndexPath* indexPath = [NSIndexPath indexPathForRow:m_aryMessageView.count-1 inSection: 0];
    [self.m_TableView scrollToRowAtIndexPath:indexPath
                            atScrollPosition:UITableViewScrollPositionBottom
                                    animated:NO];
    return YES;
}
//textView內容改變
- (void)textViewDidChange:(UITextView *)textView
{
    CGFloat sad=m_oldFrameOfsendView.size.height+m_oldFrameOfsendView.origin.y;
    CGRect newframe=textView.frame;
    
    CGPoint offset = CGPointMake(0, textView.contentSize.height - textView.frame.size.height);
    [textView setContentOffset:offset animated:NO];
    newframe.size.height=textView.contentSize.height;
    if (newframe.size.height >= MaxHeightOfTextView)
        newframe.size.height = MaxHeightOfTextView;
    
    
    self.m_sendView.translatesAutoresizingMaskIntoConstraints=YES;
    
    self.m_sendView.frame=CGRectMake(m_oldFrameOfsendView.origin.x, sad-newframe.size.height-10, m_oldFrameOfsendView.size.width, newframe.size.height+10);
    
    textView.frame = newframe;
    if (textView.text.length==0) {
        [self.m_sendView setFrame:m_oldFrameOfsendView];
    }
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    NSString *temp = [textView.text stringByReplacingCharactersInRange:range withString:text];
    if (temp.length > StringLengthLimit) {
        textView.text = [temp substringToIndex:StringLengthLimit];
        return NO;
    }
    return YES;
}
#pragma mark -- HexNSString to NSData
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

#pragma mark UIAlertViewDelegate
-(void)alertView:(UIAlertView * )alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:
            break;
        case 1:
        {
            SLoginViewController *SLoginViewController = [self.storyboard instantiateViewControllerWithIdentifier:s_SLoginViewControllerName];
            [self presentViewController:SLoginViewController animated:YES completion:nil];
        }
            break;
        default:
            break;
    }
}
@end
