//
//  HuDealChatMessageHelp.h
//  WGChat
//
//  Created by wanggang on 2018/12/13.
//  Copyright © 2018 WG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HuChatMessageLayout.h"
#import "HuChatMessageModel.h"
#import "HuChatMessageConfig.h"

NS_ASSUME_NONNULL_BEGIN

@interface HuDealChatMessageHelp : NSObject

/**
 消息内容生成消息布局模型

 @param dic 消息内容
 @return 消息布局模型
 */
+ (HuChatMessageLayout *)getMessageWithDic:(NSDictionary *)dic;

/**
 处理消息数组 一般进入聊天界面会初始化之前的消息展示
 
 @param messages 消息数组
 @return 返回消息模型布局后的数组
 */
+(NSMutableArray *)receiveMessages:(NSArray *)messages;

/**
 发送消息回调
 
 @param layout 消息
 @param error 发送是否成功
 @param progress 发送进度
 */
typedef void (^MessageBlock)(HuChatMessageLayout *layout, NSError *error, NSProgress *progress);

/**
 发送一条消息
 
 @param dict 消息主体
 @param sessionId 会话id
 @param messageType 消息类型
 @param messageBlock 发送消息回调
 */
+(void)sendMessage:(NSDictionary *)dict sessionId:(NSString *)sessionId messageType:(SSChatMessageType)messageType messageBlock:(MessageBlock)messageBlock;

@end

NS_ASSUME_NONNULL_END
