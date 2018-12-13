//
//  HuSingleChatViewController.m
//  WGChat
//
//  Created by wanggang on 2018/12/10.
//  Copyright © 2018 WG. All rights reserved.
//

#import "HuSingleChatViewController.h"
#import "HuKeyBoardGroundView.h"
#import "HuChatGlobleDefine.h"
#import "HuDeviceDefault.h"
#import "HuDealChatMessageHelp.h"
#import "HuBaseChatTableViewCell.h"
#import "HuAddPhotoHelp.h"

@interface HuSingleChatViewController ()<HuKeyBoardGroundViewDelegate, UITableViewDelegate, UITableViewDataSource>

//下方输入框
@property (nonatomic, strong) HuKeyBoardGroundView *keyBoardView;

//聊天表
@property (nonatomic, strong) UITableView *tableView;
//消息数组
@property (nonatomic, strong) NSMutableArray *dataArray;

//视图原高度
@property (assign, nonatomic) CGFloat backViewH;

@end

@implementation HuSingleChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"单聊";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.keyBoardView];
    [self.view addSubview:self.tableView];
}

#pragma mark -UITableViewDelegate, UITableViewDataSource代理方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HuChatMessageLayout *layout = self.dataArray[indexPath.row];
    
    HuBaseChatTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:layout.message.cellString];
    cell.indexPath = indexPath;
    cell.layout = layout;
    return cell;
}

//视图归位
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.keyBoardView SetHuKeyBoardGroundViewEndEditing];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height = [(HuChatMessageLayout *)self.dataArray[indexPath.row] cellHeight];
    return height;
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.keyBoardView SetHuKeyBoardGroundViewEndEditing];
}

- (void)keyboardHide{
    [self.keyBoardView SetHuKeyBoardGroundViewEndEditing];
}

#pragma mark -HuKeyBoardGroundViewDelegate键盘代理方法
//点击按钮视图frame发生变化 调整当前列表frame
-(void)HuKeyBoardGroundViewHeight:(CGFloat)keyBoardHeight changeTime:(CGFloat)changeTime{
    
    CGFloat height = _backViewH - keyBoardHeight;
    [UIView animateWithDuration:changeTime animations:^{
        self.tableView.frame = CGRectMake(0, SafeAreaTop_Height, SCREEN_Width, height);
        if (self.dataArray.count >0) {
            NSIndexPath *indexPath = [NSIndexPath     indexPathForRow:self.dataArray.count-1 inSection:0];
            [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        }
    } completion:^(BOOL finished) {
        
    }];
}

//发送文本消息
-(void)HuKeyBoardGroundViewSendTextBtnClick:(NSString *)string{
    
    NSDictionary *dic = @{@"text":string};
    [self sendMessage:dic messageType:SSChatMessageTypeText];

}

//选择图片或者视频
-(void)HuKeyBoardGroundViewAddBtnClick{
    
    [[HuAddPhotoHelp huAddPhotoShare] pickerWithController:self wayStyle:HuImagePickerWayGallery modelType:HuImagePickerModelAll pickerBlock:^(HuImagePickerWayStyle wayStyle, HuImagePickerModelType modelType, id object) {
        
        if(modelType == HuImagePickerModelImage){
            UIImage *image = (UIImage *)object;
            NSLog(@"%@",image);
            NSDictionary *dic = @{@"image":image};
            [self sendMessage:dic messageType:SSChatMessageTypeImage];
            
        }else if(modelType == HuImagePickerModelVideo){
            NSString *localPath = (NSString *)object;
            NSLog(@"%@",localPath);
            NSDictionary *dic = @{@"videoLocalPath":localPath};
            [self sendMessage:dic messageType:SSChatMessageTypeVideo];
        }
        
    }];
}

- (void)sendMessage:(NSDictionary *)dic messageType:(SSChatMessageType)messageType{
    
    [HuDealChatMessageHelp sendMessage:dic sessionId:@"1" messageType:messageType messageBlock:^(HuChatMessageLayout * _Nonnull layout, NSError * _Nonnull error, NSProgress * _Nonnull progress) {
        
        [self.dataArray addObject:layout];
        [self.tableView reloadData];
        NSIndexPath *indexPath = [NSIndexPath     indexPathForRow:self.dataArray.count-1 inSection:0];
        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        
    }];
}

#pragma mark -懒加载
- (HuKeyBoardGroundView *)keyBoardView{
    if (!_keyBoardView) {
        _keyBoardView = [[HuKeyBoardGroundView alloc] init];
        _keyBoardView.huKeyBoardGroundViewDelegate = self;
    }
    return _keyBoardView;
}

-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}

-(UITableView *)tableView{
    if (!_tableView) {
        
        _backViewH = SCREEN_Height-SSChatKeyBoardInputViewH-SafeAreaTop_Height-SafeAreaBottom_Height;
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, SafeAreaTop_Height, SCREEN_Width, _backViewH) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor = HuChatCellColor;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _tableView.scrollIndicatorInsets = _tableView.contentInset;
        
        //点击空白键盘消失事件
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide)];
        tapGestureRecognizer.cancelsTouchesInView = NO;
        [_tableView addGestureRecognizer:tapGestureRecognizer];
        
        [_tableView registerClass:NSClassFromString(@"HuTextChatTableViewCell") forCellReuseIdentifier:SSChatTextCellId];
        [_tableView registerClass:NSClassFromString(@"HuImageChatTableViewCell") forCellReuseIdentifier:SSChatImageCellId];
        [_tableView registerClass:NSClassFromString(@"HuVedioChatTableViewCell") forCellReuseIdentifier:SSChatVideoCellId];
        [_tableView registerClass:NSClassFromString(@"HuVoiceChatTableViewCell") forCellReuseIdentifier:SSChatVoiceCellId];
        
        if (@available(iOS 11.0, *)){
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            _tableView.estimatedRowHeight = 0;
            _tableView.estimatedSectionHeaderHeight = 0;
            _tableView.estimatedSectionFooterHeight = 0;
        }
    }
    return _tableView;
}

@end
