//
//  MuffinVC.h
//  muffin
//
//  Created by 孙武东 on 2021/6/22.
//

#import <Flutter/Flutter.h>
#import "EngineBinding.h"

NS_ASSUME_NONNULL_BEGIN

@interface MuffinVC : FlutterViewController

- (instancetype)initWithPageName:(nonnull NSString *)pageName AndParams:(nullable id)params;

@property (nonatomic, strong)EngineBinding *engineBinding;

@end

NS_ASSUME_NONNULL_END
