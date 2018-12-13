//
//  HuChatGlobleDefine.h
//  WGChat
//
//  Created by wanggang on 2018/12/11.
//  Copyright © 2018 WG. All rights reserved.
//

#import "HuDeviceDefault.h"

#ifndef HuChatGlobleDefine_h
#define HuChatGlobleDefine_h

//当前窗口的高度 宽度
#define SCREEN_Height [[UIScreen mainScreen] bounds].size.height
#define SCREEN_Width  [[UIScreen mainScreen] bounds].size.width


#define makeColorRgb(_r, _g, _b)   [UIColor colorWithRed:_r / 255.0f green: _g / 255.0f blue:_b / 255.0f alpha:1]

#define HuChatCellColor  makeColorRgb(250, 250, 250)

//普通的灰色背景
#define BackGroundColor  makeColorRgb(246, 247, 248)
//cell线条颜色
#define CellLineColor  makeColorRgb(200, 200, 200)

//安全区域顶部
#define SafeAreaTop_Height  [HuDeviceDefault shareHuDeviceDefault].safeAreaTopHeight
//安全区域底部（iPhone X有）
#define SafeAreaBottom_Height  [HuDeviceDefault shareHuDeviceDefault].safeAreaBottomHeight

//状态栏
#define StatuBar_Height  [HuDeviceDefault shareHuDeviceDefault].statuBarHeight

#endif /* HuChatGlobleDefine_h */
