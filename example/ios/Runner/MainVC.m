//
//  MainVC.m
//  Runner
//
//  Created by 孙武东 on 2021/6/23.
//

#import "MainVC.h"
#import <muffin/Muffin.h>
#import <muffin/NSObject+visibleVC.h>

#import "SecondVC.h"


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
        MainVC *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MainVC"];
        [self.mj_topViewController.navigationController pushViewController:vc animated:YES];
    }];
    
    // Do any additional setup after loading the view.
}

- (IBAction)clickpushBtn:(UIButton *)sender {
        
    [[Muffin sharedInstance] push:@"/first" andArg:@{@"count":@(self.count),@"desc":@"This is cool",@"good":@(true)}];
    
}

- (IBAction)secondVC:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)mainvc:(UIButton *)sender {
    [[Muffin sharedInstance] push:@"/home" andArg:@{@"count":@(self.count),@"desc":@"This is cool",@"good":@(true)}];
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

@end
