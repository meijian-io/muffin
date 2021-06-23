//
//  UIViewController+Muffin.m
//  muffin
//
//  Created by 孙武东 on 2021/6/22.
//

#import "UIViewController+Muffin.h"
#import <objc/runtime.h>
#import "NavigatorStackManager.h"

@implementation UIViewController (Muffin)

+ (void)exchangeMethod{
    Method oriMethod = class_getInstanceMethod([self class], NSSelectorFromString(@"dealloc"));
    Method repMethod = class_getInstanceMethod([self class], @selector(muffin_dealloc));
    method_exchangeImplementations(oriMethod, repMethod);
    
    [self exchangeInstanceMethod1:@selector(loadView) method2:@selector(muffin_loadView)];

}

- (void)muffin_loadView{
    [self muffin_loadView];
    [[NavigatorStackManager sharedInstance] viewControllerCreate:(UIViewController *)self];
    NSLog(@"add NavigatorStack === %@",NSStringFromClass([self class]));

}

- (void)muffin_dealloc{
    [[NavigatorStackManager sharedInstance] viewControllerDestroyed:(UIViewController *)self];
    NSLog(@"remove NavigatorStack === %@",NSStringFromClass([self class]));
}


+ (void)exchangeInstanceMethod1:(SEL)selector1 method2:(SEL)selector2 {
    Class class = [self class];
    Method method1 = class_getInstanceMethod(class, selector1);
    Method method2 = class_getInstanceMethod(class, selector2);
    BOOL didAddMethod = class_addMethod(class,selector1,
                                        method_getImplementation(method2),
                                        method_getTypeEncoding(method2));
    if (didAddMethod) {
        class_replaceMethod(class,selector2,
                            method_getImplementation(method1),
                            method_getTypeEncoding(method1));
    } else {
        method_exchangeImplementations(method1, method2);
    }
}


@end
