#import "MuffinPlugin.h"

@interface MuffinPlugin()

@property (nonatomic, strong)FlutterMethodChannel *channel;

@end

@implementation MuffinPlugin

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar{
    FlutterMethodChannel* channel = [FlutterMethodChannel methodChannelWithName:@"muffin" binaryMessenger:[registrar messenger]];
    MuffinPlugin* instance = [[MuffinPlugin alloc] init];
    instance.channel = channel;
    [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result{
    NSLog(@"method name ===== %@",call.method);
  if ([@"getPlatformVersion" isEqualToString:call.method]) {
    result([@"iOS " stringByAppendingString:[[UIDevice currentDevice] systemVersion]]);
  } else {
    result(FlutterMethodNotImplemented);
  }
}

- (void)detachFromEngineForRegistrar:(NSObject<FlutterPluginRegistrar> *)registrar{
    [self.channel setMethodCallHandler:^(FlutterMethodCall * _Nonnull call, FlutterResult  _Nonnull result) {
        NSLog(@"plugin call method === %@",call.method);
    }];
}

@end
