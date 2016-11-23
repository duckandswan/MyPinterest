//
//  LifeCommentView.m
//  finding
//
//  Created by yangwei on 16/3/25.
//  Copyright © 2016年 zhangli. All rights reserved.
//

#import "LifeCommentView.h"
#import "CommentTableCell.h"
#import "finding-Swift.h"

#define RGBACOLOR(r, g, b, a)   [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]

@interface LifeCommentView()<CommentDelegate>{
    
    UIView *headView;
    NSMutableArray *dataArra;
    
    UIButton *commentCancelBtn;
    
    NSString *storyCollectionReplyId;
    NSString *mStoryCollectionId;
    
}
@property  (nonatomic,strong)   NSString *mReplyUserId;
@property  (nonatomic,strong)   NSString *commentMinId;

@end

@implementation LifeCommentView

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

-(id)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        
    }
    
    return self;
}

-(id)initWithlist:(NSArray *)list
storyCollectionId:(NSString*)storyCollectionId
           height:(NSInteger)height{
    
    self = [super init];
    if (self) {
        dataArra = [NSMutableArray arrayWithArray:list];
        storyCollectionReplyId = @"";
        mStoryCollectionId = storyCollectionId;
        self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width,
                                [UIScreen mainScreen].bounds.size.height);
        self.backgroundColor = [[UIColor grayColor]colorWithAlphaComponent:0.6];
        
        dataView = [[UIView alloc]initWithFrame:CGRectMake(0, self.frame.size.height,
                                                           self.frame.size.width,
                                                           self.frame.size.height)];
        dataView.backgroundColor = [UIColor whiteColor];
        [self addSubview:dataView];
        
        _commentNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, dataView.frame.size.width, 20)];
        _commentNumLabel.textColor = [UIColor blackColor];
        _commentNumLabel.font = [UIFont systemFontOfSize:14.0];
        [dataView addSubview:_commentNumLabel];
        _commentNumLabel.text = [NSString stringWithFormat:@"评论%ld条",(long)height];
        
        UIView *cancelKeyBoardView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,
                                                                             dataView.frame.size.width, 40)];
        [dataView addSubview:cancelKeyBoardView];
        cancelKeyBoardView.backgroundColor = [UIColor clearColor];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                     action:@selector(keyboardCancel)];
        [cancelKeyBoardView addGestureRecognizer:tapGesture];
        
        
        commentCancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        commentCancelBtn.frame = CGRectMake(dataView.frame.size.width - 40, 10, 25, 25);
        [commentCancelBtn setImage:[UIImage imageNamed:@"btn_cancel"] forState:UIControlStateNormal];
        [dataView addSubview:commentCancelBtn];
        [commentCancelBtn addTarget:self action:@selector(commentCancelClick) forControlEvents:UIControlEventTouchUpInside];
        
        headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, 100)];
        headView.backgroundColor = [UIColor clearColor];
        [self addSubview:headView];
        
        _commentTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, dataView.frame.size.width, dataView.frame.size.height)
                                                        style:UITableViewStylePlain];
        _commentTableView.tableFooterView = [UIView new];
        _commentTableView.dataSource = self;
        _commentTableView.delegate = self;
        [dataView addSubview:_commentTableView];
        
        self.chatToolbar = [[EaseChatToolbar alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 46,
                                                                             self.frame.size.width, 46)
                                                             type:EMChatToolbarTypeChat];
        self.chatToolbar.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
        
        
        [dataView addSubview:self.chatToolbar];
        //        dataArra = list;
        if (dataArra && dataArra.count > 0) {
            self.commentMinId = [NSString stringWithFormat:@"%@",[dataArra[dataArra.count - 1]objectForKey:@"storyCollectionReplyId"]];
        }else{
            
            
        }
        
        __weak LifeCommentView *weakSelf = self;
        
        [self.commentTableView addLegendFooterWithRefreshingBlock:^{
            [weakSelf queryCommentListData];
            [weakSelf.commentTableView.footer beginRefreshing];
            
        }];
        [self.commentTableView.footer setTitle:@"" forState:MJRefreshFooterStateIdle];
        
        [self animeData];
    }
    
    return self;
}

-(void)queryCommentListData{
    
    if (dataArra && dataArra.count > 0) {
        self.commentMinId = [NSString stringWithFormat:@"%@",[dataArra[dataArra.count - 1]objectForKey:@"storyCollectionReplyId"]];
    }else{
        
        
    }
    
    [Utilies queryCommentListData:self.commentMinId storyCollectionId:mStoryCollectionId vc:self];
}

-(void)animeData{
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedCancel)];
    [headView addGestureRecognizer:tapGesture];
    //    tapGesture.delegate = self;
    [UIView animateWithDuration:.25 animations:^{
        self.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.5];
        [UIView animateWithDuration:.25 animations:^{
            [dataView setFrame:CGRectMake(dataView.frame.origin.x,
                                          100,
                                          dataView.frame.size.width,
                                          dataView.frame.size.height-100)];
            _commentTableView.frame = CGRectMake(dataView.frame.origin.x, 40,
                                                 dataView.frame.size.width,
                                                 dataView.frame.size.height-86);
            self.chatToolbar.frame = CGRectMake(0, dataView.frame.size.height - 46,
                                                dataView.frame.size.width, 46);
            headView.frame = CGRectMake(0, 0, self.frame.size.width, 100);
        }];
    } completion:^(BOOL finished) {
    }];
    
}

/**
 *  文字输入框开始编辑
 *
 *  @param inputTextView 输入框对象
 */
- (void)inputTextViewDidBeginEditing:(EaseTextView *)inputTextView{
    
    
}

/**
 *  发送文字消息，可能包含系统自带表情
 *
 *  @param text 文字消息
 */
- (void)didSendText:(NSString *)text{
    
     NSString *didReceiveText = [EaseConvertToCommonEmoticonsHelper convertToCommonEmoticons:text];
    
    [((EaseChatToolbar *)self.chatToolbar).inputTextView resignFirstResponder];
    //    [_chatToolbar];
    [Utilies queryAddReplyData:mStoryCollectionId
                 replyContent:didReceiveText
                       userId:Utilies.CURRENT_USER_ID replyUserId:self.mReplyUserId
                 commentMinId:self.commentMinId
                  commentView:self];
    ((EaseChatToolbar *)self.chatToolbar).inputTextView.text = @"";
    
}



- (void)setChatToolbar:(EaseChatToolbar *)chatToolbar
{
    [_chatToolbar removeFromSuperview];
    
    _chatToolbar = chatToolbar;
    
    if (_chatToolbar) {
        [dataView addSubview:_chatToolbar];
    }
    
    if ([chatToolbar isKindOfClass:[EaseChatToolbar class]]) {
        [(EaseChatToolbar *)self.chatToolbar setDelegate:self];
        self.faceView = (EaseFaceView*)[(EaseChatToolbar *)self.chatToolbar faceView];
        self.chatBarMoreView = (EaseChatBarMoreView*)[(EaseChatToolbar *)self.chatToolbar moreView];
        self.chatBarMoreView.hidden = YES;
        ((EaseChatToolbar *)self.chatToolbar).moreButton.hidden = YES;
        
        ((EaseChatToolbar *)self.chatToolbar).faceButton.frame = ((EaseChatToolbar *)self.chatToolbar).moreButton.frame;
        ((EaseChatToolbar *)self.chatToolbar).inputTextView.frame = CGRectMake(10, 5, self.frame.size.width - 60, ((EaseChatToolbar *)self.chatToolbar).faceButton.frame.size.height);
        NSLog(@"count---%@", self.chatToolbar.subviews);
        
        ((EaseChatToolbar *)self.chatToolbar).inputTextView.placeHolder = @"添加评论...";
        
        NSMutableArray *emotions = [NSMutableArray array];
        for (NSString *name in [EaseEmoji allEmoji]) {
            EaseEmotion *emotion = [[EaseEmotion alloc] initWithName:@"" emotionId:name emotionThumbnail:name emotionOriginal:name emotionOriginalURL:@"" emotionType:EMEmotionDefault];
            [emotions addObject:emotion];
        }
        
        EaseEmotion *emotion = [emotions objectAtIndex:0];
        EaseEmotionManager *manager= [[EaseEmotionManager alloc] initWithType:EMEmotionDefault emotionRow:3 emotionCol:7 emotions:emotions tagImage:[UIImage imageNamed:emotion.emotionId]];
        [self.faceView setEmotionManagers:@[manager]];
    }
    
}

-(void)tappedCancel{
    [UIView animateWithDuration:.25 animations:^{
        [dataView setFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height,
                                      [UIScreen mainScreen].bounds.size.width,
                                      0)];
        
        self.alpha = 0;
    } completion:^(BOOL finished) {
        if (finished) {
            [self removeFromSuperview];
        }
    }];
}

- (void)showInView:(UIViewController *)vc
{
    [vc.view addSubview:self];
    _footViewController = vc;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *desConetn = dataArra[indexPath.row][@"replyContent"];
    NSString* replyUserNick = dataArra[indexPath.row][@"replyUserNick"];
    
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:13.0]};
    CGSize size = [[NSString stringWithFormat:@"回复%@:%@",replyUserNick,desConetn] boundingRectWithSize:CGSizeMake(self.frame.size.width-60, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    
    return size.height + 50;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return dataArra.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    CommentTableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell==nil){
        cell = [[CommentTableCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.delegate = self;
    [cell setData:dataArra[indexPath.row]];
    // Configure the cell...
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
//    NSString *nickName = dataArra[indexPath.row][@"userNick"];
//    storyCollectionReplyId = dataArra[indexPath.row][@"storyCollectionReplyId"];
//    self.mReplyUserId = [NSString stringWithFormat:@"%@",dataArra[indexPath.row][@"userId"]];
//    [((EaseChatToolbar *)self.chatToolbar).inputTextView becomeFirstResponder];
//    ((EaseChatToolbar *)self.chatToolbar).inputTextView.placeHolder = [NSString stringWithFormat:@"回复%@:",nickName];
    
}

#pragma mark----点击删除按钮
-(void)commentCancelClick{
    
    [self tappedCancel];
}

#pragma mark---隐藏键盘
-(void)keyboardCancel{
    
    [((EaseChatToolbar *)self.chatToolbar).inputTextView resignFirstResponder];
}

-(void)setListData:(NSArray *)list minId:(NSString*)minId total:(NSInteger)total{
    
    
    if (list.count == 0){
        [self.commentTableView.footer noticeNoMoreData];
    }else
    {
        if ([minId isEqualToString:@""]) {
            [dataArra removeAllObjects];
            [dataArra addObjectsFromArray:list];
        }else{
            
            [dataArra addObjectsFromArray:list];
        }
    }
    _commentNumLabel.text = [NSString stringWithFormat:@"评论%lu条",total];
    [_commentTableView reloadData];
}

#pragma mark---cell--delegate
-(void)gotoUserViewController:(NSString *)userId{

//    [_footViewController presentViewController: animated:YES completion:nil];
//     MyScriptHandler.toUserPage(self, userId: String(ges.userId))
    [MyScriptHandler toUserPage:_footViewController userId:userId closure:^() {
        
    }];
}

@end
