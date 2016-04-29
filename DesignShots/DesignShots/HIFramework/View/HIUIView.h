//
//  HIUIView.h
//  HIFramework
//
//  Created by lizhenjie on 4/3/15.
//  Copyright (c) 2015 swplzj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HIUIActivityIndicatorView.h"


// import
#import "HIUIButton.h"
#import "HIUICheckbox.h"
#import "HIUINavigationController.h"
#import "HIUIViewController.h"
#import "HIUIActivityIndicatorView.h"
#import "HIUIHud.h"
#import "HIUIAlertView.h"
#import "HIUINavigationNotificationView.h"


#import "HIUIPullLoader.h"
#import "HIUIActionSheet.h"
#import "HIUIWebViewController.h"
#import "HIUIBadgeView.h"
#import "HIUITextView.h"
#import "HIUIGraphView.h"
#import "HIUITabBar.h"
#import "HIUITabBarController.h"
#import "HIUISideMenu.h"
#import "HIUIImagePickerViewController.h"
#import "HIUITopNotificationView.h"
#import "HIUISearchBar.h"
#import "HIUITapMaskView.h"
#import "HIUIBlurView.h"
#import "HIUIPropertyPicker.h"
#import "HIUITextField.h"
#import "HIUIKeyBoard.h"
#import "HIKeyboardAvoidingTableView.h"
#import "HIKeyboardAvoidingScrollView.h"

#import "UIScrollView+HIKeyboardAvoidingAdditions.h"
#import "UIViewController+HIUINavigationBar.h"
#import "UIViewController+HITabBar.h"
#import "UIViewController+HITitle.h"
#import "UIViewController+HILayout.h"
#import "UIImage+HIExtension.h"
#import "UIColor+HIExtension.h"
#import "NSObject+HIHud.h"
#import "UIView+HIExtension.h"
#import "UIView+HIBackground.h"
#import "UIView+HITag.h"
#import "UIView+HIGesture.h"
#import "UIView+HIScreenShot.h"
#import "UINavigationController+HIExtension.h"
#import "UIApplication+HIPresentViewController.h"
#import "UITextField+HIToolbarOnKeyboard.h"

// Application default config
#define HI_UINAVIGATIONBAR_DEFAULT_TITLE_COLOR        [UIColor whiteColor]
#define HI_UINAVIGATIONBAR_DEFAULT_TITLE_SHADOW_COLOR HI_RGBA(0, 0, 0, 0)
#define HI_UINAVIGATIONBAR_DEFAULT_IMAGE_IOS7_BEFORE  nil//[UIImage imageNamed:@"HInavbar_bg.png" useCache:YES]
#define HI_UINAVIGATIONBAR_DEFAULT_IMAGE_IOS7_LATER   nil//[UIImage imageNamed:@"HIios7_navbar_bg.png" useCache:YES]

#define HI_UINAVIGATION_BAR_DEFAULT_BUTTON_TITLE_COLOR        [UIColor darkGrayColor]

#define HI_UIPULLLOADER_DEFAULT_HEIGHT (45.f)

#define HI_TABLE_DEFAULT_STYLE            (UITableViewStyleGrouped)
#define HI_TABLE_DEFAULT_BACKGROUND_COLOR ([UIColor whiteColor])


@interface HIUIView : UIView



@end
