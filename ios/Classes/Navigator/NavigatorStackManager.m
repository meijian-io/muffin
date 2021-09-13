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

//往栈顶添加容器
- (void)addStackTop:(NavigatorStack *)stack{
    [self.stacks addObject:stack];
}

//移除栈顶容器
- (void)removeStackTop{
    if (self.stacks.count) {
        [self.stacks removeLastObject];
    }
}

//往栈顶容器的pages中添加page
- (void)addFlutterPage:(NSString *)pagename{
    if (self.stacks.count) {
        NavigatorStack *stack = self.stacks.lastObject;
        [stack.flutterPages addObject:pagename];
    }
}

//移除栈顶容器的pages中添加page
- (void)removeFlutterPage:(NSString *)pagename{
    if (self.stacks.count) {
        NavigatorStack *stack = self.stacks.lastObject;
        if (stack.flutterPages.count) {
            [stack.flutterPages removeLastObject];
            if (stack.flutterPages.count == 0) {
                [self removeStackTop];
                //todo: 是否需要pop?
                
            }
        }
        
    }
}

//移除栈顶容器的pages中添加page
- (void)popFlutterPage{
    if (self.stacks.count) {
        NavigatorStack *stack = self.stacks.lastObject;
        if (stack.flutterPages.count) {
            [stack.flutterPages removeLastObject];
            if (stack.flutterPages.count == 0) {
                [self removeStackTop];
                //todo: 是否需要pop?
                
            }
        }
        
    }
}

//
//- (void)syncFlutterStack:(NavigatorStack *)stack{
////    [self.stacks insertObject:stack atIndex:0];
//    NSLog(@"flutter has pushed, size = %ld",self.stacks.count);
//}

- (void)pop:(NSString *)target result:(id)result{
    [self popUnitl:target result:result];
}

- (void)popUnitl:(NSString *)target result:(id)result{
    
    if ([target isEqualToString:@"/"]) {
        NavigatorStack *stack = self.stacks.lastObject;
        [stack.vc.navigationController popViewControllerAnimated:YES];
        [self.stacks removeLastObject];
        return;
    }
    
    NSMutableArray *shouldPoppedStacks = [NSMutableArray array];
    NavigatorStack *targetStack = nil;
    BOOL findTarget = false;
    
    for (NSUInteger i = self.stacks.count - 1; i >= 0; i--) {
        NavigatorStack *temp = self.stacks[i];
        
        for (NSUInteger j = temp.flutterPages.count - 1; j >= 0; j--) {
            NSString *pagename = temp.flutterPages[j];
            if ([pagename isEqualToString:target]) {
                targetStack = temp;
                findTarget = true;
                break;
            }else{
            }
        }
        if (findTarget == true) {
            break;
        }
        [shouldPoppedStacks addObject:temp];
    }
    
    //寻找目标栈
//    while (!findTarget) {
//        if (self.stacks.count != 0) {
//            NavigatorStack *temp = self.stacks.firstObject;
//            if ([temp.pageName isEqualToString:target]) {
//                targetStack = temp;
//                findTarget = true;
//            }else {
//                NavigatorStack *popped = self.stacks.firstObject;
//                [shouldPoppedStacks addObject:popped];
//                [self.stacks removeObject:popped];
//            }
//        }else {
//            findTarget = true;
//        }
//    }

    if (targetStack == nil) {
        NSLog(@"target not found size = %ld",self.stacks.count);
        [self logStack];
        return;
    }

    BOOL allInFlutterStack = true;

    for (NavigatorStack *shouldPoppedStack in shouldPoppedStacks) {
        if (shouldPoppedStack.vc != targetStack.vc) {
            allInFlutterStack = false;
            break;
        }
    }

    if (allInFlutterStack) {
        [self popFlutterPage];
        NSLog(@"only flutter pop, pop finish, size = %ld",self.stacks.count);
        [self logStack];
        return;
    }

//    for (NSUInteger i = shouldPoppedStacks.count - 1; i >= 0; i--) {
//        if (shouldPoppedStacks[i] == targetStack) {
//            [self.stacks insertObject:shouldPoppedStacks[i] atIndex:0];
//            [self addStackTop:shouldPoppedStacks[i]];
//        }
//    }
    
    for (NavigatorStack *popppedStack in shouldPoppedStacks) {
        if (popppedStack == targetStack) {
            continue;
        }
        [popppedStack.vc.navigationController popViewControllerAnimated:YES];
    }

    if (![NSStringFromClass([targetStack.vc class]) isEqualToString:@"MuffinVC"]) {
        return;
    }

    [targetStack.vc.engineBinding popUntil:target result:result];
    
}

- (BOOL)pushNamed:(NSString *)pageName data:(id) data{
    
    if ([Muffin sharedInstance].pushNativeVC) {
        [Muffin sharedInstance].pushNativeVC(pageName,data);
    }

    return YES;
}

- (NSString *)findPopTarget{
    if (self.stacks.count) {
        NavigatorStack *stack = self.stacks.lastObject;
        if (stack.flutterPages.count > 1) {
            return stack.flutterPages[stack.flutterPages.count - 2];
        }
    }
    return @"/";
}

- (void)syncDataModelAll:(id)data{
    
    for (NavigatorStack *stack in self.stacks) {
        MuffinVC *vc = stack.vc;
        [vc.engineBinding syncDataModelWithArg:data];
    }
    
}

- (void)sendSystemEvent:(NSString *)name params:(NSDictionary *)params{
    if (self.stacks.count) {
        NavigatorStack *stack = self.stacks.lastObject;
        MuffinVC *vc = stack.vc;
        [vc.engineBinding sendChannelSystemEvent:name params:params];
    }

}

- (void)sendAllSystemEvent:(NSString *)name params:(NSDictionary *)params{
    for (NavigatorStack *stack in self.stacks) {
        MuffinVC *vc = stack.vc;
        [vc.engineBinding sendChannelSystemEvent:name params:params];
    }
}

- (void)logStack{
    if (self.stacks.count == 0) {
        return;
    }
    
    for (NavigatorStack *stack in self.stacks) {
        NSLog(@"NavigatorStackManager pageName ==== %@",[stack.flutterPages componentsJoinedByString:@","]);
        NSLog(@"NavigatorStackManager count ==== %ld",stack.flutterPages.count);
    }
    
}

- (NSMutableArray *)stacks{
    if (!_stacks) {
        _stacks = [NSMutableArray array];
    }
    return _stacks;
}

@end
