//
//  HIUIWebviewController.h
//  HIFramework
//
//  Created by lizhenjie on 4/9/15.
//  Copyright (c) 2015 swplzj. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    UMLogPageNameJieKuanXieYi = 0,
    UMLogPageNameXinYongFuWuXieYi,
    UMLogPageNameMianZeShengMing,
    UMLogPageNameXueXinWangZhangHaoZhuCe,
    UMLogPageNameXueXinWangWangJiMiMa,
    UMLogPageNameHuaKouShouQuanShu,
    UMLogPageNameChangeBankHuaKouShouQuanShu,
}UMLogPageName;

typedef enum _HI_UIWEBVIEW_STATE_BUTTON_TYPE{
    
    HI_UIWEBVIEW_STATE_BUTTON_TYPE_LOADING = 0,
    HI_UIWEBVIEW_STATE_BUTTON_TYPE_REFRESH
    
}HI_UIWEBVIEW_STATE_BUTTON_TYPE;

@interface HIUIWebviewController : UIViewController

@property (nonatomic, assign) UMLogPageName pageName;
@property (nonatomic, strong) UIWebView *  mainWebView;
@property (nonatomic, strong) NSURL * URL;
@property (nonatomic, assign) BOOL showDismissButton;
@property (nonatomic, copy) NSString *customTitle;  // 自定义title

- (id)initWithAddress:(NSString *) urlString;
- (id)initWithURL:(NSURL *) pageURL;

- (void)setHtml:(NSString *)string;
- (void)setFile:(NSString *)path;
- (void)setResource:(NSString *)path;

@end
