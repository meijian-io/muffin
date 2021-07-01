//
//  NacigatorStackManager.h
//  muffin
//
//  Created by 孙武东 on 2021/6/18.
//

#import <Foundation/Foundation.h>

@class NavigatorStack;
@class MuffinVC;

NS_ASSUME_NONNULL_BEGIN

@interface NavigatorStackManager : NSObject

+ (NavigatorStackManager *)sharedInstance;

//往栈顶添加容器
- (void)addStackTop:(NavigatorStack *)stack;

//移除栈顶容器
- (void)removeStackTop;

//往栈顶容器的pages中添加page
- (void)addFlutterPage:(NSString *)pagename;

//移除栈顶容器的pages中添加page
- (void)removeFlutterPage:(NSString *)pagename;

//用于flutter侧获取返回页面
- (NSString *)findPopTarget;

//获取push原生页面
- (BOOL)pushNamed:(NSString *)pageName data:(id) data;

//同步数据
- (void)syncDataModelAll:(id)data;

//- (void)syncFlutterStack:(NavigatorStack *)stack;
//
- (void)pop:(NSString *)target result:(id)result;

@end

NS_ASSUME_NONNULL_END
