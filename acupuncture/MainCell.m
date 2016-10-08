//
//  MainCell.m
//  NT
//
//  Created by Kohn on 14-5-27.
//  Copyright (c) 2014年 Pem. All rights reserved.
//

#import "MainCell.h"
#define SCREEN_WIDTH    ([UIScreen mainScreen].bounds.size.width)

@implementation MainCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor=[UIColor colorWithRed:228.0/255.0 green:254.0/255.0 blue:168.0/255.0 alpha:1];
        
        //分割线
        UIImageView *imageLine = [[UIImageView alloc]initWithFrame:CGRectMake(20, 0, SCREEN_WIDTH-20, 1)];
        [imageLine setImage:[UIImage imageNamed:@"line.png"]];
        [self.contentView addSubview:imageLine];
        
        
        //强度label
        UILabel* strengthLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 14, 60, 18)];
        strengthLabel.text=NSLocalizedStringFromTable(@"Strength", @"Localizable", nil);
        strengthLabel.textColor  = [UIColor colorWithRed:144.0/255.0 green:188.0/255.0 blue:53.0/255.0 alpha:1];
        strengthLabel.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:strengthLabel];
        
        
        
        _StrengthView=[[CustomSlideView alloc]initWithFrame:CGRectMake(80, 0, 220, 50)];
        _StrengthView.backgroundColor=[UIColor clearColor];
        [self.contentView addSubview:_StrengthView];
        
        
        //时间label
        UILabel* timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 80, 60, 18)];
        timeLabel.text=NSLocalizedStringFromTable(@"Time", @"Localizable", nil);
        timeLabel.textColor  = [UIColor colorWithRed:144.0/255.0 green:188.0/255.0 blue:53.0/255.0 alpha:1];
        timeLabel.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:timeLabel];
        
        
        //时间选择器
        _MyPickerView = [[AKPickerView alloc]initWithFrame:CGRectMake(80, 65, 220, 50)];
        _MyPickerView.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:20];
        _MyPickerView.highlightedFont = [UIFont fontWithName:@"HelveticaNeue" size:20];
        _MyPickerView.interitemSpacing = 20.0;
        _MyPickerView.fisheyeFactor = 0.001;
        _MyPickerView.pickerViewStyle = AKPickerViewStyle3D;
        _MyPickerView.maskDisabled = false;
        [self.contentView addSubview:_MyPickerView];
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

}

@end

