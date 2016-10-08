//
//  MYCell.h
//  acupuncture
//
//  Created by 陈双超 on 15/6/15.
//  Copyright (c) 2015年 陈双超. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MYCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *MyImage;
@property (weak, nonatomic) IBOutlet UILabel *MyNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *MyDetailLabel;

@end
