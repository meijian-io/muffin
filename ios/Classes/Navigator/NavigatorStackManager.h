//
//  NacigatorStackManager.h
//  muffin
//
//  Created by 孙武东 on 2021/6/18.
//

#import <Foundation/Foundation.h>

@class NavigatorStack;
@class MuffinVC;

NS_ASSUME_NONNULL_BEGIN

@interface NavigatorStackManager : NSObject

+ (NavigatorStackManager *)sharedInstance;

- (void)syncFlutterStack:(NavigatorStack *)stack;

- (void)pop:(NSString *)target result:(id)result;

- (NSString *)findPopTarget;

- (BOOL)pushNamed:(NSString *)pageName data:(id) data;

- (void)viewControllerCreate:(MuffinVC *)vc;

- (void)viewControllerDestroyed:(UIViewController *)vc;

- (MuffinVC *)getTopVC;

@end

NS_ASSUME_NONNULL_END
