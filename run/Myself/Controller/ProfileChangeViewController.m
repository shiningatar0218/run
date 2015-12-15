//
//  ProfileChangeViewController.m
//  run1.2
//
//  Created by runner on 15/1/23.
//  Copyright (c) 2015年 runner. All rights reserved.
//

#import "ProfileChangeViewController.h"
#import "ProfileCell.h"
#import "CustomTextField.h"
#import "define.h"
#import "DataModel.h"
#import "CoreData+MagicalRecord.h"
#import "CoreDataManager.h"

@interface ProfileChangeViewController ()<UITextFieldDelegate>

@property (nonatomic, retain) NSArray *keys;
@property (nonatomic, retain) UserProfile *profileModel;

@property (nonatomic, retain) NSMutableDictionary *parma;

@end

@implementation ProfileChangeViewController

- (instancetype)init{
    self = [super init];
    if (self) {
        self.title = @"我";
        self.view = self.tableView;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"储存" style:UIBarButtonItemStylePlain target:self action:@selector(saveChange)];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
    
    [self.navigationItem.leftBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                  [UIColor whiteColor],NSForegroundColorAttributeName,
                                                                   [UIColor whiteColor],NSUnderlineColorAttributeName,nil] forState:UIControlStateNormal];
}

- (void)saveChange {
    
    for (NSString *key in self.keys) {
        [self.parma setObject:[self.profileModel valueForKey:key] forKey:key];
    }
    
    [self.parma setObject:self.profileModel.family_name forKey:@"family_name"];
    [self.parma setObject:self.profileModel.first_name forKey:@"first_name"];
    
    [DATAMODEL updateUserProfileWithPama:self.parma Completion:^(BOOL sucessful) {
        if (sucessful) {
            [CoreDataManager saveDataToPersistentStoreWithEntity:self.profileModel Completion:^(BOOL contextDidSave, NSError *error) {
                if (contextDidSave) {
                    NSLog(@"profile update");
                }
            }];
        }
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdenty = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdenty];
    
    if (indexPath.row == 0) {
        
        __weak ProfileCell *cell = [tableView dequeueReusableCellWithIdentifier:@"nameCell"];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"ProfileCell" owner:nil options:nil] firstObject];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
        }
        [cell awakeFromNibWithModel:self.profileModel endEditing:^{
            self.profileModel.first_name = cell.first_name.text;
            self.profileModel.family_name = cell.family_name.text;
        }];
        
        return cell;
    }
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdenty];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        CustomTextField *textField = [[CustomTextField alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width-50, cell.frame.size.height) title:nil titleLenth:0.0 endEding:^(NSString *text) {
            
        }];
        textField.tag = 4001;
        textField.textField.textAlignment = NSTextAlignmentRight;
        textField.textField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        [textField didBeginEditing:^(id sender) {
            textField.textField.text = @"";
        }];
        [textField didEndEditing:^(NSString *text) {
            [self.profileModel setValue:text forKey:self.keys[indexPath.row - 1]];
            [self.parma setValue:text forKey:self.keys[indexPath.row - 1]];
            textField.textField.text = [self.profileModel valueForKey:self.keys[indexPath.row - 1]];
        }];
        textField.textField.text = [self.profileModel valueForKey:self.keys[indexPath.row - 1]];
        [cell addSubview:textField];
    }
    cell.textLabel.text = self.dataArray[indexPath.row-1];

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 80.0;
    }
    return 44.0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count+1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView endEditing:YES];
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.sectionHeaderHeight = 10.0;
    }
    return _tableView;
}

- (NSArray *)dataArray {
    if (!_dataArray) {
        _dataArray = @[@"生日",@"性别",@"体重",@"邮箱",@"街道",@"城市",@"主要运动"];
    }
    return _dataArray;
}

- (NSArray *)keys {
    if (!_keys) {
        _keys = @[@"birthday",@"gender",@"weight",@"email",@"street",@"city_id",@"main_sport"];
    }
    return _keys;
}

- (NSMutableDictionary *)parma {
    if (!_parma) {
        _parma = [NSMutableDictionary dictionaryWithCapacity:0];
    }
    
    return _parma;
}

- (UserProfile *)profileModel {
    
    if (!_profileModel) {
        
        NSArray *array = [UserProfile MR_findAllWithPredicate:[NSPredicate predicateWithFormat:@"user_id IN %@",@[DATAMODEL.userId]]];
        if (array.count > 0) {
            _profileModel = [array lastObject];
        }
    }
    return _profileModel;
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

@end
