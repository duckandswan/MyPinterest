//
//  CommentTableCell.m
//  finding
//
//  Created by yangwei on 16/3/25.
//  Copyright © 2016年 zhangli. All rights reserved.
//

#import "CommentTableCell.h"
#import "UIImageView+EMWebCache.h"

@interface CommentTableCell(){

    UIImageView *commentUserImageView;
    UILabel *nickNameLabel;
    
    UILabel *dateLabel;
    
    UIButton *nickNameBtn;
    
    NSString *mUserId;
}

@end

@implementation CommentTableCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{


    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initUI];
    }
    return self;
}

-(void)initUI{

    commentUserImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 15, 30, 30)];
      commentUserImageView.layer.cornerRadius = 15;
    commentUserImageView.layer.masksToBounds = YES;
    [self addSubview:commentUserImageView];
    
    nickNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(commentUserImageView.frame)+10,
                                                             15, self.frame.size.width - 100, 15)];
    nickNameLabel.font = [UIFont systemFontOfSize:14.0];
    nickNameLabel.textColor = [UIColor blackColor];
    [self addSubview:nickNameLabel];
    
    _contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(commentUserImageView.frame)+10,
                                                            CGRectGetMaxY(nickNameLabel.frame)+5, self.frame.size.width - 60, 20)];
    _contentLabel.font = [UIFont systemFontOfSize:13.0];
    _contentLabel.textColor = [UIColor grayColor];
    
    [self addSubview:_contentLabel];
    
    
    dateLabel = [[UILabel alloc]initWithFrame:CGRectMake([[UIScreen mainScreen] applicationFrame].size.width - 110, 15, 100, 15)];
    dateLabel.font = [UIFont systemFontOfSize:13.0];
    dateLabel.textAlignment = NSTextAlignmentRight;
    dateLabel.textColor = [UIColor grayColor];
    [self addSubview:dateLabel];
    
    nickNameBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    nickNameBtn.backgroundColor = [UIColor clearColor];
    [nickNameBtn addTarget:self action:@selector(clickNick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:nickNameBtn];
}

-(void)clickNick{

    if (_delegate) {
        [_delegate gotoUserViewController:mUserId];
    }
}

-(void)setData:(NSDictionary*)dataDic{
    mUserId = [NSString stringWithFormat:@"%@",dataDic[@"replyUserId"]];
    NSString* urlStr = dataDic[@"avatar"];
    
    NSString *didReceiveText = [EaseConvertToCommonEmoticonsHelper convertToSystemEmoticons:dataDic[@"replyContent"]];
    
    NSString* replyContent = didReceiveText;
    NSString* userNick = dataDic[@"userNick"];
    NSString* replyUserNick = dataDic[@"replyUserNick"];
    
    dateLabel.text = dataDic[@"createTime"];
    nickNameLabel.text = userNick;
    
    if (replyUserNick) {
         NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:13.0]};
       CGSize size = [replyUserNick boundingRectWithSize:CGSizeMake(MAXFLOAT,15) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;

        nickNameBtn.frame = CGRectMake(CGRectGetMaxX(commentUserImageView.frame)+10+25,
                                       CGRectGetMaxY(nickNameLabel.frame)+5,size.width, 15);
        
//        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"回复%@:%@",replyUserNick,replyContent]];
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",replyContent]];
//        [str addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:NSMakeRange(2,replyUserNick.length)];;
//        [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Arial-BoldItalicMT" size:13.0] range:NSMakeRange(2, replyUserNick.length)];
        _contentLabel.attributedText = str;
    }else{
    
        _contentLabel.text = replyContent;
    }
    
    _contentLabel.numberOfLines = 0;
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:13.0]};
    CGSize size = [_contentLabel.text boundingRectWithSize:CGSizeMake(self.frame.size.width-60, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    _contentLabel.frame = CGRectMake(CGRectGetMaxX(commentUserImageView.frame)+10,
                                    CGRectGetMaxY(nickNameLabel.frame)+5, self.frame.size.width - 60, size.height);
    [commentUserImageView sd_setImageWithURL:[NSURL URLWithString:urlStr]
                         placeholderImage:[UIImage imageNamed:@"head_big_default"]];
}

@end
