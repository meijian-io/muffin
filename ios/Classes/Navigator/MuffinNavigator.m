//
//  MuffinNavigator.m
//  muffin
//
//  Created by 孙武东 on 2021/6/30.
//

#import "MuffinNavigator.h"
#import "NavigatorStackManager.h"
#import "MuffinVC.h"
#import "NSObject+visibleVC.h"

@implementation MuffinNavigator

+ (void)push:(NSString *)pageName{
    MuffinVC *vc = [[MuffinVC alloc] init];
    vc.pageName = pageName;
    [self.mjTopViewController.navigationController pushViewController:vc animated:YES];
}

+ (void)push:(NSString *)pageName andArg:(NSDictionary *)arguments{
    MuffinVC *vc = [[MuffinVC alloc] init];
    vc.pageName = pageName;
    vc.params = arguments;
    [self.mjTopViewController.navigationController pushViewController:vc animated:YES];
}

+ (void)pushUri:(NSString *)uri{
    MuffinVC *vc = [[MuffinVC alloc] init];
    vc.uri = uri;
    [self.mjTopViewController.navigationController pushViewController:vc animated:YES];
}

@end
