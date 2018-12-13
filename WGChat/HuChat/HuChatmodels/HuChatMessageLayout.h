//
//  HuChatMessageLayout.h
//  WGChat
//
//  Created by wanggang on 2018/12/13.
//  Copyright © 2018 WG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HuChatMessageConfig.h"
#import "HuChatMessageModel.h"
#import "HuChatGlobleDefine.h"

NS_ASSUME_NONNULL_BEGIN

@interface HuChatMessageLayout : NSObject

/**
 根据模型生成布局
 
 @param message 传入消息模型
 @return 返回布局对象
 */
-(instancetype)initWithMessage:(HuChatMessageModel *)message;

//消息模型
@property (nonatomic, strong) HuChatMessageModel  *message;

//消息布局到CELL的总高度
@property (nonatomic, assign) CGFloat      cellHeight;

//时间控件的frame
@property (nonatomic, assign) CGRect       timeLabRect;
//头像控件的frame
@property (nonatomic, assign) CGRect       headerImgRect;
//背景按钮的frame
@property (nonatomic, assign) CGRect       backImgButtonRect;
//背景按钮图片的拉伸膜是和保护区域
@property (nonatomic, assign) UIEdgeInsets imageInsets;

//文本间隙的处理
@property (nonatomic, assign) UIEdgeInsets textInsets;
//文本控件的frame
@property (nonatomic, assign) CGRect       textLabRect;

//语音时长控件的frame
@property (nonatomic, assign) CGRect       voiceTimeLabRect;
//语音波浪图标控件的frame
@property (nonatomic, assign) CGRect       voiceImgRect;


//视频控件的frame
@property (nonatomic, assign) CGRect       videoImgRect;

@end

NS_ASSUME_NONNULL_END
