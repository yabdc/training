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


@interface SMessageViewController ()<iMessageUtilityDelegte,UITextViewDelegate>
{
    CGSize m_kbSize;
    CGRect m_oldFrameOfmainView;            //TextView的舊frame
    NSMutableArray *m_aryMessageItem;
    ChatMessageItem *m_MessageItem;
    CGRect m_oldframe;
    CGRect m_oldframeOfmessageTextView;     //TextView的初始frame
}
@property (weak, nonatomic) IBOutlet UITableView *m_TableView;
@property (weak, nonatomic) IBOutlet UIView *m_mainView;
@property (weak, nonatomic) IBOutlet UITextView *m_messageTextView;


@end

@implementation SMessageViewController
{
    NSString *m_strMessageNotification;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    m_strMessageNotification = [NSString stringWithFormat:@"N%@", @"0000001"];
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
    
    _m_messageTextView.delegate=self;
}

-(void)viewWillAppear:(BOOL)animated{
    [[iMessageUtility sharedManager] setDelegate:self];
    
    m_aryMessageItem=[[iMessageUtility sharedManager] queryChatsFromTableByAccount:@"0000001" isGroup:NO withLimit:100];
    [[iMessageUtility sharedManager] checkChatTableIsExisted:@"0000002" isGroup:NO];
    [[iMessageUtility sharedManager] getChatListByPhoneFromWS:@"0000001"];

}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    m_oldframeOfmessageTextView=_m_messageTextView.frame;
    m_oldFrameOfmainView=_m_mainView.frame;
    NSLog(@"viewWillLayoutSubviews");
    NSIndexPath* indexPath = [NSIndexPath indexPathForRow:m_aryMessageItem.count-1 inSection: 0];
    [self.m_TableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
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
    [[iMessageUtility sharedManager] sendMsgWithContent:_m_messageTextView.text ContentType:0 bySequenceID:nil toPhone:@"0000001"];
    self.m_messageTextView.text=@"";
    [self.m_messageTextView resignFirstResponder];
    [self.m_messageTextView setFrame:m_oldframeOfmessageTextView];
}
- (IBAction)otherBtnAction:(UIButton *)sender {
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    // Return the number of rows in the section.
    return m_aryMessageItem.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    m_MessageItem = m_aryMessageItem[indexPath.row];
    cell.textLabel.text= m_MessageItem.Content;
    

    return cell;
}


#pragma mark --keyboard method
//鍵盤將出現
-(void)keyboardWillShow:(NSNotification*)aNotification
{
    m_kbSize=[[[aNotification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    [self moveCollectionView:m_kbSize];
    m_oldframe=_m_messageTextView.frame;
}


//鍵盤將消失
- (void)keyboardWillHide:(NSNotification*)aNotification
{
    m_kbSize=CGSizeZero;
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
    
    CGFloat nowHeight = [SMessageViewController heightForString:textView.text fontSize:textView.font.pointSize andWidth:textView.frame.size.width];
    
    NSLog(@"%f",nowHeight);
    if (nowHeight<MaxHeightOfTextView) {
        if (nowHeight>textView.frame.size.height&&nowHeight>m_oldframe.size.height) {
            m_oldframe.size.height=nowHeight;
            CGFloat distance = textView.frame.size.height-nowHeight;
            m_oldframe.origin.y+=distance;
            
            [textView setFrame:m_oldframe];
            
            NSLog(@"%@",textView);
        }else{
            m_oldframe.size.height=nowHeight;
            CGFloat distance = textView.frame.size.height-nowHeight;
            m_oldframe.origin.y+=distance;

            [textView setFrame:m_oldframe];
        }
    }
}

- (BOOL)textView: (UITextView *)textview shouldChangeTextInRange: (NSRange)range replacementText: (NSString *)text {
    return YES;
}

#pragma mark - HeightForString
+ (CGFloat)heightForString:(NSString *)strContent fontSize:(CGFloat)fontSize andWidth:(CGFloat)width
{
    UITextView *detailTextView = [[UITextView alloc]initWithFrame:CGRectMake(0, 0, width, 0)];
    detailTextView.font = [UIFont systemFontOfSize:fontSize];
    detailTextView.text = strContent;
    CGSize deSize = [detailTextView sizeThatFits:CGSizeMake(width,CGFLOAT_MAX)];
    return deSize.height;
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
