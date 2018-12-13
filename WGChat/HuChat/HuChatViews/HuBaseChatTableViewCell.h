//
//  HuBaseChatTableViewCell.h
//  WGChat
//
//  Created by wanggang on 2018/12/13.
//  Copyright © 2018 WG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HuChatMessageLayout.h"
#import "HuChatMessageModel.h"
#import "HuChatGlobleDefine.h"

NS_ASSUME_NONNULL_BEGIN

@interface HuBaseChatTableViewCell : UITableViewCell

-(void)initSSChatCellUserInterface;

@property(nonatomic, strong) NSIndexPath           *indexPath;
@property(nonatomic, strong) HuChatMessageLayout  *layout;

//撤销 删除 复制
@property(nonatomic, strong) UIMenuController *menu;

//头像  时间  背景按钮
@property(nonatomic, strong) UIButton *mHeaderImgBtn;
@property(nonatomic, strong) UILabel  *mMessageTimeLab;
@property(nonatomic, strong) UIButton  *mBackImgButton;

//消息按钮
-(void)buttonPressed:(UIButton *)sender;

//文本消息
@property(nonatomic, strong) UITextView     *mTextView;

//图片消息
@property(nonatomic,strong) UIImageView *mImgView;

//视频消息
@property(nonatomic,strong) UIButton *mVideoBtn;
@property(nonatomic,strong) UIImageView *mVideoImg;

@end

NS_ASSUME_NONNULL_END
