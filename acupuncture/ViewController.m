//
//  ViewController.m
//  acupuncture
//
//  Created by 陈双超 on 15/5/12.
//  Copyright (c) 2015年 陈双超. All rights reserved.
//

#import "ViewController.h"
#import "GuidePageViewController.h"
#import "SDImageCache.h"
#import "MYCell.h"
#import "PopupView.h"


#define ScreenHeight ([UIScreen mainScreen].bounds.size.height)
#define ScreenWidth ([UIScreen mainScreen].bounds.size.width)

@interface ViewController (){
    NSMutableArray *dataArray;//记录发现的设备
    NSMutableArray *DeviceToBle;//设备的对应关系
    NSUserDefaults *MyUserDefault;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _label.numberOfLines=0;
    MyUserDefault=[NSUserDefaults standardUserDefaults];
    DeviceToBle=[[NSMutableArray alloc] initWithArray:[MyUserDefault objectForKey:@"DeviceToBle"]];
    if (DeviceToBle.count<3) {
        for (int i=0; i<3; i++) {
            NSMutableDictionary *dic=[[NSMutableDictionary alloc]init];
            [DeviceToBle addObject:dic];
        }
        [MyUserDefault setObject:DeviceToBle forKey:@"DeviceToBle"];
    }
    
    dataArray=[[NSMutableArray alloc] init];
    
    self.cbCentralMgr = ((AppDelegate *)[[UIApplication sharedApplication] delegate]).cbCentralMgr;
    self.cbCentralMgr.delegate=self;
    
    [self initFooterView];
    
    [self seachAction];
    
    [GuidePageViewController show];
    
    
}
-(void)viewWillAppear:(BOOL)animated{
    DeviceToBle=[NSMutableArray arrayWithArray:[MyUserDefault objectForKey:@"DeviceToBle"]];
    [_MyTableView reloadData];
}

-(void)initFooterView{
    
    UIView *MyFooterView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 72)];
    UIImageView *lineImage = [[UIImageView alloc] initWithFrame:CGRectMake(16, 0, ScreenWidth-16, 1)];
    lineImage.image = [UIImage imageNamed:@"line.png"];
    [MyFooterView addSubview:lineImage];
    
    UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
    button.frame=CGRectMake(0, 0, ScreenWidth, 72);
    [button addTarget:self action:@selector(AddCellAction) forControlEvents:UIControlEventTouchUpInside];
    
    [button setImage:[UIImage imageNamed:@"ic_input_add"] forState:UIControlStateNormal];
    button.contentEdgeInsets=UIEdgeInsetsMake(10,10,10,ScreenWidth-80);
    [MyFooterView addSubview:button];
    _MyTableView.tableFooterView=MyFooterView;
}

-(void)seachAction{
//    NSLog(@"搜索");
    self.cbCentralMgr.delegate=self;
    [self.cbCentralMgr stopScan];
    
    if (dataArray.count) {
        [dataArray removeAllObjects];
    }
    
    NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:NO],CBCentralManagerScanOptionAllowDuplicatesKey, nil];
    [self.cbCentralMgr scanForPeripheralsWithServices:nil options:dic];
}


-(CBPeripheral *)UUIDToPeripheral:(NSString *)uuidStr{
    for (int i=0; i<[dataArray count]; i++) {
        if([uuidStr isEqualToString:[((CBPeripheral*)[dataArray objectAtIndex:i]).identifier UUIDString]]){
            return (CBPeripheral*)[dataArray objectAtIndex:i];
        }
    }
    return nil;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSNumber *SettingType = (NSNumber *)sender;
    if ([segue.identifier isEqualToString:@"deviceIdentifier"]) {
        UIViewController *destination = segue.destinationViewController;
        [destination setValue:sender forKey:@"deviceType"];
        [destination setValue:[self UUIDToPeripheral:[[DeviceToBle objectAtIndex:[SettingType integerValue]] objectForKey:@"UUIDString"]] forKey:@"peripheralOpration"];
    }
}
#pragma mark - TableviewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(DeviceToBle.count<3){
        return 3;
    }
    return DeviceToBle.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"MYCell";
    MYCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[MYCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    NSMutableDictionary *MyDic=[DeviceToBle objectAtIndex:indexPath.row];
    if ([MyDic objectForKey:@"UUIDString"]) {
//        cell.MyDetailLabel.text=[MyDic objectForKey:@"UUIDString"];
        cell.MyDetailLabel.text=[self UUIDToPeripheral:[[DeviceToBle objectAtIndex:indexPath.row] objectForKey:@"UUIDString"]].state!=2?NSLocalizedStringFromTable(@"Unpaired", @"Localizable", nil):NSLocalizedStringFromTable(@"Paired", @"Localizable", nil);
    }else{
        cell.MyDetailLabel.text=NSLocalizedStringFromTable(@"Unpaired", @"Localizable", nil);
    }
    if([MyDic objectForKey:@"name"]){
        [cell.MyNameLabel setText:[NSString stringWithFormat:@"%@",[MyDic objectForKey:@"name"]]];
    }else{
        cell.MyNameLabel.text=NSLocalizedStringFromTable(@"deviceName", @"Localizable", nil);
    }
    if([MyDic objectForKey:@"image"]){
        UIImage *myCachedImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:[MyDic objectForKey:@"image"]];
        if (myCachedImage) {
            [cell.MyImage setImage:myCachedImage];
        }
    }else{
        [cell.MyImage setImage:[UIImage imageNamed:@"device.png"]];
    }
    UILongPressGestureRecognizer *longPressAction=[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressAction:)];
    [cell addGestureRecognizer:longPressAction];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([[DeviceToBle objectAtIndex:indexPath.row] objectForKey:@"UUIDString"])
    {
        if ([self UUIDToPeripheral:[[DeviceToBle objectAtIndex:indexPath.row] objectForKey:@"UUIDString"]].state==2) {
            [self performSegueWithIdentifier:@"deviceIdentifier" sender:[NSNumber numberWithInteger:indexPath.row]];
        }else{
            if([self UUIDToPeripheral:[[DeviceToBle objectAtIndex:0] objectForKey:@"UUIDString"]]){
                [self.cbCentralMgr connectPeripheral:[self UUIDToPeripheral:[[DeviceToBle objectAtIndex:0] objectForKey:@"UUIDString"]] options:[NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:CBConnectPeripheralOptionNotifyOnDisconnectionKey]];
            }else{
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:NSLocalizedStringFromTable(@"Connect_Fail_ToDevice", @"Localizable", nil) delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                [alert show];
            }
        }
    }else{
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:NSLocalizedStringFromTable(@"No_Binding_Equipment", @"Localizable", nil) delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }
}

-(void)longPressAction:(UILongPressGestureRecognizer *)gesture{
    
    if(gesture.state == UIGestureRecognizerStateBegan)
    {
        CGPoint point = [gesture locationInView:_MyTableView];
        NSIndexPath* indexP = [_MyTableView indexPathForRowAtPoint:point];
        UIActionSheet *myActionSheet=[[UIActionSheet alloc]initWithTitle:NSLocalizedStringFromTable(@"Want_ToDo", @"Localizable", nil) delegate:self cancelButtonTitle:NSLocalizedStringFromTable(@"Cancel", @"Localizable", nil) destructiveButtonTitle:nil otherButtonTitles:NSLocalizedStringFromTable(@"Debinding", @"Localizable", nil),NSLocalizedStringFromTable(@"Delete_the_bank", @"Localizable", nil), nil];
        myActionSheet.tag=indexP.row;
        [myActionSheet showInView:_MyTableView];
    }
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSLog(@"actionSheet.tag:%ld",(long)actionSheet.tag);
    if (buttonIndex==0) {//解除绑定
        //第一步是断开蓝牙管理中心连接，第二步是否解除对应关系
        CBPeripheral* MyPeripheral=[self UUIDToPeripheral:[[DeviceToBle objectAtIndex:actionSheet.tag] objectForKey:@"UUIDString"]];
        if(MyPeripheral.state==2){
            [self.cbCentralMgr cancelPeripheralConnection:MyPeripheral];
        }
        
        NSMutableDictionary *dic=[[NSMutableDictionary alloc]init];
        [DeviceToBle replaceObjectAtIndex:actionSheet.tag withObject:dic];
        [MyUserDefault setObject:DeviceToBle forKey:@"DeviceToBle"];
        DeviceToBle=[NSMutableArray arrayWithArray:[MyUserDefault objectForKey:@"DeviceToBle"]];
        NSLog(@"%@",DeviceToBle);
        [_MyTableView reloadData];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSLog(@"zhixing");
            self.cbCentralMgr.delegate=self;
            [self.cbCentralMgr stopScan];
            
            if (dataArray.count) {
                [dataArray removeObject:MyPeripheral];
            }
            
            NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:NO],CBCentralManagerScanOptionAllowDuplicatesKey, nil];
            [self.cbCentralMgr scanForPeripheralsWithServices:nil options:dic];
        });
        
        
    }else if(buttonIndex==1){//删除本行
        //第一步是在蓝牙管理中心断开连接，第二步是删除本地数据中的那一行，第三步是否与当前设备列表中未绑定的行绑定。
        CBPeripheral* MyPeripheral=[self UUIDToPeripheral:[[DeviceToBle objectAtIndex:actionSheet.tag] objectForKey:@"UUIDString"]];
        if(MyPeripheral.state==2){
            [self.cbCentralMgr cancelPeripheralConnection:MyPeripheral];
        }
        
        if (DeviceToBle.count<=3) {
            PopupView  *popUpView= [[PopupView alloc]initWithFrame:CGRectMake(100, 240, 0, 0)];
            popUpView.ParentView = self.view;
            [popUpView setText: NSLocalizedStringFromTable(@"Delete_Failed", @"Localizable", nil)];
            [self.view addSubview:popUpView];
        }else{
            [DeviceToBle removeObjectAtIndex:actionSheet.tag];
            [MyUserDefault setObject:DeviceToBle forKey:@"DeviceToBle"];
            [_MyTableView reloadData];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.cbCentralMgr.delegate=self;
                [self.cbCentralMgr stopScan];
                
                if (dataArray.count) {
                    [dataArray removeObject:MyPeripheral];
                }
                
                NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:NO],CBCentralManagerScanOptionAllowDuplicatesKey, nil];
                [self.cbCentralMgr scanForPeripheralsWithServices:nil options:dic];
            });
        }
        
    }
}


-(void)AddCellAction{
    NSMutableDictionary *dic=[[NSMutableDictionary alloc]init];
    [DeviceToBle addObject:dic];
    [MyUserDefault setObject:DeviceToBle forKey:@"DeviceToBle"];
    [_MyTableView reloadData];
}
#pragma mark - Navigation
- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    switch (central.state) {
        case CBCentralManagerStatePoweredOn:
//            NSLog(@"蓝牙已打开");
            [self seachAction];
            break;
        default:
//            NSLog(@"蓝牙状态未知");
            break;
    }
}


- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{
//    NSLog(@"能发现设备：%@",peripheral.name);
    
    if ([peripheral.name isEqualToString:@"JX_Massager"]) {
        //需要筛选已存在的UUID
        for (int i=0; i<[dataArray count]; i++) {
            if(peripheral==(CBPeripheral*)[dataArray objectAtIndex:i]){
                NSLog(@"已存在的UUID");
                [self.cbCentralMgr connectPeripheral:peripheral options:[NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:CBConnectPeripheralOptionNotifyOnDisconnectionKey]];
                return;
            }
        }
        [dataArray addObject:peripheral];
        for (int i=0; i<[DeviceToBle count]; i++) {//已连过的设备中是否有这个设备，有则直接连接
            if([[peripheral.identifier UUIDString] isEqualToString:[[DeviceToBle objectAtIndex:i] objectForKey:@"UUIDString"]]){
//                NSLog(@"DeviceToBle已存在的UUID，连接");
                PopupView  *popUpView= [[PopupView alloc]initWithFrame:CGRectMake(100, 240, 0, 0)];
                popUpView.ParentView = self.view;
                [popUpView setText: NSLocalizedStringFromTable(@"connecting", @"Localizable", nil)];
                [self.view addSubview:popUpView];
                [self.cbCentralMgr connectPeripheral:peripheral options:[NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:CBConnectPeripheralOptionNotifyOnDisconnectionKey]];
                return;
            }
        }
        for (int i=0; i<[DeviceToBle count]; i++) {//目前设备列表中是否有空设备。
            if(![[DeviceToBle objectAtIndex:i] objectForKey:@"UUIDString"]){
                NSMutableDictionary *dic=[[NSMutableDictionary alloc]initWithObjectsAndKeys:[peripheral.identifier UUIDString],@"UUIDString",peripheral.name,@"name",nil];
                [DeviceToBle replaceObjectAtIndex:i withObject:dic];
                [MyUserDefault setObject:DeviceToBle forKey:@"DeviceToBle"];
                [_MyTableView reloadData];
                [self.cbCentralMgr connectPeripheral:peripheral options:[NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:CBConnectPeripheralOptionNotifyOnDisconnectionKey]];
                break;
            }
        }
    }else{
//        NSLog(@"不是针灸仪设备");
    }
}
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    NSLog(@"--didConnectPeripheral--") ;
    peripheral.delegate = self;
    [peripheral discoverServices:nil];
    [self.MyTableView reloadData];
}

- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    NSLog(@"设备断开连接");
    [self.MyTableView reloadData];
    
    self.cbCentralMgr.delegate=self;
    [self.cbCentralMgr stopScan];
    
    NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:NO],CBCentralManagerScanOptionAllowDuplicatesKey, nil];
    [self.cbCentralMgr scanForPeripheralsWithServices:nil options:dic];
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
    for (CBCharacteristic * characteristic in service.characteristics) {
        [peripheral setNotifyValue:YES forCharacteristic:characteristic];
    }
}

-(void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error{
    
    NSLog(@"收到来自设备的通知-----:%@",characteristic.value);
    
    NSString *str=[[NSString alloc]initWithData:characteristic.value encoding:NSUTF8StringEncoding];
    NSLog(@"特性的值：%@",str);
    
    NSDictionary *dic=[[NSDictionary alloc]initWithObjectsAndKeys:characteristic.value,@"ElectricNumber",nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ElectricValueNotification" object:nil userInfo:dic];
}

- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
//    NSLog(@"写数据");
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    for (CBService* service in peripheral.services){
        [peripheral discoverCharacteristics:nil forService:service];
        [peripheral discoverIncludedServices:nil forService:service];
    }
}



@end



