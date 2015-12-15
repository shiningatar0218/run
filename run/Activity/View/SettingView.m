//
//  SettingView.m
//  run
//
//  Created by runner on 15/3/5.
//  Copyright (c) 2015年 runner. All rights reserved.
//

#import "SettingView.h"
#import "CustomSwitch.h"
#import "define.h"

@interface SettingView ()<UITableViewDataSource,UITableViewDelegate>
{
    
}

@property (nonatomic, retain) NSArray *setData;
@property (nonatomic, retain) NSArray *detailData;

@end

@implementation SettingView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    self = [super initWithFrame:frame style:UITableViewStylePlain];
    if (self) {
        self.dataSource = self;
        self.delegate = self;
        
        self.scrollEnabled = NO;
    }
    
    return self;
}

- (void)didChangeValueForSettingWithSettingType:(SettingType)type userInfo:(BOOL)on{
    switch (type) {
        case SoundServers:
            
            break;
            
        case ShareServers:
            
            break;
            
        case SpeedPKSearvers:
            [[NSNotificationCenter defaultCenter] postNotificationName:SPEED_PK_SWITCH object:nil userInfo:@{SPEED_PK_SWITCH: [NSNumber numberWithBool:on]}];
            
            break;
        default:
            break;
    }

}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdenty = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdenty];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdenty];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.accessoryView = [[CustomSwitch alloc] initWithValueChanged:^(BOOL on) {
            [self didChangeValueForSettingWithSettingType:indexPath.row userInfo:on];
        }];
    }
    
    cell.textLabel.text = self.setData[indexPath.row];
    cell.detailTextLabel.text = self.detailData[indexPath.row];
    
    
    return cell;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.setData.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.frame.size.height/3.0 - 10;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"运动设置";
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30.0;
}


- (NSArray *)setData {
    if (!_setData) {
        _setData = @[@"语音提示",@"刺激好友",@"显示配速PK"];
    }
    return _setData;
}

- (NSArray *)detailData {
    if (!_detailData) {
        _detailData = @[@"最近一公里的配速及配速PK语音播报",@"将我的训练记录分享给我的好友",@"和同任务的跑友PK配速"];
    }
    return _detailData;
}

@end
