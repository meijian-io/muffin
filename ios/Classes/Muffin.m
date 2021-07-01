//
//  Muffin.m
//  muffin
//
//  Created by 孙武东 on 2021/6/22.
//

#import "Muffin.h"
#import "UIViewController+Muffin.h"
@implementation Muffin

static Muffin * _instance = nil;

+ (Muffin *)sharedInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[Muffin alloc] init];
        [UIViewController exchangeMethod];
    });
    return _instance;
}

- (NSDictionary *)getDataModelByKey:(NSString *)key{
    return self.getDataModelByKey();
}

//- (NSDictionary *)listener:(NSString *)key{
//
//    //todo:监听查找
//
//    return @{};
//}

- (FlutterEngineGroup *)engineGroup{
    if (!_engineGroup) {
        _engineGroup = [[FlutterEngineGroup alloc] initWithName:@"main" project:nil];
    }
    return _engineGroup;
}

@end
