//
//  MainVC.m
//  Runner
//
//  Created by 孙武东 on 2021/6/23.
//

#import "MainVC.h"

#import <muffin/MuffinNavigator.h>
#import <muffin/Muffin.h>
#import "SecondVC.h"
#import <muffin/NSObject+visibleVC.h>

@interface MainVC ()

@property (nonatomic, assign)NSInteger count;
@property (weak, nonatomic) IBOutlet UILabel *countL;

@end

@implementation MainVC

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.count = 1;
    
    [[Muffin sharedInstance] setPushNativeVC:^(NSString * _Nonnull pageName, id  _Nonnull data) {
//        SecondVC *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SecondVC"];
        MainVC *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MainVC"];
        [self.mj_topViewController.navigationController pushViewController:vc animated:YES];
    }];
    
    // Do any additional setup after loading the view.
}

- (IBAction)clickpushBtn:(UIButton *)sender {
        
    [MuffinNavigator push:@"/first" andArg:@{@"count":@(self.count),@"desc":@"This is cool",@"good":@(true)}];
    
}

- (IBAction)secondVC:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
//    [MuffinNavigator push:@"/second" andArg:@{@"count":@(self.count),@"desc":@"This is cool",@"good":@(true)}];
}

- (IBAction)mainvc:(UIButton *)sender {
    [MuffinNavigator push:@"/home" andArg:@{@"count":@(self.count),@"desc":@"This is cool",@"good":@(true)}];
}

- (IBAction)downAction:(UIButton *)sender {
    self.count--;
    self.countL.text = [NSString stringWithFormat:@"%ld",self.count];
}

- (IBAction)upAction:(UIButton *)sender {
    self.count++;
    self.countL.text = [NSString stringWithFormat:@"%ld",self.count];
}

- (IBAction)syncAction:(UIButton *)sender {
    [[Muffin sharedInstance] syncDataModelAll:@{@"key":@"BasicInfo",@"userId":[NSString stringWithFormat:@"%ld",self.count],@"isBindTbk":@(YES)}];
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
