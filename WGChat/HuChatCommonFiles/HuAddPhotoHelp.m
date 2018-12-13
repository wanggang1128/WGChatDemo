//
//  HuAddPhotoHelp.m
//  WGChat
//
//  Created by wanggang on 2018/12/13.
//  Copyright © 2018 WG. All rights reserved.
//

#import "HuAddPhotoHelp.h"

@implementation HuAddPhotoHelp

static HuAddPhotoHelp *instance = nil;
+ (instancetype)huAddPhotoShare{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[HuAddPhotoHelp alloc] init];
    });
    return instance;
}

-(void)pickerWithController:(UIViewController *)controller pickerBlock:(HuAddImagePicekerBlock)pickerBlock{
    
    [self pickerWithController:controller wayStyle:HuImagePickerWayGallery modelType:HuImagePickerModelImage pickerBlock:^(HuImagePickerWayStyle wayStyle, HuImagePickerModelType modelType, id object) {
        
        if (pickerBlock) {
            pickerBlock(wayStyle, modelType, object);
        }
    }];
}

-(void)pickerWithController:(UIViewController *)controller wayStyle:(HuImagePickerWayStyle)wayStyle modelType:(HuImagePickerModelType)modelType pickerBlock:(HuAddImagePicekerBlock)pickerBlock{
    
    _controller = controller;
    _pickerBlock = pickerBlock;
    _wayStyle = wayStyle;
    _modelType = modelType;
    
    [self addImagePickerSource];
}

- (void)addImagePickerSource{
    
    if(![self isPhotoLibraryAvailable]){
        NSLog(@"相册不可用");
        return;
    }
    
    _imagePickerController = [[UIImagePickerController alloc] init];
    _imagePickerController.delegate = self;
    _imagePickerController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    _imagePickerController.allowsEditing = NO;
    
    if(_wayStyle == HuImagePickerWayFormIpc){
        //访问相册
        _imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }else{
        //访问图库
        _imagePickerController.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    }
    
    if(_modelType == HuImagePickerModelImage){
        //只有图片
        _imagePickerController.mediaTypes = [NSArray arrayWithObjects:@"public.image", nil ,nil];
        
    }else if(_modelType == HuImagePickerModelVideo){
        //只有视频
        _imagePickerController.mediaTypes = [NSArray arrayWithObjects:@"public.movie", nil ,nil];
    }else{
        //图片和视频
        _imagePickerController.mediaTypes = [NSArray arrayWithObjects:@"public.image", @"public.movie",nil];
    }
    _imagePickerController.modalPresentationStyle = UIModalPresentationOverFullScreen;
    [_controller presentViewController:_imagePickerController animated:YES completion:nil];
}

#pragma  mark UIImagePickerControllerDelegate协议的方法
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    
    //获取到图片 判断是否裁剪
    if ([mediaType isEqualToString:( NSString *)kUTTypeImage]){
        _modelType = HuImagePickerModelImage;
        
        if(_imagePickerController.editing == YES){
            [self saveImageAndUpdataHeader:[info objectForKey:UIImagePickerControllerEditedImage]];
        }else{
            [self saveImageAndUpdataHeader:[info objectForKey:UIImagePickerControllerOriginalImage]];
        }
        
    }
    
    //获取到视频
    else if ([mediaType isEqualToString:(NSString *)kUTTypeMovie]){
        _modelType = HuImagePickerModelVideo;
        NSURL *url=[info objectForKey:UIImagePickerControllerMediaURL];
        NSString *urlPath=[url path];
        
        //保存视频到相簿，注意也可以使用ALAssetsLibrary来保存
        if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(urlPath)) {
            if(_modelType != HuImagePickerWayFormIpc && _modelType != HuImagePickerWayGallery){
                UISaveVideoAtPathToSavedPhotosAlbum(urlPath,self,@selector(video:didFinishSavingWithError:contextInfo:),nil);
            }else{
                if(_pickerBlock){
                    _pickerBlock(_wayStyle,_modelType,urlPath);
                }else{
                    _pickerBlock = nil;
                }
            }
        }
        
    }
    
    [picker  dismissViewControllerAnimated:YES completion:nil];
}

//保存视频
- (void)video:(NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    if (error) {
        NSLog(@"保存视频过程中发生错误，错误信息:%@",error.localizedDescription);
    }else{
        NSLog(@"视频保存成功.");
        if(_pickerBlock){
            _pickerBlock(_wayStyle,_modelType,videoPath);
        }else{
            _pickerBlock = nil;
        }
    }
}

//当用户取消时，调用该方法
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker  dismissViewControllerAnimated:YES completion:nil];
}

//拍照或者选取照片后的保存和刷新操作
-(void)saveImageAndUpdataHeader:(UIImage *)image{
    
    if(_pickerBlock){
        _pickerBlock(_wayStyle,_modelType,image);
    }else{
        _pickerBlock = nil;
    }
}

//相册是否可用
-(BOOL)isPhotoLibraryAvailable{
    return [UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypePhotoLibrary];
}

//判断设备是否有摄像头
-(BOOL)isCameraAvailable{
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}

// 前面的摄像头是否可用
-(BOOL)isFrontCameraAvailable{
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront];
}

// 后面的摄像头是否可用
-(BOOL)isRearCameraAvailable{
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
}

//是否可以在相册中选择视频
-(BOOL)canUserPickVideosFromPhotoLibrary{
    return [self cameraSupportsMedia:( NSString *)kUTTypeMovie sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}

//是否可以在相册中选择照片
-(BOOL)canUserPickPhotosFromPhotoLibrary{
    return [self cameraSupportsMedia:( NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}

// 判断是否支持某种多媒体类型：拍照，视频,
-(BOOL)cameraSupportsMedia:(NSString*)paramMediaType sourceType:(UIImagePickerControllerSourceType)paramSourceType{
    __block BOOL result=NO;
    if ([paramMediaType length]==0) {
        NSLog(@"Media type is empty.");
        return NO;
    }
    NSArray*availableMediaTypes=[UIImagePickerController availableMediaTypesForSourceType:paramSourceType];
    [availableMediaTypes enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *mediaType = (NSString *)obj;
        if ([mediaType isEqualToString:paramMediaType]){
            result = YES;
            *stop= YES;
        }
    }];
    return result;
}

//检查是否支持录像
-(BOOL)doesCameraSupportShootingVideos{
    /*在此处注意我们要将MobileCoreServices 框架添加到项目中，
     然后将其导入：#import <MobileCoreServices/MobileCoreServices.h> 。不然后出现错误使用未声明的标识符 'kUTTypeMovie'
     */
    return [self cameraSupportsMedia:( NSString *)kUTTypeMovie sourceType:UIImagePickerControllerSourceTypeCamera];
}

//检查摄像头是否支持拍照
-(BOOL)doesCameraSupportTakingPhotos{
    /*在此处注意我们要将MobileCoreServices 框架添加到项目中，
     然后将其导入：#import <MobileCoreServices/MobileCoreServices.h> 。不然后出现错误使用未声明的标识符 'kUTTypeImage'
     */
    
    return [self cameraSupportsMedia:( NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypeCamera];
}

@end
