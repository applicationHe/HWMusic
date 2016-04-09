//
//  HNavigationController.m
//  HWMusic
//
//  Created by admin on 16/4/9.
//  Copyright © 2016年 he. All rights reserved.
//

#import "HNavigationController.h"

@interface HNavigationController ()

@end

@implementation HNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
        [self setNeedsStatusBarAppearanceUpdate];
    }
    NSDictionary * textattributes = nil;
    [self.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_bg"] forBarMetrics:UIBarMetricsDefault];
    textattributes = @{
                       NSFontAttributeName:[UIFont boldSystemFontOfSize:18],
                       NSForegroundColorAttributeName:[UIColor whiteColor],
                       };
    self.navigationBar.titleTextAttributes = textattributes;
    
    
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

-(BOOL)prefersStatusBarHidden
{
    return NO;
}

@end
