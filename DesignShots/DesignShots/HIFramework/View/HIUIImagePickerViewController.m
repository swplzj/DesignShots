//
//  HIUIImagePickerViewController.m
//  HIFramework
//
//  Created by lizhenjie on 4/9/15.
//  Copyright (c) 2015 swplzj. All rights reserved.
//

#import "HIUIImagePickerViewController.h"
#import "HIPrecompile.h"
#import <AVFoundation/AVFoundation.h>

@interface HIUIImagePickerViewController () <UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@end

@implementation HIUIImagePickerViewController

-(void) dealloc
{
    self.imagePickFinishedBlock = nil;
}

-(id) init
{
    if(self = [super init]) {
        self.delegate = self;
        self.allowsEditing = YES;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    if (IOS7_OR_LATER) {
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:^(BOOL granted) {
            if (!granted) {
                [HIUIAlertView showAlertWithTitle:@"温馨提示" message:@"相机使用权限未开启，请在手机设置中开启权限（设置-隐私-相机）" cancelTitle:@"我知道了" completion:nil];
            }
        }];
    }
}

-(void) setPickerType:(HIImagePickerType)pickerType
{
    switch (pickerType) {
        case HIImagePickerTypePhotoLibrary:
            
            if ([[self class] isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
                
                self.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            }
            
            break;
        case HIImagePickerTypeCamera:
#if (TARGET_IPHONE_SIMULATOR)
            
#else
            if ([[self class] isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
                
                self.sourceType = UIImagePickerControllerSourceTypeCamera;
            }
#endif
            break;
        default:
            break;
    }
    
    _pickerType = pickerType;
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    NSMutableDictionary * dict= [NSMutableDictionary dictionaryWithDictionary:editingInfo];
    [dict setObject:image forKey:@"UIImagePickerControllerEditedImage"];
    [self imagePickerController:self didFinishPickingMediaWithInfo:dict];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    INFO(@"[HIUIImagePickerViewController] Image info = %@",info);
    
    [self dismissViewControllerAnimated:YES completion:^{
        
        if (_pickerDelegate) {
            [_pickerDelegate imagePickerDidFinishedWithImageInfo:info picker:self];
        }
        
        if (self.imagePickFinishedBlock) {
            self.imagePickFinishedBlock(self,info);
        }
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    if (![self.navigationController popViewControllerAnimated:YES]) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

@end
