//
//  HIUIWebviewController.m
//  HIFramework
//
//  Created by lizhenjie on 4/9/15.
//  Copyright (c) 2015 swplzj. All rights reserved.
//

#import "HIUIWebviewController.h"
#import "HIPrecompile.h"

#pragma mark -

@interface HIUIWebviewController () <UIWebViewDelegate,UIActionSheetDelegate, HIUIActionSheetDelegate>

@property (nonatomic, strong) HIUIHud *hud;
@property (nonatomic, copy)     NSString *logPageName;
@end

#pragma mark -

@implementation HIUIWebviewController

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
//    [self.navigationController setToolbarHidden:NO animated:animated];
}

-(void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    //    [self.navigationController setToolbarHidden:YES animated:animated];
}

- (id)initWithAddress:(NSString *)urlString
{
    return [self initWithURL:[NSURL URLWithString:urlString]];
}

- (id)initWithURL:(NSURL*)pageURL
{
    if (self = [super init]) {
        self.URL = pageURL;
    }

    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    if (self.navigationController.viewControllers.count)
    {
        [self showBarButton:NavigationBarButtonTypeLeft
                      title:@""
                      image:[UIImage imageNamed:@"common_nav_back"]
                selectImage:nil];
    }
    
//    [self setupToolBar];
    
//    self.mainWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, IOS7_OR_LATER ? 64 : 44, self.view.frame.size.width, self.view.frame.size.height - 44)];
    self.mainWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, SCREEN_WIDTH)];

    self.mainWebView.delegate = self;
    self.mainWebView.scalesPageToFit = YES;
    
    if (self.URL) {
        [self.mainWebView performSelector:@selector(loadRequest:) withObject:[NSURLRequest requestWithURL:self.URL] afterDelay:0];
    }
    
    if (!IOS7_OR_LATER) {
        
        [self.view addSubview:self.mainWebView];
    } else{
        self.view = self.mainWebView;
    }
    if (self.customTitle) {
        self.title = self.customTitle;
    }
}

-(void) setShowDismissButton:(BOOL)showDismissButton
{
    if (showDismissButton) {
        [self showBarButton:NavigationBarButtonTypeLeft
                      title:@""
                      image:[UIImage imageNamed:@"navbar_btn_back.png"]
                selectImage:[UIImage imageNamed:@"navbar_btn_back_pressed.png"]];
    } else {
        self.navigationItem.leftBarButtonItem = nil;
    }
}

-(void) setupToolBar
{
    UIBarButtonItem * backItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"HI_WebBack.png"]
                                                                  style:UIBarButtonItemStylePlain
                                                                 target:self
                                                                 action:@selector(goBackClicked)];
    
    UIBarButtonItem * forwardItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"HI_WebForward.png"]
                                                                     style:UIBarButtonItemStylePlain
                                                                    target:self
                                                                    action:@selector(goForwardClicked)];
    
    UIBarButtonItem * actionItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction
                                                                                 target:self
                                                                                 action:@selector(actionButtonClicked)];
    
    UIBarButtonItem * flexItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    NSArray * items = @[flexItem,backItem,flexItem,forwardItem,flexItem,actionItem,flexItem];
    self.toolbarItems = items;
    
    [self.navigationController setToolbarHidden:NO animated:YES];
    
    [self setLoadingState:HI_UIWEBVIEW_STATE_BUTTON_TYPE_REFRESH];
}

-(void) setLoadingState:(HI_UIWEBVIEW_STATE_BUTTON_TYPE)type
{
    switch (type) {
            
        case HI_UIWEBVIEW_STATE_BUTTON_TYPE_LOADING:
        {
            HIUIActivityIndicatorView * activity = [HIUIActivityIndicatorView grayActivityIndicatorView];
            [activity startAnimating];
            
            [self showBarButton:NavigationBarButtonTypeRight custom:activity];
        }
            break;
            
        case HI_UIWEBVIEW_STATE_BUTTON_TYPE_REFRESH:
        {
            UIImageView * refreshImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"crop_rotate.png"]];
            refreshImage.userInteractionEnabled = YES;
            
            UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(refreshWebView)];
            [refreshImage addGestureRecognizer:tap];

            
            UIBarButtonItem * item = [[UIBarButtonItem alloc] initWithCustomView:refreshImage];
            
            self.navigationItem.rightBarButtonItem = item;
        }
            break;
            
        default:
            break;
    }
}

-(void) navigationBarButtonClick:(NavigationBarButtonType)type
{
    if (type == NavigationBarButtonTypeLeft) {
        if(![self.navigationController popViewControllerAnimated:YES]){
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }
}

#pragma mark -

-(void) goBackClicked
{
    [_mainWebView goBack];
    
}

-(void) goForwardClicked
{
    [_mainWebView goForward];
}

-(void) actionButtonClicked
{
    HIUIActionSheet * actionSheet = [[HIUIActionSheet alloc] initWithTitle:@"更多" delegate:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拷贝链接",@"在Safari中打开",nil];
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [actionSheet showInView:keyWindow];
    actionSheet.delegate = self;
}

#pragma mark - HIUIAcitonSheet Delegate

- (void)actionSheet:(HIUIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        [pasteboard setString:[self.mainWebView.request.URL absoluteString]];
        
    } else if (buttonIndex == 1){
        [[UIApplication sharedApplication] openURL:self.mainWebView.request.URL];
    }
}

#pragma mark - 

-(void) refreshWebView
{
    if (self.mainWebView.request.URL) {
        [self setURL:self.mainWebView.request.URL];
    }
}

- (void)setHtml:(NSString *)string
{
    [_mainWebView loadHTMLString:string baseURL:nil];
}

- (void)setFile:(NSString *)path
{
    NSData * data = [NSData dataWithContentsOfFile:path];
    
    if ( data ) {
        
        [_mainWebView loadData:data MIMEType:@"text/html" textEncodingName:@"UTF8" baseURL: [NSURL URLWithString:@""]];
    }
}

- (void)setResource:(NSString *)path
{
    NSString * extension = [path pathExtension];
    NSString * fullName = [path substringToIndex:(path.length - extension.length - 1)];
    
    NSString * path2 = [[NSBundle mainBundle] pathForResource:fullName ofType:extension];
    NSData * data = [NSData dataWithContentsOfFile:path2];
    
    if ( data ) {
        [_mainWebView loadData:data MIMEType:@"text/html" textEncodingName:@"UTF8" baseURL:[NSURL URLWithString:@""]];
    }
}

- (void)setURL:(NSURL *)URL
{
    if ( nil == URL )
        return;
    
    
    NSString * obsolute = URL.absoluteString;
    
    if ([obsolute rangeOfString:@"://"].length) {

    } else {
        URL = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@", obsolute]];
    }
    
    _URL = URL;
    
    NSArray * cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
    
    for ( NSHTTPCookie * cookie in cookies ){
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
    }
	  
    NSURLRequest *request =[NSURLRequest requestWithURL:URL cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:60];
    [_mainWebView loadRequest:request];
}

#pragma mark -

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSURL *url = [request URL];
    NSLog(@"url = %@", url);
//    NSString *urlString = [url absoluteString];
    
    //self.hud = [self showLoadingHud:TEXT_NET_LOADING];
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [self setLoadingState:HI_UIWEBVIEW_STATE_BUTTON_TYPE_LOADING];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
   // [self.hud hide];
    [self setLoadingState:HI_UIWEBVIEW_STATE_BUTTON_TYPE_REFRESH];
    if (self.customTitle.length) {
        self.title = self.customTitle;
    } else {
        self.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
   // [self.hud hide];
    [self setLoadingState:HI_UIWEBVIEW_STATE_BUTTON_TYPE_REFRESH];
}

@end
