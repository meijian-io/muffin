#import "AppDelegate.h"
#import "GeneratedPluginRegistrant.h"

#import <muffin/Muffin.h>
#import "MainVC.h"
@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
//  [GeneratedPluginRegistrant registerWithRegistry:self];
  // Override point for customization after application launch.
    
    [[Muffin sharedInstance] setGetDataModelByKey:^NSDictionary * _Nonnull{
        return @{@"key":@"BasicInfo",@"userId":@"10",@"isBindTbk":@(YES)};
    }];
    [[Muffin sharedInstance] setNativeChannelBlock:^NSDictionary * _Nonnull(NSString * _Nonnull methodName, NSDictionary * _Nonnull data) {
       
        NSLog(@"method name === %@",methodName);
        NSLog(@"%@",data);
        
        return @{};
    }];
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    MainVC *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"MainVC"];
    UINavigationController *navc = [[UINavigationController alloc] initWithRootViewController:vc];
    self.window.rootViewController = navc;
    
    
//  return [super application:application didFinishLaunchingWithOptions:launchOptions];
    return YES;
}

@end
