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

- (void)syncDataModel:(NSString *)key andArg:(id)argument;

- (void)createFlutterMethodChannel;

@end

NS_ASSUME_NONNULL_END
