//
//  ReateTableViewController.m
//  run1.2
//
//  Created by runner on 15/1/12.
//  Copyright (c) 2015年 runner. All rights reserved.
//

#import "ReateTableViewController.h"
#import "CustomButton.h"
#import "WeakTableViewCell.h"
#import "NSMutableArray+addOtherObject.h"
@interface ReateTableViewController ()
{
    NSMutableArray *_weakCountArray;
}

@property (nonatomic, retain) NSMutableArray *weakArray;
@property (nonatomic, retain) NSMutableArray *selectedArray;

@end

@implementation ReateTableViewController

- (instancetype)initWithSelectWeak:(NSMutableArray *)selectWeak Didselected:(void (^)(NSMutableArray *selectWeak))completion {
    self = [super init];
    if (self) {
        
        if (completion) {
            self.completion = completion;
        }
        self.title = @"重复";
        self.tableView.allowsMultipleSelection = YES;
        self.tableView.allowsMultipleSelectionDuringEditing = YES;
        self.selectedArray = selectWeak;
    }
    
    return self;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.tableView reloadData];
    [self.selectedArray sortWeakArray];
    self.completion(self.selectedArray);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(backToPop)];
    
    _weakCountArray = [[NSMutableArray alloc] initWithCapacity:0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)backToPop {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -- UITable]ViewDelegate----
- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *weakText = @"";
    if (((WeakTableViewCell *)cell).selectCell.hidden == NO) {
        [self.selectedArray addOtherObject:self.weakArray[indexPath.row]];
    }
    for (NSString *text in self.selectedArray) {
        if ([text isEqualToString:self.weakArray[indexPath.row]]) {
            if (((WeakTableViewCell *)cell).selectCell.hidden){
                weakText = text;
            }
        }
    }
    [self.selectedArray removeObject:weakText];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.weakArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"weakCell";
    WeakTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"weakCell"];
    if (!cell) {
        cell = [[WeakTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.textLabel.text = self.weakArray[indexPath.row];
    
    if (self.selectedArray.count > 0) {
        for (NSString *text in self.selectedArray) {
            if ([text isEqualToString:self.weakArray[indexPath.row]]) {
                cell.selectCell.hidden = YES;
            }
        }
    }
    
    return cell;
}

- (NSMutableArray *)weakArray {
    if (!_weakArray) {
        _weakArray = [[NSMutableArray alloc] initWithObjects:@"每周一",@"每周二",@"每周三",@"每周四",@"每周五",@"每周六",@"每周日", nil];
    }
    return _weakArray;
}

- (NSMutableArray *)selectedArray {
    if (!_selectedArray) {
        _selectedArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _selectedArray;
}

@end
