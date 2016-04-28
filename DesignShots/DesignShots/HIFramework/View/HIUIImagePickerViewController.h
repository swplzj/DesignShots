//
//  HIUIImagePickerViewController.h
//  HIFramework
//
//  Created by lizhenjie on 4/9/15.
//  Copyright (c) 2015 swplzj. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HIUIImagePickerViewController;

typedef NS_ENUM(NSInteger, HIImagePickerType) {
    HIImagePickerTypePhotoLibrary,
    HIImagePickerTypeCamera
};

typedef void (^HIImagePickerFinishedBlock)( HIUIImagePickerViewController * req ,NSDictionary * imageInfo);

#pragma mark -

@protocol HIUIImagePickerViewControllerDelegate <NSObject>

@optional

-(void) imagePickerDidFinishedWithImageInfo:(NSDictionary *)imageInfo picker:(HIUIImagePickerViewController *)picker;

@end

#pragma mark -

@interface HIUIImagePickerViewController : UIImagePickerController

@property (nonatomic, assign) id<HIUIImagePickerViewControllerDelegate> pickerDelegate;

@property (nonatomic, assign) HIImagePickerType pickerType;

@property (nonatomic, copy) HIImagePickerFinishedBlock imagePickFinishedBlock;

@end

