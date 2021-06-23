//
//  IntentConfig.m
//  muffin
//
//  Created by 孙武东 on 2021/6/18.
//

#import "IntentConfig.h"

@implementation IntentConfig

- (instancetype)initViewController:(UIViewController *) vcClass withPath:(NSString *)path{
    self = [super init];
    if (self) {
        self.vcClazz = vcClass;
        self.path = path;
    }
    return self;
}

- (instancetype)initViewController:(UIViewController *) vcClass withPath:(NSString *)path withArg:(NSArray *)arguments{
    self = [super init];
    if (self) {
        self.vcClazz = vcClass;
        self.path = path;
        self.arguments = arguments;
    }
    return self;
}

@end
