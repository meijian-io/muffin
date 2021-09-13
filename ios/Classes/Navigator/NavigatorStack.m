//
//  NavigatorStack.m
//  muffin
//
//  Created by 孙武东 on 2021/6/18.
//

#import "NavigatorStack.h"

@implementation NavigatorStack

//- (instancetype)initWithVC:(MuffinVC *)vc{
//    self = [super init];
//    if (self) {
//        self.currentVC = vc;
//        self.pageName = NSStringFromClass([vc class]);
//    }
//    return self;
//}
//
//- (instancetype)initWithVC:(MuffinVC *)vc pageName:(NSString *)pageName{
//    self = [super init];
//    if (self) {
//        self.currentVC = vc;
//        self.pageName = pageName;
//    }
//    return self;
//}

//- (void)notifyCallbacks:(id)result pageName:(NSString *)pageName{
//    NSLog(@"todo: notifyCallbacks");
    
//    if (pathProvider != null && result instanceof HashMap) {
//      pathProvider.onFlutterActivityResult(pageName, (HashMap<String, Object>) result);
//    }
//}

//- (NSString *)toString{
//    return [NSString stringWithFormat:@"NavigatorStack{ host= %@, pageName= %@}",@"",self.pageName];
//}

- (NSMutableArray *)flutterPages{
    if (!_flutterPages) {
        _flutterPages = [NSMutableArray array];
    }
    return _flutterPages;
}

@end
