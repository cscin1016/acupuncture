//
//  ModelVC.m
//  acupuncture
//
//  Created by 陈双超 on 15/5/14.
//  Copyright (c) 2015年 陈双超. All rights reserved.
//

#import "ModelVC.h"

@interface ModelVC (){
    
}

@end

@implementation ModelVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _modeOne.numberOfLines=0;
    _modeTwo.numberOfLines=0;
    _modeThree.numberOfLines=0;
    _modeFour.numberOfLines=0;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)SelectModeAction:(UIButton *)sender {
    NSDictionary *dic=[[NSDictionary alloc]initWithObjectsAndKeys:[NSNumber numberWithInteger:sender.tag],@"ModeNumber",nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ModeNotification" object:nil userInfo:dic];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)GetBackAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
