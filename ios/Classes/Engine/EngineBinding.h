//
//  EngineBinding.h
//  muffin
//
//  Created by 孙武东 on 2021/6/18.
//

#import <Foundation/Foundation.h>
#import <Flutter/Flutter.h>

NS_ASSUME_NONNULL_BEGIN

@interface EngineBinding : NSObject

@property (nonatomic, strong)FlutterEngine *flutterEngine;

@property (nonatomic, weak)UIViewController *weakVC;

- (instancetype)initWithEntryPoint:(nonnull NSString *)entryPoint;

- (instancetype)initWithEntryPoint:(nonnull NSString *)entryPoint withArg:(nullable NSDictionary *)arguments;

- (void)detach;

- (void)attach;

- (void)popUntil:(NSString *)pageName result:(id)result;

@end

NS_ASSUME_NONNULL_END
