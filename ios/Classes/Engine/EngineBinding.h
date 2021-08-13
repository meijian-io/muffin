//
//  EngineBinding.h
//  muffin
//
//  Created by 孙武东 on 2021/6/18.
//

#import <Foundation/Foundation.h>
#import <Flutter/Flutter.h>

@class MuffinVC;

NS_ASSUME_NONNULL_BEGIN

@interface EngineBinding : NSObject

@property (nonatomic, strong)FlutterEngine *flutterEngine;

@property (nonatomic, weak)MuffinVC *weakVC;

@property (nonatomic, strong)NSString *pageName;

@property (nonatomic, strong)NSDictionary *arguments;

- (void)detach;

- (void)attach;

- (void)popUntil:(NSString *)pageName result:(id)result;
/**
    同步basic数据
    argument: basic数据
 */
- (void)syncDataModelWithArg:(id)argument;

- (void)createFlutterMethodChannel;

/**
    原生调用flutter
    name: channel key
    params: channel 参数
 */
- (void)sendChannelSystemEvent:(NSString *)name params:(NSDictionary *)params;

@end

NS_ASSUME_NONNULL_END
