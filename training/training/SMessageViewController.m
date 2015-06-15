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

@interface SMessageViewController ()<iMessageUtilityDelegte,UITextViewDelegate>
{
    CGSize m_kbSize;
    CGRect m_oldFrameOfmainView;
    NSMutableArray *m_aryMessageItem;
    ChatMessageItem *m_MessageItem;
    CGRect m_oldframe;                          //TextView的舊frame
    CGRect m_initialFrameOfmessageTextView;     //TextView的初始frame
    CGRect m_oldFrameOfsendView;
    SCustomView *vc;
}
@property (weak, nonatomic) IBOutlet UITableView *m_TableView;
@property (weak, nonatomic) IBOutlet UIView *m_mainView;
@property (weak, nonatomic) IBOutlet UITextView *m_messageTextView;
@property (weak, nonatomic) IBOutlet UIView *m_sendView;


@end

@implementation SMessageViewController
{
    NSString *m_strMessageNotification;
    NSString *a;
    NSString *b;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    a=TestUserName;
    b=TestChat;
    m_strMessageNotification = [NSString stringWithFormat:@"N%@", b];
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
    vc=[[SCustomView alloc] initWithvc:self name:@"s"];
    [self.view addSubview:vc];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[iMessageUtility sharedManager] setDelegate:self];
    
    m_aryMessageItem=[[iMessageUtility sharedManager] queryChatsFromTableByAccount:b isGroup:NO withLimit:20];
    [[iMessageUtility sharedManager] checkChatTableIsExisted:a isGroup:NO];
    [[iMessageUtility sharedManager] getChatListByPhoneFromWS:b];
    
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    m_initialFrameOfmessageTextView=_m_messageTextView.frame;
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
    [self.m_messageTextView setFrame:m_initialFrameOfmessageTextView];
}
- (IBAction)otherBtnAction:(UIButton *)sender {
    
    [vc showView];
    NSLog(@"%@",vc);
    
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
    [vc setKeyBoardHeight:m_kbSize.height];
    [self moveCollectionView:m_kbSize];
    m_oldframe=_m_messageTextView.frame;
    m_oldFrameOfsendView=_m_sendView.frame;
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
    CGRect frame = textView.frame;
    CGSize constraintSize = CGSizeMake(frame.size.width, MAXFLOAT);
    CGSize size = [textView sizeThatFits:constraintSize];
//    CGFloat sad=m_oldFrameOfsendView.size.height+m_oldFrameOfsendView.origin.y;
    CGFloat distance=frame.size.height+frame.origin.y;
    if (size.height >= MaxHeightOfTextView)
    {
        size.height = MaxHeightOfTextView;
        textView.scrollEnabled = YES;   // 允许滚动
    }
    else
    {
        textView.scrollEnabled = NO;    // 不允许滚动，当textview的大小足以容纳它的text的时候，需要设置scrollEnabed为NO，否则会出现光标乱滚动的情况
    }
//    _m_sendView.frame = CGRectMake(m_oldFrameOfsendView.origin.x, sad-size.height, m_oldFrameOfsendView.size.width, size.height);
    textView.frame = CGRectMake(frame.origin.x, distance-size.height, frame.size.width, size.height);

//
//    CGFloat nowHeight = [SMessageViewController heightForString:textView.text fontSize:textView.font.pointSize andWidth:textView.frame.size.width];
//    
//    NSLog(@"%f",nowHeight);
//    if (nowHeight<MaxHeightOfTextView) {
//        if (nowHeight>textView.frame.size.height&&nowHeight>m_oldframe.size.height) {
//            m_oldframe.size.height=nowHeight;
//            CGFloat distance = textView.frame.size.height-nowHeight;
//            m_oldFrameOfsendView.origin.y+=distance;
//            m_oldFrameOfsendView.size.height-=distance;
//            [_m_sendView setFrame:m_oldFrameOfsendView];
//            [textView setFrame:m_oldframe];
//            NSLog(@"____________________________________________");
//            NSLog(@"%f",distance);
//            NSLog(@"____________________________________________");
//            NSLog(@"%@",textView);
//            NSLog(@"____________________________________________");
//            NSLog(@"%@",_m_sendView);
//            NSLog(@"____________________________________________");
//            
//        }else{
//            m_oldframe.size.height=nowHeight;
//            CGFloat distance = textView.frame.size.height-nowHeight;
//            m_oldFrameOfsendView.origin.y+=distance;
//            m_oldFrameOfsendView.size.height-=distance;
//            [_m_sendView setFrame:m_oldFrameOfsendView];
//           
//            
//
//            textView.frame=m_oldframe;
//
//        }
//    }
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
