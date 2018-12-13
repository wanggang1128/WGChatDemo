//
//  HuChatMessageModel.h
//  WGChat
//
//  Created by wanggang on 2018/12/11.
//  Copyright © 2018 WG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HuChatMessageConfig.h"
#import "NSTimer+SSAdd.h"
#import "UIImage+SSAdd.h"
#import "UIView+SSAdd.h"
#import "NSObject+SSAdd.h"

NS_ASSUME_NONNULL_BEGIN

@interface HuChatMessageModel : NSObject

/**
 判断当前时间是否展示
 
 @param lastTime 最后展示的时间
 @param currentTime 当前时间
 */
-(void)showTimeWithLastShowTime:(NSString *)lastTime currentTime:(NSString *)currentTime;



//消息发送方  消息类型  消息对应cell类型
@property (nonatomic, assign) SSChatMessageFrom messageFrom;
@property (nonatomic, assign) SSChatMessageType messageType;
@property (nonatomic, strong) NSString     *cellString;

//会话id
@property (nonatomic, strong) NSString    *sessionId;

//消息id   消息时间  是否显示时间 （这里需要什么就设置什么 不宜过多）
@property (nonatomic, strong) NSString    *messageId;
@property (nonatomic, strong) NSString    *messageTime;
@property (nonatomic, assign) BOOL        showTime;

//消息是否发送失败
@property (nonatomic, assign) BOOL sendError;

//头像
@property (nonatomic, strong) NSString    *headerImgurl;

//单条消息背景图
@property (nonatomic, strong) NSString    *backImgString;


//文本消息内容 颜色  消息转换可变字符串
@property (nonatomic, strong) NSString    *textString;
@property (nonatomic, strong) UIColor     *textColor;
@property (nonatomic, strong) NSMutableAttributedString  *attTextString;

//图片消息链接或者本地图片 图片展示格式
@property (nonatomic, strong) NSString    *imageString;
@property (nonatomic, strong) UIImage     *image;
@property (nonatomic, assign) UIViewContentMode contentMode;

//音频时长(单位：秒) 展示时长  音频网络路径  本地路径  音频
@property (nonatomic, assign) NSInteger   voiceDuration;
@property (nonatomic, strong) NSString    *voiceTime;
@property (nonatomic, strong) NSString    *voiceRemotePath;
@property (nonatomic, strong) NSString    *voiceLocalPath;
@property (nonatomic, strong) NSData      *voice;
//语音波浪图标及数组
@property (nonatomic, strong) UIImage     *voiceImg;
@property (nonatomic, strong) NSArray     *voiceImgs;


//地理位置纬度  经度   详细地址
@property (nonatomic, assign) double      latitude;
@property (nonatomic, assign) double      longitude;
@property (nonatomic, strong) NSString    *addressString;

//短视频缩略图网络路径 本地路径  视频图片 local路径
@property (nonatomic, strong) NSString    *videoRemotePath;
@property (nonatomic, strong) NSString    *videoLocalPath;
@property (nonatomic, strong) UIImage     *videoImage;
@property (nonatomic, assign) NSInteger   videodDration;


//拓展消息
@property(nonatomic,strong)NSDictionary *dict;

@end

NS_ASSUME_NONNULL_END
