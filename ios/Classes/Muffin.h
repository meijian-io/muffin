//
//  Muffin.h
//  muffin
//
//  Created by 孙武东 on 2021/6/22.
//

#import <Foundation/Foundation.h>
#import <Flutter/Flutter.h>

NS_ASSUME_NONNULL_BEGIN

@interface Muffin : NSObject

@property (nonatomic, strong)FlutterEngineGroup *engineGroup;

@property (nonatomic, strong)void (^pushNativeVC)(NSString *pageName,id data);

@property (nonatomic, strong)NSDictionary *(^getDataModelByKey)(void);

+ (Muffin *)sharedInstance;

- (NSDictionary *)getDataModelByKey:(NSString *)key;

- (void)push:(NSString *)pageName andArg:(NSDictionary *)arguments;

- (void)syncDataModelAll:(id)data;

@end

NS_ASSUME_NONNULL_END
