//
//  NacigatorStackManager.m
//  muffin
//
//  Created by 孙武东 on 2021/6/18.
//

#import "NavigatorStackManager.h"
#import "NavigatorStack.h"
#import "Muffin.h"
@interface NavigatorStackManager()

@property (nonatomic, strong)NSMutableArray *stacks;

@end

@implementation NavigatorStackManager

static NavigatorStackManager * _instance = nil;

+ (NavigatorStackManager *)sharedInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[NavigatorStackManager alloc] init];
    });
    return _instance;
}

- (void)syncFlutterStack:(NavigatorStack *)stack{
    [self.stacks insertObject:stack atIndex:0];
    NSLog(@"flutter has pushed, size = %ld",self.stacks.count);
}

- (void)pop:(NSString *)target result:(id)result{
    [self popUnitl:target result:result];
}

- (void)popUnitl:(NSString *)target result:(id)result{
    
    NSMutableArray *shouldPoppedStacks = [NSMutableArray array];
    NavigatorStack *targetStack = nil;
    BOOL findTarget = false;
    
    //寻找目标栈
    while (!findTarget) {
        if (self.stacks.count != 0) {
            NavigatorStack *temp = self.stacks.firstObject;
            if ([temp.pageName isEqualToString:target]) {
                targetStack = temp;
                findTarget = true;
            }else {
                NavigatorStack *popped = self.stacks.firstObject;
                [shouldPoppedStacks addObject:popped];
                [self.stacks removeObject:popped];
            }
        }else {
            findTarget = true;
        }
    }
    
    if (targetStack == nil) {
        NSLog(@"target not found size = %ld",self.stacks.count);
        [self logStack];
        return;
    }
    
    BOOL allInFlutterStack = true;
    
    for (NavigatorStack *shouldPoppedStack in shouldPoppedStacks) {
        if (shouldPoppedStack.currentVC != targetStack.currentVC) {
            allInFlutterStack = false;
            break;
        }
    }
    
    if (allInFlutterStack) {
        NSLog(@"only flutter pop, pop finish, size = %ld",self.stacks.count);
        [self logStack];
        return;
    }
    
    for (int i = (int)shouldPoppedStacks.count - 1; i >= 0; i--) {
        if (shouldPoppedStacks[i] == targetStack) {
            [self.stacks insertObject:shouldPoppedStacks[i] atIndex:0];
        }
    }
    for (NavigatorStack *popppedStack in shouldPoppedStacks) {
        if (popppedStack == targetStack) {
            continue;
        }
        [popppedStack.currentVC.navigationController popViewControllerAnimated:YES];
    }
    
    if (![targetStack.pageName isEqualToString:@"MuffinVC"]) {
        return;
    }
    
    [targetStack.currentVC.engineBinding popUntil:target result:result];
    
}

- (BOOL)pushNamed:(NSString *)pageName data:(id) data{
    
    if ([Muffin sharedInstance].pushNativeVC) {
        [Muffin sharedInstance].pushNativeVC(pageName,data);
    }
    
    
//    NSArray *configs = [Muffin sharedInstance].intentConfigs;
//    if (configs.count == 0) {
//        return false;
//    }
    BOOL find = false;
//
//    for (UIViewController *vc in configs) {
//        if ([NSStringFromClass([vc class]) isEqualToString:pageName]) {
//            find = true;
//
//            NSLog(@"todo : push %@",pageName);
//            break;
//        }
//    }
    return find;
}

- (NavigatorStack *)findTargetNavigatorStack:(NSString *)pageName {
    NavigatorStack *targetStack = nil;
    
    for (NavigatorStack *navigatorStack in self.stacks) {
        if ([pageName isEqualToString:navigatorStack.pageName]) {
            targetStack = navigatorStack;
            break;
        }
    }
    return targetStack;
}

- (void)viewControllerCreate:(UIViewController *)vc{
    
    if (![NSStringFromClass([vc class]) isEqualToString:@"MuffinVC"]) {
        NavigatorStack *stack = [[NavigatorStack alloc] initWithVC:vc];
        [self.stacks insertObject:stack atIndex:0];
        NSLog(@"stack add, size = %ld",self.stacks.count);
    }

}

- (void)viewControllerDestroyed:(UIViewController *)vc{
    if (![NSStringFromClass([vc class]) isEqualToString:@"MuffinVC"]) {
        if (self.stacks.count > 0) {
            NavigatorStack *stack = [self.stacks firstObject];
            if (stack.currentVC == vc) {
                [self.stacks removeObject:stack];
                NSLog(@"stack remove, system back press, size = %ld",self.stacks.count);

            }
        }
    }
}

- (NSString *)findPopTarget{
    if (self.stacks.count > 1) {
        NavigatorStack *stack = self.stacks[1];
        return stack.pageName;
    }
    return @"/";
}

- (void)logStack{
    if (self.stacks.count == 0) {
        return;
    }
    
    for (NavigatorStack *stack in self.stacks) {
        NSLog(@"NavigatorStackManager pageName ==== %@",stack.pageName);
    }
    
}

- (NSMutableArray *)stacks{
    if (!_stacks) {
        _stacks = [NSMutableArray array];
    }
    return _stacks;
}

@end
