//
//  AboutVC.h
//  acupuncture
//
//  Created by 陈双超 on 15/6/16.
//  Copyright (c) 2015年 陈双超. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface AboutVC : UIViewController<UIActionSheetDelegate,MFMailComposeViewControllerDelegate,MFMessageComposeViewControllerDelegate,UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *FeedBackView;
@property (weak, nonatomic) IBOutlet UITextView *MyTextView;

- (IBAction)CommitAction:(UIButton *)sender;


- (IBAction)goBackAction:(id)sender;
- (IBAction)ShareAction:(id)sender;
- (IBAction)FeedBackAction:(id)sender;

@end
