//
//  UIApplication+HIPresentViewController.m
//  HIFramework
//
//  Created by lizhenjie on 4/9/15.
//  Copyright (c) 2015 swplzj. All rights reserved.
//

#import "UIApplication+HIPresentViewController.h"
#import "HIPrecompile.h"

static NSMutableDictionary * allPersentViewController = nil;

@implementation UIApplication (HIPresentViewController)

-(NSMutableDictionary *) shareAllPersentViewController
{
    if (!allPersentViewController) {
        allPersentViewController = [[NSMutableDictionary alloc] init];
    }
    
    return allPersentViewController;
}

-(BOOL) presentViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.keyWindow.rootViewController) {
        
        NSMutableDictionary * dic = [self shareAllPersentViewController];
        
        if ([dic objectForKey:[NSString stringWithFormat:@"%p", viewController]]) {
            
            ERROR(@"UIApplication+HIPersentViewController happened an error : %@ already persented.",[viewController class]);
            return NO;
        }
        
        [dic setObject:viewController forKey:[NSString stringWithFormat:@"%p", viewController]];
        
        // Begain add view and animate
        
        UIView * view = viewController.view;
        
        if (!animated) {
            
            [viewController viewWillAppear:NO];
            
            [self.keyWindow.rootViewController.view addSubview:view];
            
            [viewController viewDidAppear:NO];
            
            
        } else {
            
            [viewController viewWillAppear:YES];
            
            float x = view.frame.origin.x;
            float y = view.frame.origin.y;
            
            view.frame = CGRectMake(x, self.keyWindow.frame.size.height, view.frame.size.width, view.frame.size.height);
            
            [self.keyWindow.rootViewController.view addSubview:view];
            
            [UIView animateWithDuration:0.5 animations:^{
                view.frame = CGRectMake(x, y, view.frame.size.width, view.frame.size.height);
            } completion:^(BOOL finished) {
                [viewController viewDidAppear:YES];

            }];
        }

        return YES;
    }
    
    ERROR(@"UIApplication+HIPersentViewController happened an error : %@ no have a keyWindow.",[self class]);
    return NO;
}

-(BOOL) dismissModalViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    UIViewController * find = [[self shareAllPersentViewController] objectForKey:[NSString stringWithFormat:@"%p", viewController]];
    
    if (find) {
        
        UIView * view = viewController.view;
        
        if (!animated) {
            
            [viewController viewWillDisappear:NO];
            [viewController viewDidDisappear:NO];
            
            [view removeFromSuperview];
            
        }else{
            
            [viewController viewWillDisappear:YES];
            
            [UIView animateWithDuration:0.5 animations:^{
                viewController.view.frame = CGRectMake(viewController.view.frame.origin.x, self.keyWindow.frame.size.height, view.frame.size.width, view.frame.size.height);
            } completion:^(BOOL finished) {
                [viewController viewWillDisappear:YES];
                [view removeFromSuperview];
            }];
        }
        
        [[self shareAllPersentViewController] removeObjectForKey:[NSString stringWithFormat:@"%p", viewController]];
        
        return YES;
    }
    
    ERROR(@"UIApplication+HIPersentViewController happened an error : %@ will dismiss viewcontroller not found.",[viewController class]);
    
    return NO;
}

@end