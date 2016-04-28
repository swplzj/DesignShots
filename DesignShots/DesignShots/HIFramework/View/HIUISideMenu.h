//
//  HIUISideMenu.h
//  HIFramework
//
//  Created by lizhenjie on 4/9/15.
//  Copyright (c) 2015 swplzj. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HIUISideMenu;
@class HIUISideMenuItem;

typedef void (^HIUISideItemActionBlock)( HIUISideMenu * menu, HIUISideMenuItem * item );

#pragma mark -


@interface HIUISideMenuItem : NSObject

@property (copy, readwrite, nonatomic) NSString * title;
@property (strong, readwrite, nonatomic) UIImage *  image;
@property (strong, readwrite, nonatomic) UIImage *  highlightedImage;
@property (copy, readwrite, nonatomic) HIUISideItemActionBlock action;

- (id)initWithTitle:(NSString *)title action:(HIUISideItemActionBlock) action;

@end


#pragma mark -


@interface HIUISideMenu : UIView

@property (strong, nonatomic)  NSArray * items;
@property (assign, nonatomic) CGFloat  verticalOffset;
@property (assign, nonatomic) CGFloat  horizontalOffset;
@property (assign, nonatomic) CGFloat  itemHeight;
@property (strong, nonatomic) UIFont  * font;
@property (strong, nonatomic) UIColor * textColor;
@property (strong, nonatomic) UIColor * highlightedTextColor;
@property (assign, readwrite, nonatomic) BOOL isShowing;
@property(nonatomic,strong) UITableView     *tableView;
@property (strong, readwrite, nonatomic) UIView *headerView;

- (id)initWithItems:(NSArray *)items;

- (void)show;
- (void)hide;
//- (void)setRootViewController:(UIViewController *)viewController;

@end
