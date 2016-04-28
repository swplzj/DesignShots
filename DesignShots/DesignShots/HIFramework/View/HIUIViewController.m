//
//  HIUIViewController.m
//  HIFramework
//
//  Created by lizhenjie on 4/7/15.
//  Copyright (c) 2015 swplzj. All rights reserved.
//

#import "HIUIViewController.h"
#import "HIPrecompile.h"

@implementation HIUIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupContentView];
}

- (void)setupContentView
{
//    if (IOS7_OR_LATER && !self.navigationController) {
//        self.contentView = [[UIView alloc] initWithFrame:HI_RECT_CREATE(0, 20, self.view.frame.size.width, self.view.frame.size.height-20)];
//    } else {
//        self.contentView = [[UIView alloc] initWithFrame:HI_RECT_CREATE(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
//    }
//    
//    _contentView.backgroundColor = [UIColor clearColor];
//    [self.view addSubview:_contentView];
//
    // add back button item
    
    [self showBarButton:NavigationBarButtonTypeLeft
                  title:@""
                  image:[UIImage imageNamed:@"home_arrow_left"]
            selectImage:nil];

    
    // add color line
//    UIImageView *colorLine = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"common_color_line"]];
//    [self.view addSubview:colorLine];
//    [colorLine setTranslatesAutoresizingMaskIntoConstraints:NO];
//    
//    NSDictionary *views = NSDictionaryOfVariableBindings(colorLine);
//    NSMutableArray *constraints = @[].mutableCopy;
//    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[colorLine]-0-|" options:0 metrics:nil views:views]];
//    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[colorLine(==4)]-0-|" options:0 metrics:nil views:views]];
//    [self.view addConstraints:constraints];
//    [self.view setNeedsUpdateConstraints];
}

@end
