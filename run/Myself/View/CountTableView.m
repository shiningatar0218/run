//
//  CountTableView.m
//  run1.2
//
//  Created by runner on 15/1/26.
//  Copyright (c) 2015年 runner. All rights reserved.
//

#import "CountTableView.h"
#import "define.h"

@interface CountTableView ()

@property (nonatomic, strong) NSArray *keys;
@property (nonatomic, strong) NSMutableDictionary *dataDic;
@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) NSMutableDictionary *titleDic;

@end

@implementation CountTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    self = [super initWithFrame:frame style:style];
    if (self) {
//        self.layer.borderWidth = 1;
//        self.layer.borderColor = BackGroundColor.CGColor;
//        self.separatorColor = BackGroundColor;
        
        self.delegate = self;
        self.dataSource = self;
        
        
    }
    return self;
}

- (void)loadData {
    
}

- (UserStatistics *)model {
    if (!_model) {
        _model = [[UserStatistics alloc] init];
    }
    return _model;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return self.titleArray[section];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.titleArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataDic[self.titleArray[section]] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdenty = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdenty];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdenty];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        cell.detailTextLabel.textColor = [UIColor lightTextColor];
//        cell.layer.borderWidth = 1;
//        cell.layer.borderColor = layColor;
    }
    NSArray *keys = self.dataDic[self.titleArray[indexPath.section]];
    NSString *key = keys[indexPath.row];
    cell.textLabel.text = self.titleDic[key];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",[self.model valueForKey:key]];
    return cell;
}

- (NSMutableDictionary *)dataDic {
    if (!_dataDic) {
        _dataDic = [[NSMutableDictionary alloc] initWithObjects:self.keys forKeys:self.titleArray];
    }
    return _dataDic;
}

- (NSDictionary *)titleDic {
    if (!_titleDic) {
        NSArray *titles = @[@"周跑次数",@"周跑距离",@"周跑时间",@"跑步距离",@"跑步时间",@"平均海拔",@"跑步次数",@"平均配速",@"距离"];
        NSArray *keys = @[@"week_activity_count",
                          @"week_activity_distance",
                          @"week_activity_time",
                          @"year_activity_distance",
                          @"year_activity_time",
                          @"year_average_height",
                          @"year_activity_count",
                          @"year_average_pace",
                          @"total_distance"];
        _titleDic = [[NSMutableDictionary alloc] initWithObjects:titles forKeys:keys];
    }
    return _titleDic;
}

- (NSArray *)keys {
    if (!_keys) {
        NSArray *key1 = @[@"week_activity_count",
                          @"week_activity_distance",
                          @"week_activity_time"];
        
        NSArray *key2 = @[@"year_activity_distance",
                          @"year_activity_time",
                          @"year_average_height",
                          @"year_activity_count",
                          @"year_average_pace"];
        
        NSArray *key3 = @[@"total_distance"];
        _keys = [[NSArray alloc] initWithObjects:key1,key2,key3, nil];
    }
    return _keys;
}

- (NSArray *)titleArray {
    if (!_titleArray) {
        _titleArray = @[@"常规",@"今年",@"总共"];
    }
    return _titleArray;
}



@end
