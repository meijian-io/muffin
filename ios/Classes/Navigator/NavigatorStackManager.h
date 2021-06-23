//
//  NacigatorStackManager.h
//  muffin
//
//  Created by 孙武东 on 2021/6/18.
//

#import <Foundation/Foundation.h>

@class NavigatorStack;

NS_ASSUME_NONNULL_BEGIN

@interface NavigatorStackManager : NSObject

+ (NavigatorStackManager *)sharedInstance;

- (void)syncFlutterStack:(NavigatorStack *)stack;

- (void)pop:(NSString *)target result:(id)result;

- (NSString *)findPopTarget;

- (BOOL)pushNamed:(NSString *)pageName data:(id) data;

- (void)viewControllerCreate:(UIViewController *)vc;

- (void)viewControllerDestroyed:(UIViewController *)vc;
@end

NS_ASSUME_NONNULL_END
