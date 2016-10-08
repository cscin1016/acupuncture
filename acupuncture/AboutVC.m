//
//  AboutVC.m
//  acupuncture
//
//  Created by 陈双超 on 15/6/16.
//  Copyright (c) 2015年 陈双超. All rights reserved.
//

#import "AboutVC.h"


@interface AboutVC ()

@end

@implementation AboutVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
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

- (IBAction)CommitAction:(UIButton *)sender {
    [_MyTextView resignFirstResponder];
    _FeedBackView.hidden=YES;
    
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
//    if ([@"\n" isEqualToString:text] == YES) {
//        [textView resignFirstResponder];
//        return NO;
//    }
    return YES;
}
- (IBAction)goBackAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)ShareAction:(id)sender {
    UIActionSheet *actionSheet=[[UIActionSheet alloc]initWithTitle:NSLocalizedStringFromTable(@"Where_To_Share", @"Localizable", nil) delegate:self cancelButtonTitle:NSLocalizedStringFromTable(@"Cancel", @"Localizable", nil) destructiveButtonTitle:nil otherButtonTitles:NSLocalizedStringFromTable(@"Email", @"Localizable", nil),NSLocalizedStringFromTable(@"Message", @"Localizable", nil), nil];
    [actionSheet showInView:self.view];
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSLog(@"%ld",(long)buttonIndex);
    if(buttonIndex==0){
        [self sendSMS:@"I‘m using iHeper,it is great!" recipientList:nil];
    }else if(buttonIndex==1){
        MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
        mc.mailComposeDelegate = self;
        [mc setSubject:@"Hi!"];
//        [mc setToRecipients:[NSArray arrayWithObjects:@"zhuqi0@126.com","@dave@iphonedevbook.com", nil]];
        [mc setMessageBody:@"I‘m using iHeper,it is great!" isHTML:NO];
        [self presentViewController:mc animated:YES completion:nil];
    }
}

//调用sendSMS函数，发送内容，收件人列表
- (void)sendSMS:(NSString *)bodyOfMessage recipientList:(NSArray *)recipients
{
    
    MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc] init];
    if([MFMessageComposeViewController canSendText])
    {
        controller.body = bodyOfMessage;
        controller.recipients = recipients;
        controller.messageComposeDelegate = self;
        [self presentViewController:controller animated:YES completion:nil];
    }
    
}

// 处理发送完的响应结果
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
    if (result == MessageComposeResultCancelled)
        NSLog(@"Message cancelled");
    else if (result == MessageComposeResultSent)
        NSLog(@"Message sent");
    else
        NSLog(@"Message failed") ;
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail send canceled...");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved...");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent...");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail send errored: %@...", [error localizedDescription]);
            break;
        default:
            break;
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)FeedBackAction:(id)sender {
    _FeedBackView.hidden=NO;
    [_MyTextView becomeFirstResponder];
}

@end
