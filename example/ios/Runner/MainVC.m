//
//  MainVC.m
//  Runner
//
//  Created by 孙武东 on 2021/6/23.
//

#import "MainVC.h"

#import <muffin/MuffinNavigator.h>
//
//#import <muffin/MuffinVC.h>
#import <muffin/Muffin.h>
#import "SecondVC.h"
@interface MainVC ()

@end

@implementation MainVC

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [[Muffin sharedInstance] setPushNativeVC:^(NSString * _Nonnull pageName, id  _Nonnull data) {
        SecondVC *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SecondVC"];
        [self.navigationController pushViewController:vc animated:YES];
    }];
    
    // Do any additional setup after loading the view.
}

- (IBAction)clickpushBtn:(UIButton *)sender {
        
    [MuffinNavigator push:@"/first" andArg:@{@"count":@1,@"desc":@"This is cool",@"good":@(true)}];
    
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
