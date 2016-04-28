//
//  HIUITabBarController.m
//  HIFramework
//
//  Created by lizhenjie on 4/9/15.
//  Copyright (c) 2015 swplzj. All rights reserved.
//

#import "HIUITabBarController.h"


@interface HIUITabBarController ()

@end

@implementation HIUITabBarController

-(void) dealloc
{
    [self.tabBar removeObserver:self forKeyPath:@"frame"];
    [self.tabBar removeObserver:self forKeyPath:@"selectedItem"];
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.bar.selectedIndex = self.selectedIndex;
    [self.tabBar bringSubviewToFront:self.bar];
    self.bar.frame = self.tabBar.bounds;
}

-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.tabBar bringSubviewToFront:self.bar];
    self.bar.frame = self.tabBar.bounds;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupBar];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) setupBar
{
    // init HIUITabBar.
    self.bar = [[HIUITabBar alloc] initWithTabBarItems:nil];
    self.bar.selectedIndex = self.selectedIndex;
    self.bar.backgroundColor = [UIColor blackColor];
    self.bar.frame = self.tabBar.frame;
    self.bar.userInteractionEnabled = YES;
    
    [self.tabBar addSubview:self.bar];
    [self.tabBar addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    [self.tabBar addObserver:self forKeyPath:@"selectedItem" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
}

- (CGRect) tabBarControllerSetItemFrame:(HIUITabBarItem *)item
{
    return item.frame;
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    if ([object isEqual:self.tabBar]) {
        
        self.bar.frame = self.tabBar.bounds;
        [self.tabBar bringSubviewToFront:self.bar];
        
    }
}

-(void) resetTabBarWithViewControllers:(NSArray *)viewControllers
{
    NSMutableArray * items = [NSMutableArray array];
    
    [viewControllers enumerateObjectsUsingBlock:^(UIViewController * obj, NSUInteger idx, BOOL *stop) {
        
        UITabBarItem * sysTabBarItem = obj.tabBarItem;
        
        HIUITabBarItem * item = [HIUITabBarItem tabBarItemWithImage:sysTabBarItem.image highlightedImage:sysTabBarItem.selectedImage];
        item.tag = idx;
        [item addTapTarget:self selector:@selector(itemClick:)];
        item.frame = [self tabBarControllerSetItemFrame:item];
        [items addObject:item];
        
    }];
    
    self.bar.items = items;
}

-(void) itemClick:(UITapGestureRecognizer *)tap
{
    for (NSString * indexString in self.cantChangeViewControllerIndexs) {
        if([indexString intValue] == tap.view.tag){
            [self handleTabBarItemClick:self.bar.items[tap.view.tag]];
            break;
        }
    }
    
    [self setSelectedIndex:tap.view.tag];
}

-(void) handleTabBarItemClick:(HIUITabBarItem *)item
{
    ;
}

-(void) setSelectedIndex:(NSUInteger)selectedIndex
{
    if (selectedIndex == self.lastSelectIndex) {
        return;
    }
    
    [super setSelectedIndex:selectedIndex];
    
    self.bar.selectedIndex = selectedIndex;
    [self handleTabBarItemClick:self.bar.items[selectedIndex]];
    
    [self.tabBar bringSubviewToFront:self.bar];
    
    self.lastSelectIndex = selectedIndex;
    
}

-(void) setSelectedViewController:(UIViewController *)selectedViewController
{
    [super setSelectedViewController:selectedViewController];
    
    NSInteger selectIndex = self.selectedIndex;
    
    [self handleTabBarItemClick:self.bar.items[selectIndex]];
    
    self.bar.selectedIndex = selectIndex;
    
    [self.tabBar bringSubviewToFront:self.bar];
    
    self.lastSelectIndex = self.selectedIndex;
}

-(void) setViewControllers:(NSArray *)viewControllers
{
    [super setViewControllers:viewControllers];
    
    [self resetTabBarWithViewControllers:viewControllers];
    
    [self.tabBar bringSubviewToFront:self.bar];
}

-(void) setViewControllers:(NSArray *)viewControllers animated:(BOOL)animated
{
    [super setViewControllers:viewControllers animated:animated];
    
    [self resetTabBarWithViewControllers:viewControllers];
    
    [self.tabBar bringSubviewToFront:self.bar];
}

@end

