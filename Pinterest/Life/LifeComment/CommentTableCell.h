//
//  CommentTableCell.h
//  finding
//
//  Created by yangwei on 16/3/25.
//  Copyright © 2016年 zhangli. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CommentDelegate <NSObject>

@optional
-(void)gotoUserViewController:(NSString*)userId;

@end

@interface CommentTableCell : UITableViewCell

@property(strong,nonatomic)UILabel *contentLabel;

@property(weak,nonatomic) id<CommentDelegate> delegate;

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;
-(void)setData:(NSDictionary*)dataDic;

@end
