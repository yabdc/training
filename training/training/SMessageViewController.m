//
//  SMessageViewController.m
//  training
//
//  Created by 1500244 on 2015/6/10.
//  Copyright (c) 2015年 andychan. All rights reserved.
//
#import <iMessageUtility.h>
#import <ChatMessageItem.h>


#import "SMessageViewController.h"
#import "SDefine.h"
#import "SCustomView.h"
#import "SPhotoViewController.h"

@interface SMessageViewController ()<iMessageUtilityDelegte,UITextViewDelegate>
{
    CGSize m_kbSize;
    CGRect m_oldFrameOfmainView;
    NSMutableArray *m_aryMessageItem;
    ChatMessageItem *m_MessageItem;
    CGRect m_oldframe;                          //TextView的舊frame
    CGRect m_initialFrameOfmessageTextView;     //TextView的初始frame
    CGRect m_oldFrameOfsendView;
    CGRect m_editFrameOfsendView;
    SCustomView *vc;
    UITapGestureRecognizer *m_tapCellGestureRecognizer;
}
@property (weak, nonatomic) IBOutlet UITableView *m_TableView;
@property (weak, nonatomic) IBOutlet UIView *m_mainView;
@property (weak, nonatomic) IBOutlet UITextView *m_messageTextView;
@property (weak, nonatomic) IBOutlet UIView *m_sendView;


@end

@implementation SMessageViewController
{
    NSString *m_strMessageNotification;
    NSString *m_strUserName;
    NSString *m_strChatName;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    m_strUserName=TestUserName;
    m_strChatName=TestChat;
    
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
    [refreshControl addTarget:self action:@selector(handleRefresh:) forControlEvents:UIControlEventValueChanged];
    [self.m_TableView addSubview:refreshControl];
    
    _m_messageTextView.delegate=self;
    vc=[[SCustomView alloc] initWithvc:self name:@"s"];
    [self.view addSubview:vc];
}

-(void)handleRefresh:(UIRefreshControl *)refreshControl{
    [self.m_TableView reloadData];
    [refreshControl endRefreshing];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[iMessageUtility sharedManager] setDelegate:self];
    
    m_aryMessageItem=[[iMessageUtility sharedManager] queryChatsFromTableByAccount:m_strChatName isGroup:NO withLimit:20];
    [[iMessageUtility sharedManager] checkChatTableIsExisted:m_strUserName isGroup:NO];
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
    [self.m_TableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)messageNotification:(NSNotification *)notification{
    NSLog(@"%@",notification);
    m_aryMessageItem=[[iMessageUtility sharedManager] queryChatsFromTableByAccount:@"0000001" isGroup:NO withLimit:20];
    [self.m_TableView reloadData];
}
- (IBAction)sendBtnAction:(UIButton *)sender {
    if (_m_messageTextView.text.length>0) {
        [[iMessageUtility sharedManager] sendMsgWithContent:_m_messageTextView.text ContentType:0 bySequenceID:nil toPhone:@"0000001"];
        self.m_messageTextView.text=@"";
        [self.m_messageTextView resignFirstResponder];
        [self.m_messageTextView setFrame:m_initialFrameOfmessageTextView];
        [self.m_sendView setFrame:m_editFrameOfsendView];
    }
}
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
    
//    UIView *view =[[UIView alloc] initWithFrame:cell.frame];
//    [view setBackgroundColor:[UIColor greenColor]];
//    view.layer.cornerRadius=10;
    
    UIImage *img=[UIImage imageNamed:@"BubbleSelf"];
    img=[img stretchableImageWithLeftCapWidth:15 topCapHeight:12];
    UIImageView *imgView=[[UIImageView alloc]initWithImage:img];
    imgView.userInteractionEnabled=YES;
    m_MessageItem = m_aryMessageItem[indexPath.row];
//    m_tapCellGestureRecognizer=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapCell:)];
//    m_tapCellGestureRecognizer.numberOfTapsRequired= 1;
    
    
    if ([m_MessageItem.ContentType isEqualToString: @"1" ]) {
//        UIImageView *image=[[UIImageView alloc] initWithImage:[UIImage imageWithData:[self hexStringToData:m_MessageItem.Content]]];
//        CGRect imageframe=image.frame;
//        if (imageframe.size.height>200) {
//            imageframe.size.height=200;
//        }
//        if (imageframe.size.width>200) {
//            imageframe.size.width=200;
//        }
//        imageframe.origin.y=10;
//        imageframe.origin.x=10;
//        [image setFrame:imageframe];
//        [imgView addSubview:image];
//        
//        [imgView setFrame:CGRectMake(15, 12, imageframe.size.width+30, imageframe.size.height+24)];
//        UIButton *imageButton=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, imgView.frame.size.width, imgView.frame.size.height)];
//        
//        
//        [imageButton addTarget:self action:@selector(imageButtonPress:) forControlEvents:UIControlEventTouchUpInside];
        
        
        UIButton *imageButton = [[UIButton alloc] initWithFrame:CGRectMake(10 , 10, 100.0f, 100.0f)];
        imageButton.contentMode = UIViewContentModeScaleAspectFit;
        [imageButton setBackgroundImage:[UIImage imageWithData:[self hexStringToData:m_MessageItem.Content]] forState:UIControlStateNormal];
        [imageButton sizeToFit];
        [imageButton addTarget:self action:@selector(imageButtonPress:) forControlEvents:UIControlEventTouchUpInside];
        [imgView addSubview:imageButton];
        
        [imgView setFrame:CGRectMake(15, 12, imageButton.frame.size.width+30, imageButton.frame.size.height+24)];

    }else if([m_MessageItem.ContentType isEqualToString: @"0" ]){
        
        UILabel *textLabel=[[UILabel alloc] init];
        textLabel.text=m_MessageItem.Content;
        textLabel.font=[UIFont systemFontOfSize:14.0f];
        textLabel.numberOfLines=0;
        [textLabel sizeThatFits:CGSizeMake(MAXFLOAT, 0)];
        CGSize a=[textLabel sizeThatFits:CGSizeMake(240, MAXFLOAT)];
        [textLabel setFrame:CGRectMake(10, 10,a.width, a.height)];
        
        [imgView addSubview:textLabel];
        [imgView setFrame:CGRectMake(15, 12, textLabel.frame.size.width+30, textLabel.frame.size.height+24)];
    }else{
        NSArray *aryContent = [m_MessageItem.Content componentsSeparatedByString:@"//"];
        NSString *strAddress = aryContent[0];
        UILabel *textLabel=[[UILabel alloc] init];
        textLabel.text=strAddress;
        textLabel.font=[UIFont systemFontOfSize:14.0f];
        textLabel.numberOfLines=0;
        [textLabel sizeThatFits:CGSizeMake(MAXFLOAT, 0)];
        CGSize a=[textLabel sizeThatFits:CGSizeMake(240, MAXFLOAT)];
        [textLabel setFrame:CGRectMake(10, 10,a.width, a.height)];
        [imgView addSubview:textLabel];
        [imgView setFrame:CGRectMake(15, 12, textLabel.frame.size.width+30, textLabel.frame.size.height+24)];
//        [imgView addGestureRecognizer:m_tapCellGestureRecognizer];
        
    }
    
    
    
    [cell.contentView addSubview:imgView];
    
    
    
    
    
    return cell;
}

-(void)imageButtonPress:(UIButton *)sender{
    SPhotoViewController *SPhotoViewController =[self.storyboard instantiateViewControllerWithIdentifier:s_SPhotoViewControllerName];
    SPhotoViewController.g_bDownloadMode=YES;
    SPhotoViewController.g_image=sender.currentBackgroundImage;
    [self presentViewController:SPhotoViewController animated:YES completion:nil];
}

-(void)tapCell:(UITapGestureRecognizer *)recognizer{
    NSLog(@"%@",recognizer);
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//        return [self heightForBasicCellAtIndexPath:indexPath];
    return 200;
}


- (CGFloat)heightForBasicCellAtIndexPath:(NSIndexPath *)indexPath {
    static UITableViewCell *sizingCell = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sizingCell = [self.m_TableView dequeueReusableCellWithIdentifier:@"CellSelf"];
    });
    
    [self configureBasicCell:sizingCell atIndexPath:indexPath];
    return [self calculateHeightForConfiguredSizingCell:sizingCell];
}

- (CGFloat)calculateHeightForConfiguredSizingCell:(UITableViewCell *)sizingCell {
    
    sizingCell.bounds = CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.m_TableView.frame), CGRectGetHeight(sizingCell.bounds));
    
    [sizingCell setNeedsLayout];
    [sizingCell layoutIfNeeded];
    
    CGSize size = [sizingCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return size.height + 1.0f; // Add 1.0f for the cell separator height
}

- (void)configureBasicCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    m_MessageItem = m_aryMessageItem[indexPath.row];
    
    [self setTitleForCell:cell item:m_MessageItem];
}

- (void)setTitleForCell:(UITableViewCell *)cell item:(ChatMessageItem *)item {
    NSString *title = item.Content ?: NSLocalizedString(@"[No Title]", nil);
    if (item.Content.length > 200) {
        title = [NSString stringWithFormat:@"%@...", [title substringToIndex:200]];
    }
    [cell.textLabel setText:title];
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

#pragma mark --keyboard method
//鍵盤將出現
-(void)keyboardWillShow:(NSNotification*)aNotification
{
    m_kbSize=[[[aNotification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    [vc setKeyBoardHeight:m_kbSize.height];
    [self moveCollectionView:m_kbSize];
    m_editFrameOfsendView =_m_sendView.frame;
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
- (void)textViewDidBeginEditing:(UITextView *)textView{
    
}

- (void)textViewDidChange:(UITextView *)textView
{
    CGFloat sad=m_editFrameOfsendView.size.height+m_editFrameOfsendView.origin.y;
    CGRect newframe=textView.frame;
    newframe.size.height=textView.contentSize.height;
    CGPoint offset = CGPointMake(0, textView.contentSize.height - textView.frame.size.height);
    [textView setContentOffset:offset animated:NO];
    if (newframe.size.height >= MaxHeightOfTextView)
        newframe.size.height = MaxHeightOfTextView;
    
    
    self.m_sendView.translatesAutoresizingMaskIntoConstraints=YES;
    
    self.m_sendView.frame=CGRectMake(m_editFrameOfsendView.origin.x, sad-newframe.size.height-10, m_editFrameOfsendView.size.width, newframe.size.height+10);
        
    textView.frame = newframe;
    if (textView.text.length==0) {
        [self.m_sendView setFrame:m_editFrameOfsendView];
    }
}

- (BOOL)textView: (UITextView *)textview shouldChangeTextInRange: (NSRange)range replacementText: (NSString *)text {
    
    return YES;
}

//#pragma mark - HeightForString
//+ (CGFloat)heightForString:(NSString *)strContent fontSize:(CGFloat)fontSize andWidth:(CGFloat)width
//{
//    UITextView *detailTextView = [[UITextView alloc]initWithFrame:CGRectMake(0, 0, width, 0)];
//    detailTextView.font = [UIFont systemFontOfSize:fontSize];
//    detailTextView.text = strContent;
//    CGSize deSize = [detailTextView sizeThatFits:CGSizeMake(width,CGFLOAT_MAX)];
//    return deSize.height;
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

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
@end
