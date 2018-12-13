//
//  HuVoiceChatTableViewCell.h
//  WGChat
//
//  Created by wanggang on 2018/12/13.
//  Copyright © 2018 WG. All rights reserved.
//

#import "HuBaseChatTableViewCell.h"
#import "UUAVAudioPlayer.h"


NS_ASSUME_NONNULL_BEGIN

@interface HuVoiceChatTableViewCell : HuBaseChatTableViewCell

@property (nonatomic, strong) UIView *voiceBackView;
@property (nonatomic, strong) UILabel *mTimeLab;
@property (nonatomic, strong) UIImageView *mVoiceImg;
@property (nonatomic, strong) UIActivityIndicatorView *indicator;

//是否在播放
@property (nonatomic, assign)BOOL contentVoiceIsPlaying;

//音频路径 音频文件 播放控制
@property(nonatomic, strong)NSString *voiceURL;
@property(nonatomic, strong)NSData *songData;
@property(nonatomic, strong)UUAVAudioPlayer *audio;

@end

NS_ASSUME_NONNULL_END
