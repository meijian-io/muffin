//
//  NavigatorStack.h
//  muffin
//
//  Created by 孙武东 on 2021/6/18.
//

#import <Foundation/Foundation.h>
#import "MuffinVC.h"

NS_ASSUME_NONNULL_BEGIN

@interface NavigatorStack : NSObject

//@property (nonatomic, strong)NSString *pageName;

@property (nonatomic, strong)NSMutableArray *flutterPages;

@property (nonatomic, strong)MuffinVC *vc;

//- (instancetype)initWithVC:(MuffinVC *)vc;
//
//- (instancetype)initWithVC:(MuffinVC *)vc pageName:(NSString *)pageName;

@end

NS_ASSUME_NONNULL_END
