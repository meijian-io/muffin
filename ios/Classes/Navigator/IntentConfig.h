//
//  IntentConfig.h
//  muffin
//
//  Created by 孙武东 on 2021/6/18.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface IntentConfig : NSObject


@property (nonatomic, strong)UIViewController *vcClazz;

@property (nonatomic, strong)NSArray *arguments;

@property (nonatomic, strong)NSString *path;

@end

NS_ASSUME_NONNULL_END
