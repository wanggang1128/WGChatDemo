//
//  HuKeyBoardStatus.h
//  WGChat
//
//  Created by wanggang on 2018/12/11.
//  Copyright © 2018 WG. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 自定义键盘视图,点击按钮的状态

 HuKeyBoardStatusDefault    默认输入框在底部收缩状态(例如刚进入聊天界面时)
 HuKeyBoardStatusVoice      准备录音状态(按住说话)
 HuKeyBoardStatusEdit       准备输入文字(键盘已经弹起)
 HuKeyBoardStatusSymbol     准备输入表情(表情键盘已经弹起)
 HuKeyBoardStatusAdd        准备选择视频或者图片
 
 第一版:
 HuKeyBoardStatusVoice,HuKeyBoardStatusSymbol,HuKeyBoardStatusAdd三种状态不需要
 
 */
typedef NS_ENUM(NSInteger, HuKeyBoardStatus){
    
    HuKeyBoardStatusDefault = 1,
    HuKeyBoardStatusVoice,
    HuKeyBoardStatusEdit,
    HuKeyBoardStatusSymbol,
    HuKeyBoardStatusAdd,
    
};



/**
 重写键盘视图是表情选择还是图库选择
 HuKeyBoardCustomViewTypeAdd 相册
 HuKeyBoardCustomViewTypeSymbol 表情
 
 第一版:  这个枚举不需要
 */
typedef NS_ENUM(NSInteger, HuKeyBoardCustomViewType){
    
    HuKeyBoardCustomViewTypeAdd = 1,
    HuKeyBoardCustomViewTypeSymbol,
};
