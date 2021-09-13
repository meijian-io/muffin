//
//  MuffinNavigator.h
//  muffin
//
//  Created by 孙武东 on 2021/6/30.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MuffinNavigator : NSObject

+ (void)push:(NSString *)pageName;

+ (void)push:(NSString *)pageName andArg:(NSDictionary *)arguments;

+ (void)pushUri:(NSString *)uri;

@end

NS_ASSUME_NONNULL_END
