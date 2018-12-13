//
//  HuKeyBoardGroundView.m
//  WGChat
//
//  Created by wanggang on 2018/12/11.
//  Copyright © 2018 WG. All rights reserved.
//

#import "HuKeyBoardGroundView.h"
#import "HuChatGlobleDefine.h"
#import "UIView+SSAdd.h"
#import "UUProgressHUD.h"

@implementation HuKeyBoardGroundView

-(instancetype)init{
    self = [super init];
    if (self) {
        
        self.backgroundColor = BackGroundColor ;
        self.frame = CGRectMake(0, SCREEN_Height-SSChatKeyBoardInputViewH-SafeAreaBottom_Height, SCREEN_Width, SSChatKeyBoardInputViewH);
        
        _keyBoardStatus = HuKeyBoardStatusDefault;
        _keyBoardHieght = 0;
        _changeTime = 0.25;
        _textH = SSChatTextHeight;
        
        _topLine = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_Width, 0.5)];
        _topLine.backgroundColor = CellLineColor;
        [self addSubview:_topLine];
        
        //左侧按钮
        _mLeftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _mLeftBtn.bounds = CGRectMake(0, 0, SSChatBtnSize, SSChatBtnSize);
        _mLeftBtn.left    = SSChatBtnDistence;
        _mLeftBtn.bottom  = self.height - SSChatBBottomDistence;
        _mLeftBtn.tag  = 10;
        [self addSubview:_mLeftBtn];
        [_mLeftBtn setBackgroundImage:[UIImage imageNamed:@"jianpan"] forState:UIControlStateNormal];
        [_mLeftBtn setBackgroundImage:[UIImage imageNamed:@"jianpan"] forState:UIControlStateSelected];
        _mLeftBtn.selected = NO;
        [_mLeftBtn addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        //添加按钮
        _mAddBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _mAddBtn.bounds = CGRectMake(0, 0, SSChatBtnSize, SSChatBtnSize);
        _mAddBtn.right = SCREEN_Width - SSChatBtnDistence;
        _mAddBtn.bottom  = self.height - SSChatBBottomDistence;
        _mAddBtn.tag  = 12;
        _mAddBtn.selected = NO;
        [self addSubview:_mAddBtn];
        [_mAddBtn setBackgroundImage:[UIImage imageNamed:@"tupianku"] forState:UIControlStateNormal];
        [_mAddBtn setBackgroundImage:[UIImage imageNamed:@"tupianku"] forState:UIControlStateSelected];
        _mAddBtn.selected = NO;
        [_mAddBtn addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        // 录音按钮
        _mTextBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        _mTextBtn.bounds = CGRectMake(0, 0, SSChatTextWidth+SSChatBtnSize, SSChatTextHeight);
        _mTextBtn.left = _mLeftBtn.right+SSChatBtnDistence;
        _mTextBtn.bottom = self.height - SSChatTBottomDistence;
        _mTextBtn.backgroundColor = [UIColor whiteColor];
        _mTextBtn.layer.borderWidth = 0.5;
        _mTextBtn.layer.borderColor = CellLineColor.CGColor;
        _mTextBtn.clipsToBounds = YES;
        _mTextBtn.layer.cornerRadius = 3;
        [self addSubview:_mTextBtn];
        _mTextBtn.userInteractionEnabled = YES;
        _mTextBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        [_mTextBtn setTitleColor:makeColorRgb(100, 100, 100) forState:UIControlStateNormal];
        [_mTextBtn setTitle:@"按住 说话" forState:UIControlStateNormal];
        [_mTextBtn setTitle:@"松开 结束" forState:UIControlStateHighlighted];
        [_mTextBtn addTarget:self action:@selector(beginRecordVoice:) forControlEvents:UIControlEventTouchDown];
        
        [_mTextBtn addTarget:self action:@selector(endRecordVoice:) forControlEvents:UIControlEventTouchUpInside];
        
        [_mTextBtn addTarget:self action:@selector(cancelRecordVoice:) forControlEvents:UIControlEventTouchUpOutside | UIControlEventTouchCancel];
        [_mTextBtn addTarget:self action:@selector(RemindDragExit:) forControlEvents:UIControlEventTouchDragExit];
        [_mTextBtn addTarget:self action:@selector(RemindDragEnter:) forControlEvents:UIControlEventTouchDragEnter];
        
        // 输入框
        _mTextView = [[UITextView alloc]init];
        _mTextView.frame = _mTextBtn.bounds;
        _mTextView.textContainerInset = UIEdgeInsetsMake(7.5, 5, 5, 5);
        _mTextView.delegate = self;
        [_mTextBtn addSubview:_mTextView];
        _mTextView.backgroundColor = [UIColor whiteColor];
        _mTextView.returnKeyType = UIReturnKeySend;
        _mTextView.font = [UIFont systemFontOfSize:15];
        _mTextView.showsHorizontalScrollIndicator = NO;
        _mTextView.showsVerticalScrollIndicator = NO;
        _mTextView.enablesReturnKeyAutomatically = YES;
        _mTextView.scrollEnabled = NO;
        
        //键盘显示 回收的监听
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChange:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChange:) name:UIKeyboardWillHideNotification object:nil];
        
    }
    return self;
}

//键盘显示监听事件
- (void)keyboardWillChange:(NSNotification *)noti{
    
    _changeTime  = [[noti userInfo][UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGFloat height = [[[noti userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    
    if(noti.name == UIKeyboardWillHideNotification){
        height = SafeAreaBottom_Height;
        if(_keyBoardStatus == HuKeyBoardStatusSymbol ||
           _keyBoardStatus == HuKeyBoardStatusAdd){
            height = SafeAreaBottom_Height+SSChatKeyBordHeight;
        }
    }else{
        
        self.keyBoardStatus = HuKeyBoardStatusEdit;
        self.currentBtn.selected = NO;
        
        if(height==SafeAreaBottom_Height || height==0) height = _keyBoardHieght;
    }
    
    self.keyBoardHieght = height;
}

//弹起的高度
-(void)setKeyBoardHieght:(CGFloat)keyBoardHieght{
    
    if(keyBoardHieght == _keyBoardHieght)return;
    
    _keyBoardHieght = keyBoardHieght;
    [self setNewSizeWithController];
    
    [UIView animateWithDuration:_changeTime animations:^{
        if(self.keyBoardStatus == HuKeyBoardStatusDefault ||
           self.keyBoardStatus == HuKeyBoardStatusVoice){
            self.bottom = SCREEN_Height-SafeAreaBottom_Height;
        }else{
            self.bottom = SCREEN_Height-self.keyBoardHieght;
        }
    } completion:nil];
    
}

//设置默认状态
-(void)setKeyBoardStatus:(HuKeyBoardStatus)keyBoardStatus{
    _keyBoardStatus = keyBoardStatus;
    
    if(_keyBoardStatus == HuKeyBoardStatusDefault){
        self.currentBtn.selected = NO;
        self.mTextView.hidden = NO;
    }
}

//视图归位 设置默认状态 设置弹起的高度
-(void)SetHuKeyBoardGroundViewEndEditing{
    if(self.keyBoardStatus != HuKeyBoardStatusVoice){
        self.keyBoardStatus = HuKeyBoardStatusDefault;
        [self endEditing:YES];
        self.keyBoardHieght = 0.0;
    }
}

//语音 10  表情 11  相册 12
-(void)btnPressed:(UIButton *)sender{
    //第一版,不需要录音
    if (sender.tag == 12) {
        
        [self.mTextView resignFirstResponder];
        //图库
        if (self.huKeyBoardGroundViewDelegate && [self.huKeyBoardGroundViewDelegate respondsToSelector:@selector(HuKeyBoardGroundViewAddBtnClick)]) {
            [self.huKeyBoardGroundViewDelegate HuKeyBoardGroundViewAddBtnClick];
        }
    }else if (sender.tag == 10){
        //语音
    }else{
        //没有表情
    }
}

//设置所有控件新的尺寸位置
-(void)setNewSizeWithBootm:(CGFloat)height{
    
    [self setNewSizeWithController];
    
    [UIView animateWithDuration:0.25 animations:^{
        self.mTextView.height = height;
        self.height = 8 + 8 + self.mTextView.height;
        
        self.mTextBtn.height = self.mTextView.height;
        self.mTextBtn.bottom = self.height-SSChatTBottomDistence;
        self.mTextView.top = 0;
        self.mLeftBtn.bottom = self.height-SSChatBBottomDistence;
        self.mAddBtn.bottom = self.height-SSChatBBottomDistence;
        
        if(self.keyBoardStatus == HuKeyBoardStatusDefault ||
           self.keyBoardStatus == HuKeyBoardStatusVoice){
            self.bottom = SCREEN_Height-SafeAreaBottom_Height;
        }else{
            self.bottom = SCREEN_Height-self.keyBoardHieght;
        }
        
    } completion:^(BOOL finished) {
        [self.mTextView.superview layoutIfNeeded];
    }];
}

//设置键盘和表单位置
-(void)setNewSizeWithController{
    
    CGFloat changeTextViewH = fabs(_textH - SSChatTextHeight);
    if(self.mTextView.hidden == YES) changeTextViewH = 0;
    CGFloat changeH = _keyBoardHieght + changeTextViewH;
    
    HuDeviceDefault *device = [HuDeviceDefault shareHuDeviceDefault];
    if(device.safeAreaBottomHeight!=0 && _keyBoardHieght!=0){
        changeH -= SafeAreaBottom_Height;
    }
    
    if(self.huKeyBoardGroundViewDelegate && [self.huKeyBoardGroundViewDelegate respondsToSelector:@selector(HuKeyBoardGroundViewHeight:changeTime:)]){
        [self.huKeyBoardGroundViewDelegate HuKeyBoardGroundViewHeight:changeH changeTime:_changeTime];
    }
}

//拦截发送按钮
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    if(text.length==0){
        [self textViewDidChange:self.mTextView];
        return YES;
    }
    
    if ([text isEqualToString:@"\n"]) {
        [self startSendMessage];
        return NO;
    }
    
    return YES;
}

//开始发送消息
-(void)startSendMessage{
    NSString *message = [_mTextView.attributedText string];
    NSString *newMessage = [message stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if(message.length==0){
        
    }else if(self.huKeyBoardGroundViewDelegate && [self.huKeyBoardGroundViewDelegate respondsToSelector:@selector(HuKeyBoardGroundViewSendTextBtnClick:)]){
        [self.huKeyBoardGroundViewDelegate HuKeyBoardGroundViewSendTextBtnClick:newMessage];
    }
    
    _mTextView.text = @"";
    _textString = _mTextView.text;
    _mTextView.contentSize = CGSizeMake(_mTextView.contentSize.width, 30);
    [_mTextView setContentOffset:CGPointZero animated:YES];
    [_mTextView scrollRangeToVisible:_mTextView.selectedRange];
    
    _textH = SSChatTextHeight;
    [self setNewSizeWithBootm:_textH];
}


//监听输入框的操作 输入框高度动态变化
- (void)textViewDidChange:(UITextView *)textView{
    
    _textString = textView.text;
    
    NSString *message = [_textString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if(message.length==0 || message==nil){
    }else{
    }
    
    
    //获取到textView的最佳高度
    NSInteger height = ceilf([textView sizeThatFits:CGSizeMake(textView.width, MAXFLOAT)].height);
    
    if(height>SSChatTextMaxHeight){
        height = SSChatTextMaxHeight;
        textView.scrollEnabled = YES;
    }
    else if(height<SSChatTextHeight){
        height = SSChatTextHeight;
        textView.scrollEnabled = NO;
    }
    else{
        textView.scrollEnabled = NO;
    }
    
    if(_textH != height){
        _textH = height;
        [self setNewSizeWithBootm:height];
    }
    else{
        [textView scrollRangeToVisible:NSMakeRange(textView.text.length, 2)];
    }
}

#pragma 录音
- (void)beginRecordVoice:(UIButton *)button{
    
}

//录音结束
- (void)endRecordVoice:(UIButton *)button{
    
}

//取消录音
- (void)cancelRecordVoice:(UIButton *)button{
    
}

- (void)RemindDragExit:(UIButton *)button{
    
}

- (void)RemindDragEnter:(UIButton *)button{
    
}

@end
