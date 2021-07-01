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

@property (nonatomic, strong)EngineBinding *engineBinding;

@property (nonatomic, strong)NSString *pageName;

@property (nonatomic, strong)NSDictionary *params;

@property (nonatomic, strong)NSString *uri;

@end

NS_ASSUME_NONNULL_END
