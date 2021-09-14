//
//  MuffinNavigator.m
//  muffin
//
//  Created by 孙武东 on 2021/6/30.
//

#import "MuffinNavigator.h"
#import "MuffinVC.h"
#import "NSObject+visibleVC.h"
#import "Muffin.h"
@implementation MuffinNavigator

+ (void)push:(NSString *)pageName{
    MuffinVC *vc = [[MuffinVC alloc] init];
    vc.pageName = pageName;
    if ([Muffin sharedInstance].registerPluginBlock) {
        [Muffin sharedInstance].registerPluginBlock(vc);
    }
    [self.mjTopViewController.navigationController pushViewController:vc animated:YES];
}

+ (void)push:(NSString *)pageName andArg:(NSDictionary *)arguments{
    MuffinVC *vc = [[MuffinVC alloc] init];
    vc.pageName = pageName;
    vc.params = arguments;
    if ([Muffin sharedInstance].registerPluginBlock) {
        [Muffin sharedInstance].registerPluginBlock(vc);
    }
    [self.mjTopViewController.navigationController pushViewController:vc animated:YES];
}

+ (void)pushUri:(NSString *)uri{
    MuffinVC *vc = [[MuffinVC alloc] init];
    vc.uri = uri;
    if ([Muffin sharedInstance].registerPluginBlock) {
        [Muffin sharedInstance].registerPluginBlock(vc);
    }
    [self.mjTopViewController.navigationController pushViewController:vc animated:YES];
}

@end
