//
//  UIViewController+visibleVC.m
//  muffin
//
//  Created by 孙武东 on 2021/6/30.
//

#import "NSObject+visibleVC.h"
#import <Social/Social.h>

@implementation NSObject (visibleVC)

- (UIViewController *)mj_topViewController {
    UIViewController *resultVC;
    resultVC = [self _topViewController:[[[UIApplication sharedApplication].delegate window] rootViewController]];
    while (resultVC.presentedViewController) {
        if ([resultVC.presentedViewController isKindOfClass:[UIAlertController class]]
            || [resultVC.presentedViewController isKindOfClass:[UIActivityViewController class]]
            || [resultVC.presentedViewController isKindOfClass:[SLComposeViewController class]]) {
            return [self _topViewController:resultVC.presentedViewController];
        }
        resultVC = [self _topViewController:resultVC.presentedViewController];
    }
    return resultVC;
}

- (UIViewController *)mjTopViewController {
    UIViewController *resultVC;
    resultVC = [self _topViewController:[[[UIApplication sharedApplication].delegate window] rootViewController]];
    while (resultVC.presentedViewController) {
        if ([resultVC.presentedViewController isKindOfClass:[UIAlertController class]]
            || [resultVC.presentedViewController isKindOfClass:[UIActivityViewController class]]
            || [resultVC.presentedViewController isKindOfClass:[SLComposeViewController class]]) {
            return [self _topViewController:resultVC.presentedViewController];
        }
        resultVC = [self _topViewController:resultVC.presentedViewController];
    }
    return resultVC;
}

- (UIViewController *)_topViewController:(UIViewController *)vc {
    if ([vc isKindOfClass:[UINavigationController class]]) {
        return [self _topViewController:[(UINavigationController *)vc topViewController]];
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        return [self _topViewController:[(UITabBarController *)vc selectedViewController]];
    } else {
        return vc;
    }
    return nil;
}

@end
