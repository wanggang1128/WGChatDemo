//
//  HuAddPhotoHelp.h
//  WGChat
//
//  Created by wanggang on 2018/12/13.
//  Copyright © 2018 WG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <MobileCoreServices/MobileCoreServices.h>


//通过UIAlertController 来确定获取方式的时候需要传入键值对
//一下为键值对的key值 目前只提供三种 (相册 图库 摄像头)
//第一版本不需要摄像头,默认从图库选择资源
#define HuPickerWayFormIpc   @"HuPickerWayFormIpc"
#define HuPickerWayGallery   @"HuPickerWayGallery"
#define HuPickerWayCamer     @"HuPickerWayCamer"


/**
 访问方式
  - HuImagePickerWayFormIpc: 访问相册
 - HuImagePickerWayGallery: 访问图库
 - HuImagePickerWayCamer: 访问摄像头
 
 */
typedef NS_ENUM(NSInteger,HuImagePickerWayStyle) {
    HuImagePickerWayFormIpc=1,
    HuImagePickerWayGallery,
    HuImagePickerWayCamer,
};

/**
 获取资源类型
 
 - SSImagePickerModelImage: 获取图片
 - SSImagePickerModelVideo: 获取视频
 - SSImagePickerModelAll: 图片和视频
 */
typedef NS_ENUM(NSInteger,HuImagePickerModelType) {
    HuImagePickerModelImage=1,
    HuImagePickerModelVideo,
    HuImagePickerModelAll,
};

/**
 获取资源后的回调代码块
 
 @param wayStyle 获取资源的方式
 @param modelType 获取到的资源类型（图片 视频）
 @param object 返回的资源数据 图片直接返回UIImage对象 视频返回本地视频链接
 */
typedef void (^HuAddImagePicekerBlock)(HuImagePickerWayStyle wayStyle,HuImagePickerModelType modelType,id object);

NS_ASSUME_NONNULL_BEGIN

@interface HuAddPhotoHelp : NSObject<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

//访问方式
@property(nonatomic,assign) HuImagePickerWayStyle wayStyle;
//获取资源类型
@property(nonatomic,assign) HuImagePickerModelType modelType;
//传入的控制器
@property(nonatomic,strong) UIViewController *controller;
//图片视频控制器核心对象
@property(nonatomic,strong) UIImagePickerController *imagePickerController;
//获取资源后的回调代码块
@property(nonatomic,copy) HuAddImagePicekerBlock pickerBlock;


+ (instancetype)huAddPhotoShare;

/**
 默认访问相册 获取图片
 
 @param controller 传入的控制器对象
 @param pickerBlock 资源回调代码块
 */
-(void)pickerWithController:(UIViewController *)controller pickerBlock:(HuAddImagePicekerBlock)pickerBlock;

/**
 通过相册和摄像头访问获取图片和视频资源
 
 @param controller 控制器对象
 @param wayStyle 访问方式
 @param modelType 资源类型
 @param pickerBlock 资源回调代码块
 */
-(void)pickerWithController:(UIViewController *)controller wayStyle:(HuImagePickerWayStyle)wayStyle modelType:(HuImagePickerModelType)modelType pickerBlock:(HuAddImagePicekerBlock)pickerBlock;

@end

NS_ASSUME_NONNULL_END
