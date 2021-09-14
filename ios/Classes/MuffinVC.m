//
//  MuffinVC.m
//  muffin
//
//  Created by 孙武东 on 2021/6/22.
//

#import "MuffinVC.h"
#import "Muffin.h"
#import "NavigatorStackManager.h"
#import "NavigatorStack.h"

@interface MuffinVC ()

@property (nonatomic,strong)FlutterEngine *flutterEngine;

@end

@implementation MuffinVC

- (instancetype)init{

    FlutterEngineGroup *group = [Muffin sharedInstance].engineGroup;
    FlutterEngine *flutterEngine = [group makeEngineWithEntrypoint:@"main" libraryURI:nil];
    self = [super initWithEngine:flutterEngine nibName:nil bundle:nil];
    if (self) {
        self.flutterEngine = flutterEngine;
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    NavigatorStack *stack = [[NavigatorStack alloc] init];
    stack.vc = self;
    
    [[NavigatorStackManager sharedInstance] addStackTop:stack];
    
    EngineBinding *binding = binding = [[EngineBinding alloc] init];
    binding.flutterEngine = self.flutterEngine;
    binding.pageName = self.pageName;
    binding.arguments = self.params;
    binding.weakVC = self;
    [binding createFlutterMethodChannel];
    self.engineBinding = binding;
    [self.engineBinding attach];
    
}

- (void)dealloc{
    [self.engineBinding detach];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
