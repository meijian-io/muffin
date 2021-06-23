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

@property (nonatomic, strong)NSMutableArray *intentConfigs;

@property (nonatomic, strong)void (^pushNativeVC)(NSString *pageName,id data);

+ (Muffin *)sharedInstance;



@end

NS_ASSUME_NONNULL_END
