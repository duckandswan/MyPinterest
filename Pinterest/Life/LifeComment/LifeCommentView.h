//
//  LifeCommentView.h
//  finding
//
//  Created by yangwei on 16/3/25.
//  Copyright © 2016年 zhangli. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EaseChatToolbar.h"

@interface LifeCommentView : UIView<UITableViewDataSource,UITableViewDelegate,
UIGestureRecognizerDelegate,EMChatToolbarDelegate>{

    NSArray *commentListData;
    UIView *dataView;
//    EaseChatToolbar *toolbar;
}

@property(nonatomic,strong)UITableView *commentTableView;

@property(nonatomic,strong)UILabel *commentNumLabel;

/*!
 @property
 @brief 底部输入控件
 */
@property (strong, nonatomic) UIView *chatToolbar;

/*!
 @property
 @brief 底部表情控件
 */
@property(strong, nonatomic) EaseFaceView *faceView;

/*!
 @property
 @brief 底部功能控件
 */
@property(strong, nonatomic) EaseChatBarMoreView *chatBarMoreView;

@property(assign,nonatomic) UIViewController *footViewController;

-(void)setListData:(NSArray*)list minId:(NSString*)minId total:(NSInteger)total;
-(id)initWithlist:(NSArray *)list storyCollectionId:(NSString*)storyCollectionId height:(NSInteger)height;
- (void)showInView:(UIViewController *)Sview;

@end
