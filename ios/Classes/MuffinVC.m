//
//  MuffinVC.m
//  muffin
//
//  Created by 孙武东 on 2021/6/22.
//

#import "MuffinVC.h"
#import "Muffin.h"

@interface MuffinVC ()

@property (nonatomic, strong)id params;
@property (nonatomic, strong)NSString *pageName;
@property (nonatomic, strong)EngineBinding *engineBinding;

@end

@implementation MuffinVC

- (instancetype)initWithPageName:(nonnull NSString *)pageName AndParams:(nullable id)params{

    EngineBinding *binding = nil;
    if (params == nil) {
        binding = [[EngineBinding alloc] initWithEntryPoint:pageName];
    }else{
        binding = [[EngineBinding alloc] initWithEntryPoint:pageName withArg:params];
    }
    
    self = [super initWithEngine:binding.flutterEngine nibName:nil bundle:nil];
    if (self) {
        binding.weakVC = self;
        self.engineBinding = binding;
        [self.engineBinding attach];
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
}

- (EngineBinding *)getCurrentEngineBinding{
    return self.engineBinding;
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
