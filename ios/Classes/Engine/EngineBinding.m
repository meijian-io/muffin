//
//  EngineBinding.m
//  muffin
//
//  Created by 孙武东 on 2021/6/18.
//

#import "EngineBinding.h"

#import "NavigatorStack.h"
#import "NavigatorStackManager.h"
#import <Flutter/Flutter.h>
#import "Muffin.h"

#define MJWeakSelf __weak typeof(self) weakSelf = self;

@interface EngineBinding()

@property (nonatomic, strong)FlutterMethodChannel *methodChannel;

@end

@implementation EngineBinding

- (instancetype)initWithEntryPoint:(nonnull NSString *)entryPoint{
    return [self initWithEntryPoint:entryPoint withArg:nil];
}

- (instancetype)initWithEntryPoint:(nonnull NSString *)entryPoint withArg:(nullable NSDictionary *)arguments{
    self = [super init];
    if (self) {
        
        FlutterEngineGroup *group = [Muffin sharedInstance].engineGroup;
        FlutterEngine *flutterEngine = [group makeEngineWithEntrypoint:entryPoint libraryURI:nil];
        self.flutterEngine = flutterEngine;
        self.methodChannel = [FlutterMethodChannel methodChannelWithName:@"muffin_navigate" binaryMessenger:self.flutterEngine.binaryMessenger];
        
        MJWeakSelf
        [self.methodChannel setMethodCallHandler:^(FlutterMethodCall * _Nonnull call, FlutterResult  _Nonnull result) {
            if ([call.method isEqualToString:@"getArguments"]) {
                if (arguments != nil) {
                    result(arguments);
                }else{
                    result(@{});
                }
            }else if ([call.method isEqualToString:@"syncFlutterStack"]) {
                NavigatorStack *stack = [[NavigatorStack alloc] initWithVC:weakSelf.weakVC pageName:call.arguments[@"pageName"]];
                [[NavigatorStackManager sharedInstance] syncFlutterStack:stack];
                result(@{});
            }else if ([call.method isEqualToString:@"pop"] || [call.method isEqualToString:@"popUntil"]) {
                [[NavigatorStackManager sharedInstance] pop:call.arguments[@"pageName"] result:call.arguments[@"result"]];
                result(@{});
            }else if ([call.method isEqualToString:@"findPopTarget"]) {
                NSString *target = [[NavigatorStackManager sharedInstance] findPopTarget];
                result(target);
            }else if ([call.method isEqualToString:@"pushNamed"]) {
                [[NavigatorStackManager sharedInstance] pushNamed:call.arguments[@"pageName"] data:call.arguments[@"data"]];
                result(@{});
            }else if ([call.method isEqualToString:@"setArguments"]) {
                
            }else{
                result(@{});

            }
           
        }];
    }
    return self;
}

- (void)attach{
    
}

- (void)popUntil:(NSString *)pageName result:(id)result{
    if (pageName.length == 0) {
        NSLog(@"pageName 不能未空");
        return;
    }
    NSMutableDictionary *map = [@{@"pageName":pageName} mutableCopy];
    if (result) {
        [map setValue:result forKey:@"result"];
    }
    [self.methodChannel invokeMethod:@"popUntil" arguments:map];
}

- (void)detach{
    [self.methodChannel setMethodCallHandler:^(FlutterMethodCall * _Nonnull call, FlutterResult  _Nonnull result) {
            
    }];
}


@end
