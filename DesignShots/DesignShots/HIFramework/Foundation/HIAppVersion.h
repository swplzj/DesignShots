//
//  HIAppVersion.h
//  HIFramework
//
//  Created by lizhenjie on 4/2/15.
//  Copyright (c) 2015 swplzj. All rights reserved.
//

#import "HIPrecompile.h"

@class HIAppVersion;

typedef enum _HI_APPVERSION_ALERT_STYLE {
    
    HI_APPVERSION_ALERT_STYLE_ALERT = 0,
    HI_APPVERSION_ALERT_STYLE_NOTIFICATION,
    
} HI_APPVERSION_ALERT_STYLE;

typedef void (^HIAppVersionCheckFinishBlock)( HIAppVersion * appVersion );
typedef void (^HIAppVersionUpdateButtonClickBlock)( HIAppVersion * appVersion );

#pragma mark -

@interface HIAppVersion : NSObject


@property(nonatomic,retain) NSString * applicationVersion;
@property(nonatomic,retain) NSString * appStoreCountry;


// Action blocks
@property(nonatomic,copy) HIAppVersionCheckFinishBlock       checkFinishBlock;
@property(nonatomic,copy) HIAppVersionUpdateButtonClickBlock updateButtonClickBlock;


// Setting UI
@property(assign) BOOL autoPresentedUpdateAlert; //是否自动弹出升级提示框 default is YES
@property(assign) HI_APPVERSION_ALERT_STYLE alertStyle;
@property(nonatomic,copy) NSString * updateButtonTitle;
@property(nonatomic,copy) NSString * cancelButtonTitle;


@property(nonatomic,assign) BOOL hasNewVersion;


// If hasNewVersion is YES
@property(nonatomic,copy) NSString * theNewVersionNumber;
@property(nonatomic,copy) NSString * theNewVersionURL;
@property(nonatomic,copy) NSString * theNewVersionDetails;
@property(nonatomic,copy) NSString * theNewVersionIconURL;


+(void) checkForNewVersion;
-(void) checkForNewVersion;

@end