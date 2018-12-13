//
//  HuKeyBoardGroundView.h
//  WGChat
//
//  Created by wanggang on 2018/12/11.
//  Copyright © 2018 WG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HuKeyBoardStatus.h"
#import <AVFoundation/AVFoundation.h>


/**
 聊天界面底部的输入框视图
 */

#define SSChatKeyBoardInputViewH      49     //输入部分的高度
#define SSChatKeyBordBottomHeight     220    //底部视图的高度

//键盘总高度
#define SSChatKeyBordHeight   SSChatKeyBoardInputViewH + SSChatKeyBordBottomHeight


#define SSChatLineHeight        0.5          //线条高度
#define SSChatBotomTop          SCREEN_Height-SSChatBotomHeight-SafeAreaBottom_Height                    //底部视图的顶部
#define SSChatBtnSize           30           //按钮的大小
#define SSChatLeftDistence      5            //左边间隙
#define SSChatRightDistence     5            //左边间隙
#define SSChatBtnDistence       10           //控件之间的间隙
#define SSChatTextHeight        33           //输入框的高度
#define SSChatTextMaxHeight     83           //输入框的最大高度
#define SSChatTextWidth      SCREEN_Width - (3*SSChatBtnSize + 5* SSChatBtnDistence)                       //输入框的宽度

#define SSChatTBottomDistence   8            //输入框上下间隙
#define SSChatBBottomDistence   8.5          //按钮上下间隙




NS_ASSUME_NONNULL_BEGIN

@protocol HuKeyBoardGroundViewDelegate <NSObject>

//改变输入框的高度 并让控制器弹出键盘
-(void)HuKeyBoardGroundViewHeight:(CGFloat)keyBoardHeight changeTime:(CGFloat)changeTime;

//发送文本信息
-(void)HuKeyBoardGroundViewSendTextBtnClick:(NSString *)string;

//点击选择图片
-(void)HuKeyBoardGroundViewAddBtnClick;


@end

@interface HuKeyBoardGroundView : UIView<UITextViewDelegate,AVAudioRecorderDelegate>

//当前的编辑状态（默认 语音 编辑文本 发送表情 其他功能）
@property(nonatomic, assign) HuKeyBoardStatus keyBoardStatus;

@property(nonatomic,assign)CGFloat changeTime;
//键盘或者 表情视图 功能视图的高度
@property(nonatomic,assign)CGFloat keyBoardHieght;

//顶部线条
@property(nonatomic,strong) UIView   *topLine;

//当前点击的按钮
@property(nonatomic,strong) UIButton *currentBtn;
//左侧按钮(语音)
@property(nonatomic,strong) UIButton *mLeftBtn;
//添加按钮(➕)
@property(nonatomic,strong) UIButton *mAddBtn;

//录音按钮(按住说话)
@property(nonatomic,strong) UIButton     *mTextBtn;
//输入框
@property(nonatomic,strong) UITextView   *mTextView;
//缓存输入的文字
@property(nonatomic,strong) NSString     *textString;
//输入框的高度
@property(nonatomic,assign) CGFloat   textH;

@property (nonatomic, weak) id<HuKeyBoardGroundViewDelegate>huKeyBoardGroundViewDelegate;

//键盘归位
-(void)SetHuKeyBoardGroundViewEndEditing;

@end

NS_ASSUME_NONNULL_END
