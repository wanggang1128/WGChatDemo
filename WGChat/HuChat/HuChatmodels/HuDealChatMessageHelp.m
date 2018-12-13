//
//  HuDealChatMessageHelp.m
//  WGChat
//
//  Created by wanggang on 2018/12/13.
//  Copyright © 2018 WG. All rights reserved.
//

#import "HuDealChatMessageHelp.h"

@implementation HuDealChatMessageHelp

//把一条消息转为布局模型
+ (HuChatMessageLayout *)getMessageWithDic:(NSDictionary *)dic{
    
    HuChatMessageModel *message = [[HuChatMessageModel alloc] init];
    
    SSChatMessageType messageType = (SSChatMessageType)[dic[@"type"]integerValue];
    SSChatMessageFrom messageFrom = (SSChatMessageFrom)[dic[@"from"]integerValue];
    
    if(messageFrom == SSChatMessageFromMe){
        message.messageFrom = SSChatMessageFromMe;
        message.backImgString = @"selfBubble";
    }else{
        message.messageFrom = SSChatMessageFromOther;
        message.backImgString = @"otherBubble";
    }
    
    
    message.sessionId    = dic[@"sessionId"];
    message.sendError    = NO;
    message.headerImgurl = dic[@"headerImg"];
    message.messageId    = dic[@"messageId"];
    message.textColor    = SSChatTextColor;
    message.messageType  = messageType;
    
    
    //判断时间是否展示
    message.messageTime = [NSTimer getChatTimeStr2:[NSTimer getStampWithTime:dic[@"date"]]];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    if([user valueForKey:message.sessionId]==nil){
        [user setValue:dic[@"date"] forKey:message.sessionId];
        message.showTime = YES;
    }else{
        [message showTimeWithLastShowTime:[user valueForKey:message.sessionId] currentTime:dic[@"date"]];
        if(message.showTime){
            [user setValue:dic[@"date"] forKey:message.sessionId];
        }
    }
    
    //判断消息类型
    if(message.messageType == SSChatMessageTypeText){
        
        message.cellString   = SSChatTextCellId;
        message.textString = dic[@"text"];
    }else if (message.messageType == SSChatMessageTypeImage){
        message.cellString   = SSChatImageCellId;
        
        if([dic[@"image"] isKindOfClass:NSClassFromString(@"NSString")]){
            message.image = [UIImage imageNamed:dic[@"image"]];
        }else{
            message.image = dic[@"image"];
        }
    }else if (message.messageType == SSChatMessageTypeVoice){
        
        message.cellString   = SSChatVoiceCellId;
        message.voice = dic[@"voice"];
        message.voiceDuration = [dic[@"second"]integerValue];
        message.voiceTime = [NSString stringWithFormat:@"%@'s ",dic[@"second"]];
        
        message.voiceImg = [UIImage imageNamed:@"chat_animation_white3"];
        message.voiceImgs =
        @[[UIImage imageNamed:@"chat_animation_white1"],
          [UIImage imageNamed:@"chat_animation_white2"],
          [UIImage imageNamed:@"chat_animation_white3"]];
        
        if(messageFrom == SSChatMessageFromOther){
            
            message.voiceImg = [UIImage imageNamed:@"chat_animation3"];
            message.voiceImgs =
            @[[UIImage imageNamed:@"chat_animation1"],
              [UIImage imageNamed:@"chat_animation2"],
              [UIImage imageNamed:@"chat_animation3"]];
        }
        
    }else if (message.messageType == SSChatMessageTypeVideo){
        message.cellString = SSChatVideoCellId;
        message.videoLocalPath = dic[@"videoLocalPath"];
        message.videoImage = [UIImage getImage:message.videoLocalPath];
    }
    
    HuChatMessageLayout *layout = [[HuChatMessageLayout alloc] initWithMessage:message];
    return layout;
}

//处理接收的消息数组
+ (NSMutableArray *)receiveMessages:(NSArray *)messages{
    
    NSMutableArray *array = [NSMutableArray new];
    for(NSDictionary *dic in messages){
        HuChatMessageLayout *layout = [self getMessageWithDic:dic];
        [array addObject:layout];
    }
    return array;
}

//发送一条消息
+(void)sendMessage:(NSDictionary *)dict sessionId:(NSString *)sessionId messageType:(SSChatMessageType)messageType messageBlock:(MessageBlock)messageBlock{
    
    NSMutableDictionary *messageDic = [NSMutableDictionary dictionaryWithDictionary:dict];
    
    NSString *time = [NSTimer getLocationTime];
    NSString *messageId = [time stringByReplacingOccurrencesOfString:@" " withString:@""];
    messageId = [messageId stringByReplacingOccurrencesOfString:@"-" withString:@""];
    messageId = [messageId stringByReplacingOccurrencesOfString:@":" withString:@""];
    
    
    switch (messageType) {
        case SSChatMessageTypeText:{
            [messageDic setObject:@"1" forKey:@"from"];
            [messageDic setValue:time forKey:@"date"];
            [messageDic setValue:@(messageType) forKey:@"type"];
            [messageDic setValue:messageId forKey:@"messageId"];
            [messageDic setValue:sessionId forKey:@"sessionId"];
//            [messageDic setValue:headerImg1 forKey:@"headerImg"];
        }
            break;
        case SSChatMessageTypeImage:{
            [messageDic setObject:@"1" forKey:@"from"];
            [messageDic setValue:time forKey:@"date"];
            [messageDic setValue:@(messageType) forKey:@"type"];
            [messageDic setValue:messageId forKey:@"messageId"];
            [messageDic setValue:sessionId forKey:@"sessionId"];
//            [messageDic setValue:headerImg1 forKey:@"headerImg"];
        }
            break;
        case SSChatMessageTypeVoice:{
            [messageDic setObject:@"1" forKey:@"from"];
            [messageDic setValue:time forKey:@"date"];
            [messageDic setValue:@(messageType) forKey:@"type"];
            [messageDic setValue:messageId forKey:@"messageId"];
            [messageDic setValue:sessionId forKey:@"sessionId"];
//            [messageDic setValue:headerImg1 forKey:@"headerImg"];
        }
            break;
        case SSChatMessageTypeVideo:{
            [messageDic setObject:@"1" forKey:@"from"];
            [messageDic setValue:time forKey:@"date"];
            [messageDic setValue:@(messageType) forKey:@"type"];
            [messageDic setValue:messageId forKey:@"messageId"];
            [messageDic setValue:sessionId forKey:@"sessionId"];
//            [messageDic setValue:headerImg1 forKey:@"headerImg"];
        }
            break;
            
        default:
            break;
    }
    
    HuChatMessageLayout *layout = [self getMessageWithDic:messageDic];
    NSProgress *pre = [[NSProgress alloc]init];
    
    if (messageBlock) {
        messageBlock(layout,nil,pre);
    }
}


@end
