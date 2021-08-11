//
//  Muffin.m
//  muffin
//
//  Created by 孙武东 on 2021/6/22.
//

#import "Muffin.h"
#import "NavigatorStackManager.h"
#import "MuffinNavigator.h"

@implementation Muffin

static Muffin * _instance = nil;

+ (Muffin *)sharedInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[Muffin alloc] init];
    });
    return _instance;
}

- (NSDictionary *)getDataModelByKey:(NSString *)key{
    return self.getDataModelByKey();
}

- (void)syncDataModelAll:(id)data{
    [[NavigatorStackManager sharedInstance] syncDataModelAll:data];
}

- (void)push:(NSString *)pageName andArg:(NSDictionary *)arguments{
    [MuffinNavigator push:pageName andArg:arguments];
}

- (FlutterEngineGroup *)engineGroup{
    if (!_engineGroup) {
        _engineGroup = [[FlutterEngineGroup alloc] initWithName:@"main" project:nil];
    }
    return _engineGroup;
}

@end
