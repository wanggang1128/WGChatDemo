//
//  HuChatListViewController.m
//  WGChat
//
//  Created by wanggang on 2018/12/10.
//  Copyright © 2018 WG. All rights reserved.
//

#import "HuChatListViewController.h"
#import "HuSingleChatViewController.h"

@interface HuChatListViewController ()

@end

@implementation HuChatListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"聊天列表";
    self.view.backgroundColor = [UIColor whiteColor];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    HuSingleChatViewController *vc = [[HuSingleChatViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}


@end
