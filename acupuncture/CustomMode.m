//
//  CustomMode.m
//  acupuncture
//
//  Created by 陈双超 on 15/7/22.
//  Copyright (c) 2015年 陈双超. All rights reserved.
//

#import "CustomMode.h"
#import "MainCell.h"

#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
#define SCREEN_WIDTH    ([UIScreen mainScreen].bounds.size.width)

@interface CustomMode ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    
    NSMutableArray *selectedArr;//二级列表是否展开状态
    NSMutableArray *titleDataArray;//一级列表显示的数据
    NSUserDefaults *MyUserDefault;
}
@property (nonatomic, strong) NSArray *titles;
@end

@implementation CustomMode

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.titles = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23",@"24",@"25",@"26",@"27",@"28",@"29",@"30",@"31",@"32",@"33",@"34",@"35",@"36",@"37",@"38",@"39",@"40",@"41",@"42",@"43",@"44",@"45",@"46",@"47",@"48",@"49",@"50",@"51",@"52",@"53",@"54",@"55",@"56",@"57",@"58",@"59",@"60"];
    
    MyUserDefault=[NSUserDefaults standardUserDefaults];
    selectedArr = [[NSMutableArray alloc] init];
    
    titleDataArray=[[NSMutableArray alloc] initWithArray:[MyUserDefault objectForKey:@"titleDataArray"]];
    if (titleDataArray.count!=3) {
        [self initDataSource];
    }
    
    //tableView
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH,SCREEN_HEIGHT-64) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.bounces=NO;
    _tableView.scrollEnabled=NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor=[UIColor clearColor];
    
    [self.view addSubview:_tableView];
    
    
    
    [self initFooterView];
}
-(void)initFooterView{
    
    UIView *MyFooterView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 70)];
    
    UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
    button.frame=CGRectMake(20, 22, SCREEN_WIDTH-40, 48);
    button.backgroundColor=[UIColor colorWithRed:254.0/255.0 green:238.0/255.0 blue:53.0/255.0 alpha:1];
    [button addTarget:self action:@selector(ComfermAction) forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"OK" forState:UIControlStateNormal];
    [MyFooterView addSubview:button];
    
    _tableView.tableFooterView=MyFooterView;
}

-(void)ComfermAction{
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
    char strcommand[12]={};
    int allTime=0;
    for (int i=0; i<3; i++) {
        NSString *name=[[titleDataArray objectAtIndex:i] objectForKey:@"name"];
        int mode;
        int time=[[[titleDataArray objectAtIndex:i] objectForKey:@"time"] intValue];
        int strength=[[[titleDataArray objectAtIndex:i] objectForKey:@"strength"] intValue];
        allTime+=time;
        if([name isEqualToString:@"Stroke_Mode"]){
            NSLog(@"锤击模式");
            mode=0;
            strcommand[0]=mode;
            strcommand[1]=time;
            strcommand[2]=strength;
        }else if ([name isEqualToString:@"Massage_Mode"]){
            NSLog(@"按摩模式");
            mode=1;
            strcommand[3]=mode;
            strcommand[4]=time;
            strcommand[5]=strength;
        }else{
            NSLog(@"推拿模式");
            mode=2;
            strcommand[6]=mode;
            strcommand[7]=time;
            strcommand[8]=strength;
        }
    }
    strcommand[9]=allTime;
    strcommand[10]=0;
    strcommand[11]=1;
    NSData *cmdData = [NSData dataWithBytes:strcommand length:12];
//    NSLog(@"cmdData:%@",cmdData);
    NSDictionary *dic=[[NSDictionary alloc]initWithObjectsAndKeys:cmdData,@"tempData",[NSNumber numberWithInt:allTime],@"allTime",nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SendCustomDataNotification" object:nil userInfo:dic];
    
    //设置设备页面的图标为自定义图标
    NSDictionary *newdic=[[NSDictionary alloc]initWithObjectsAndKeys:[NSNumber numberWithInteger:3],@"ModeNumber",nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ModeNotification" object:nil userInfo:newdic];
    
}
- (IBAction)BackAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)initDataSource
{
    NSMutableDictionary *nameAndStateDic1 = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"Stroke_Mode",@"name",@"0",@"strength",@"0",@"time",nil];
   
    NSMutableDictionary *nameAndStateDic2 = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"Manipulation_Mode",@"name",@"0",@"strength",@"0",@"time",nil];
    
    NSMutableDictionary *nameAndStateDic3 = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"Massage_Mode",@"name",@"0",@"strength",@"0",@"time",nil];
    
    titleDataArray = [[NSMutableArray alloc] initWithObjects:nameAndStateDic1,nameAndStateDic2,nameAndStateDic3, nil];
}



#pragma mark----tableViewDelegate
//设置view，将替代titleForHeaderInSection方法
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100)];
    view.backgroundColor = [UIColor clearColor];
    
    //模式
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 32, 180, 20)];
    titleLabel.textColor=[UIColor whiteColor];
    titleLabel.text = NSLocalizedStringFromTable([[titleDataArray objectAtIndex:section] objectForKey:@"name"], @"Localizable", nil);
    titleLabel.font=[UIFont systemFontOfSize:14];
    [view addSubview:titleLabel];
    
    
    //是否展开的图片
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 34, 15, 15)];
    imageView.tag = 20000+section;
    //判断是不是选中状态
    NSString *string = [NSString stringWithFormat:@"%ld",(long)section];
    if ([selectedArr containsObject:string]) {
        imageView.image = [UIImage imageNamed:@"buddy_header_arrow_down@2x.png"];
        
        UIButton *UpButton = [UIButton buttonWithType:UIButtonTypeCustom];
        UpButton.frame = CGRectMake(SCREEN_WIDTH-100, 20, 40, 40);
        [UpButton setImage:[UIImage imageNamed:@"up.png"] forState:UIControlStateNormal];
        UpButton.tag = 200+section;
        [UpButton addTarget:self action:@selector(UpRowAction:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:UpButton];
        
        UIButton *DownButton = [UIButton buttonWithType:UIButtonTypeCustom];
        DownButton.frame = CGRectMake(SCREEN_WIDTH-60, 20, 40, 40);
        [DownButton setImage:[UIImage imageNamed:@"down.png"] forState:UIControlStateNormal];
        DownButton.tag = 200+section;
        [DownButton addTarget:self action:@selector(DownRowAction:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:DownButton];
        
    }else{
        imageView.image = [UIImage imageNamed:@"buddy_header_arrow_right@2x.png"];
    }
    [view addSubview:imageView];
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 10, 120, 50);
    button.tag = 100+section;
    [button addTarget:self action:@selector(OpenOrCloseRowAction:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button];
    
    
    UIView *yellowView=[[UIView alloc]initWithFrame:CGRectMake(0, 60, SCREEN_WIDTH, 40)];
    yellowView.backgroundColor=[UIColor colorWithRed:228.0/255.0 green:254.0/255.0 blue:168.0/255.0 alpha:1];
    [view addSubview:yellowView];
    
    
    UILabel *StrengthLabel=[[UILabel alloc]initWithFrame:CGRectMake(20, 70, 80, 20)];
    StrengthLabel.text=NSLocalizedStringFromTable(@"Strength", @"Localizable", nil);
    StrengthLabel.textAlignment=NSTextAlignmentRight;
    StrengthLabel.font=[UIFont systemFontOfSize:16];
    StrengthLabel.textColor=[UIColor colorWithRed:91.0/255.0 green:129.0/255.0 blue:23.0/255.0 alpha:1];
    [view addSubview:StrengthLabel];
    
    UILabel *StrengthNumber=[[UILabel alloc]initWithFrame:CGRectMake(100, 70, 20, 20)];
    StrengthNumber.text=[[titleDataArray objectAtIndex:section] objectForKey:@"strength"];
    StrengthNumber.font=[UIFont systemFontOfSize:16];
    StrengthNumber.textColor=[UIColor colorWithRed:91.0/255.0 green:129.0/255.0 blue:23.0/255.0 alpha:1];
    [view addSubview:StrengthNumber];
    
    UILabel *TimeLabel=[[UILabel alloc]initWithFrame:CGRectMake(160, 70, 50, 20)];
    TimeLabel.text=NSLocalizedStringFromTable(@"Time", @"Localizable", nil);
    TimeLabel.font=[UIFont systemFontOfSize:16];
    TimeLabel.textColor=[UIColor colorWithRed:91.0/255.0 green:129.0/255.0 blue:23.0/255.0 alpha:1];
    [view addSubview:TimeLabel];
    
    UILabel *TimeNumber=[[UILabel alloc]initWithFrame:CGRectMake(210, 70, 40, 20)];
    TimeNumber.text=[NSString stringWithFormat:@"%@m",[[titleDataArray objectAtIndex:section] objectForKey:@"time"]];
    TimeNumber.font=[UIFont systemFontOfSize:16];
    TimeNumber.textColor=[UIColor colorWithRed:91.0/255.0 green:129.0/255.0 blue:23.0/255.0 alpha:1];
    [view addSubview:TimeNumber];
    
    
    return view;
}

//返回几个表头
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

//每一个表头下返回几行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString *string = [NSString stringWithFormat:@"%ld",(long)section];
    
    if ([selectedArr containsObject:string]) {
        return 1;
    }
    return 0;
}

//设置表头的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 100;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //当前是第几个表头
    NSString *indexStr = [NSString stringWithFormat:@"%ld",(long)indexPath.section];
    static NSString *CellIdentifier = @"MainCell";
    MainCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[MainCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    if ([selectedArr containsObject:indexStr]) {
        
        cell.MyPickerView.delegate = self;
        cell.MyPickerView.dataSource = self;
        cell.MyPickerView.tag=[indexPath section];
        NSInteger timeNumber=[[[titleDataArray objectAtIndex:indexPath.section] objectForKey:@"time"] integerValue];
        if (timeNumber!=0) {
            timeNumber--;
        }
        [cell.MyPickerView scrollToItem:timeNumber animated:NO];
        
        cell.StrengthView.SlideDelegate=self;
        cell.StrengthView.tag=[indexPath section];
        [cell.StrengthView setNumber:[[[titleDataArray objectAtIndex:indexPath.section] objectForKey:@"strength"] intValue]];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_tableView deselectRowAtIndexPath:indexPath animated:NO];
}

-(void)OpenOrCloseRowAction:(UIButton *)sender
{
    NSString *string = [NSString stringWithFormat:@"%ld",(long)(sender.tag-100)];
    
    //数组selectedArr里面存的数据和表头想对应，方便以后做比较
    if ([selectedArr containsObject:string])
    {
        [selectedArr removeObject:string];
    }
    else
    {
        [selectedArr removeAllObjects];
        [selectedArr addObject:string];
    }
    
    [_tableView reloadData];
}
-(void)UpRowAction:(UIButton *)sender
{
    
    NSString *string = [NSString stringWithFormat:@"%ld",(long)(sender.tag-200)];
    if (sender.tag-200==0) {
        return;
    }
    [selectedArr removeObject:string];
    [selectedArr addObject:[NSString stringWithFormat:@"%ld",(long)sender.tag-200-1]];
    NSMutableDictionary *tempDic=[[NSMutableDictionary alloc] initWithDictionary:[titleDataArray objectAtIndex:sender.tag-200]];
    [titleDataArray replaceObjectAtIndex:sender.tag-200 withObject:[titleDataArray objectAtIndex:sender.tag-200-1]];
    [titleDataArray replaceObjectAtIndex:sender.tag-200-1 withObject:tempDic];
    [MyUserDefault setObject:titleDataArray forKey:@"titleDataArray"];
    
    [_tableView reloadData];
}

-(void)DownRowAction:(UIButton *)sender
{
    
    NSString *string = [NSString stringWithFormat:@"%ld",(long)sender.tag-200];
    if (sender.tag-200==2) {
        return;
    }
    [selectedArr removeObject:string];
    [selectedArr addObject:[NSString stringWithFormat:@"%ld",(long)sender.tag-200+1]];
    NSMutableDictionary *tempDic=[[NSMutableDictionary alloc] initWithDictionary:[titleDataArray objectAtIndex:sender.tag-200]];
    [titleDataArray replaceObjectAtIndex:sender.tag-200 withObject:[titleDataArray objectAtIndex:sender.tag-200+1]];
    [titleDataArray replaceObjectAtIndex:sender.tag-200+1 withObject:tempDic];
    [MyUserDefault setObject:titleDataArray forKey:@"titleDataArray"];
    [_tableView reloadData];
}
#pragma mark - AKPickerViewDataSource

- (NSUInteger)numberOfItemsInPickerView:(AKPickerView *)pickerView
{
    return [self.titles count];
}

/*
 * AKPickerView now support images!
 *
 * Please comment '-pickerView:titleForItem:' entirely
 * and uncomment '-pickerView:imageForItem:' to see how it works.
 *
 */

- (NSString *)pickerView:(AKPickerView *)pickerView titleForItem:(NSInteger)item
{
    return self.titles[item];
}

/*
 - (UIImage *)pickerView:(AKPickerView *)pickerView imageForItem:(NSInteger)item
 {
	return [UIImage imageNamed:self.titles[item]];
 }
 */

#pragma mark - AKPickerViewDelegate

- (void)pickerView:(AKPickerView *)pickerView didSelectItem:(NSInteger)item
{
//    NSLog(@"%@", self.titles[item]);
    
    NSMutableDictionary *tempDic=[[NSMutableDictionary alloc] initWithDictionary:[titleDataArray objectAtIndex:pickerView.tag]];
    [tempDic setObject:self.titles[item] forKey:@"time"];
    [titleDataArray replaceObjectAtIndex:pickerView.tag withObject:tempDic];
    [MyUserDefault setObject:titleDataArray forKey:@"titleDataArray"];
    [_tableView reloadData];
}


/*
 * Label Customization
 *
 * You can customize labels by their any properties (except font,)
 * and margin around text.
 * These methods are optional, and ignored when using images.
 *
 */

/*
 - (void)pickerView:(AKPickerView *)pickerView configureLabel:(UILabel *const)label forItem:(NSInteger)item
 {
	label.textColor = [UIColor lightGrayColor];
	label.highlightedTextColor = [UIColor whiteColor];
	label.backgroundColor = [UIColor colorWithHue:(float)item/(float)self.titles.count
 saturation:1.0
 brightness:1.0
 alpha:1.0];
 }
 */

/*
 - (CGSize)pickerView:(AKPickerView *)pickerView marginForItem:(NSInteger)item
 {
	return CGSizeMake(40, 20);
 }
 */

#pragma mark - UIScrollViewDelegate

/*
 * AKPickerViewDelegate inherits UIScrollViewDelegate.
 * You can use UIScrollViewDelegate methods
 * by simply setting pickerView's delegate.
 *
 */

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // Too noisy...
    // NSLog(@"%f", scrollView.contentOffset.x);
}


#pragma mark - CSCSlideDelegate

-(void)UpdateStrengthSlide:(int)value fromView:(UIView*)view{
    NSLog(@"view.tag:%ld",(long)view.tag);
    NSMutableDictionary *tempDic=[[NSMutableDictionary alloc] initWithDictionary:[titleDataArray objectAtIndex:view.tag]];
    [tempDic setObject:[NSString stringWithFormat:@"%d",value] forKey:@"strength"];
    [titleDataArray replaceObjectAtIndex:view.tag withObject:tempDic];
    [MyUserDefault setObject:titleDataArray forKey:@"titleDataArray"];
    [_tableView reloadData];
}

@end
