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
@property (nonatomic, strong)FlutterMethodChannel *nativeChannel;

@end

@implementation EngineBinding

- (void)createFlutterMethodChannel{
    self.methodChannel = [FlutterMethodChannel methodChannelWithName:@"muffin_navigate" binaryMessenger:self.flutterEngine.binaryMessenger];
    self.nativeChannel = [FlutterMethodChannel methodChannelWithName:@"mj_channel" binaryMessenger:self.flutterEngine.binaryMessenger];
    
    [self.nativeChannel setMethodCallHandler:^(FlutterMethodCall * _Nonnull call, FlutterResult  _Nonnull result) {
        result([Muffin sharedInstance].nativeChannelBlock(call.method,call.arguments));
    }];
    
    MJWeakSelf
    [self.methodChannel setMethodCallHandler:^(FlutterMethodCall * _Nonnull call, FlutterResult  _Nonnull result) {
        if ([call.method isEqualToString:@"getArguments"]) {
            
            NSMutableDictionary * map = [NSMutableDictionary dictionary];
            [map setValue:weakSelf.pageName forKey:@"url"];
            if (weakSelf.arguments) {
                [map setValue:weakSelf.arguments forKey:@"arguments"];
            }
            
            result(map);
        }else if ([call.method isEqualToString:@"syncFlutterStack"]) {
            [[NavigatorStackManager sharedInstance] addFlutterPage:call.arguments[@"pageName"]];
//            NavigatorStack *stack = [[NavigatorStack alloc] initWithVC:weakSelf.weakVC pageName:call.arguments[@"pageName"]];
//            [[NavigatorStackManager sharedInstance] syncFlutterStack:stack];
            result(@{});
        }else if ([call.method isEqualToString:@"pop"] || [call.method isEqualToString:@"popUntil"]) {
            [[NavigatorStackManager sharedInstance] pop:call.arguments[@"pageName"] result:call.arguments[@"result"]];
            result(@{});
        }else if ([call.method isEqualToString:@"findPopTarget"]) {
            NSString *target = [[NavigatorStackManager sharedInstance] findPopTarget];
            result(target);
        }else if ([call.method isEqualToString:@"pushNamed"]) {
           BOOL pushResult = [[NavigatorStackManager sharedInstance] pushNamed:call.arguments[@"pageName"] data:call.arguments[@"data"]];
            result(@(pushResult));
        }else if ([call.method isEqualToString:@"setArguments"]) {
            
        }else if ([call.method isEqualToString:@"initDataModel"]) {
            NSString *key =  call.arguments[@"key"];
            result([[Muffin sharedInstance] getDataModelByKey:key]);
        }else if ([call.method isEqualToString:@"syncDataModel"]) {
//            NSDictionary *model = call.arguments;
            result(@{});
        }else{
            result(@{});
        }
        
    }];
}
  
- (void)attach{
    
}

- (void)detach{

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

- (void)syncDataModelWithArg:(id)argument{
    [self.methodChannel invokeMethod:@"syncDataModel" arguments:argument];
}



@end
