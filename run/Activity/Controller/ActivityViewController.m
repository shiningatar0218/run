//
//  ActivityViewController.m
//  run1.2
//
//  Created by runner on 14/12/31.
//  Copyright (c) 2014年 runner. All rights reserved.
//

#import "ActivityViewController.h"
#import "DZNSegmentedControl.h"
#import "define.h"
#import "RecordView.h"
#import "PieceWiseView.h"
#import "MapView.h"
#import "SaveActivityViewController.h"
#import "TSActionSheet.h"
#import "TSPopoverController.h"
#import "ActivitySettingView.h"
#import "CoreDataManager.h"
#import "Activity.h"
#import "DataModel.h"
#import "SettingView.h"

@interface ActivityViewController ()<DZNSegmentedControlDelegate,UIScrollViewDelegate,UIActionSheetDelegate,RecordDelegate,SaveActivityViewControllerDelegate>
{
    UIScrollView    *_scrollerView;
    UIView          *_currentView;
    
    RecordView      *_recordView;
    PieceWiseView   *_pieceWiseView;
    MapView         *_mapView;
    //MAmapView       *_mapView;
    UIButton  *_leftButton;
}

@property (nonatomic, strong)NSArray *headArray;
@property (nonatomic, strong)DZNSegmentedControl *segmentControl;
@property (nonatomic, strong)UIView *headView;
@end

@implementation ActivityViewController

- (instancetype)init {
    self = [super init];
    if (self) {

    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (void)dealloc {
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:self.headView];
    _headArray = @[@"记录",@"分段",@"地图"];
    [self.view addSubview:self.segmentControl];
    [self initUserInterface];
}

- (void)initUserInterface {
    _scrollerView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(_segmentControl.frame), self.view.frame.size.width, self.view.bounds.size.height-CGRectGetHeight(_segmentControl.bounds)-self.tabBarController.tabBar.frame.size.height - 64)];
    _scrollerView.delegate = self;
    _scrollerView.pagingEnabled = YES;
    _scrollerView.contentSize = CGSizeMake(self.view.frame.size.width*3, _scrollerView.frame.size.height);

    _scrollerView.bounces = NO;
    [self.view addSubview:_scrollerView];
    
    _recordView = [[RecordView alloc] initWithFrame:CGRectMake(0, 2, _scrollerView.frame.size.width, _scrollerView.frame.size.height) loadNibName:@"RecordedView" woner:self];
    _recordView.backView.center = CGPointMake(self.view.center.x, _recordView.backView.center.y);
    _recordView.delegate = self;
    
    _pieceWiseView = [[PieceWiseView alloc] initWithFrame:CGRectMake(_scrollerView.frame.size.width, 2, _scrollerView.frame.size.width, _scrollerView.frame.size.height)];
    
    _mapView = [[MapView alloc] initWithFrame:CGRectMake(_scrollerView.frame.size.width*2, 2,_scrollerView.frame.size.width,_scrollerView.frame.size.height)];
    
    
    
    UIView *onMapView = [[UIView alloc] initWithFrame:CGRectMake(_mapView.frame.origin.x, 2, 5, _scrollerView.frame.size.height)];
    onMapView.alpha = 0.35;
    onMapView.backgroundColor = [UIColor whiteColor];
    
    [_scrollerView addSubview:_recordView];
    [_scrollerView addSubview:_pieceWiseView];
    [_scrollerView addSubview:_mapView];
    [_scrollerView addSubview:onMapView];
    
#pragma mark -- UINavifation
    
    UIButton *rightBar = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 64)];
    [rightBar setImage:[UIImage imageNamed:@"activity_setting.png"] forState:UIControlStateNormal];
    
    [rightBar addTarget:self action:@selector(settingView:forEvent:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBar];
    
    UIButton *leftBar = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 64)];
    [leftBar setImage:[UIImage imageNamed:@"run.png"] forState:UIControlStateNormal];
    [leftBar setImage:[UIImage imageNamed:@"run.png"] forState:UIControlStateHighlighted];
    [leftBar addTarget:self action:@selector(selectActivityType:forEvent:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBar];
    
}

#pragma mark -- 头部导航栏

- (UIView *)headView {
    if (!_headView) {
        _headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 30)];
    }
    return _headView;
}

- (DZNSegmentedControl *)segmentControl {
    if (!_segmentControl) {
        _segmentControl = [[DZNSegmentedControl alloc] initWithItems:self.headArray];
        _segmentControl.frame = CGRectMake(0, 0, self.view.frame.size.width, 40);
        _segmentControl.delegate = self;
        _segmentControl.selectedSegmentIndex = 0;
        _segmentControl.bouncySelectionIndicator = YES;
        
        _segmentControl.showsGroupingSeparators = YES;
        _segmentControl.inverseTitles = YES;
        _segmentControl.backgroundColor = NaVBarColor;
        _segmentControl.tintColor = [UIColor whiteColor];
        _segmentControl.hairlineColor = RGBCOLOR(225, 225, 225);
        _segmentControl.showsCount = NO;
        [_segmentControl setTitleColor:[UIColor whiteColor] forState:_segmentControl.selectedSegmentIndex]   ;
        //        _segmentControl.autoAdjustSelectionIndicatorWidth = NO;
        //        _segmentControl.selectionIndicatorHeight = _segmentControl.intrinsicContentSize.height;
        //        _segmentControl.adjustsFontSizeToFitWidth = YES;
        [_segmentControl addTarget:self action:@selector(didSelectedSegment:) forControlEvents:UIControlEventValueChanged];
    }
    return _segmentControl;
}
//选中导航栏按钮
- (void)didSelectedSegment:(DZNSegmentedControl *)segmentControl {
    [_scrollerView setContentOffset:CGPointMake(segmentControl.selectedSegmentIndex*_scrollerView.frame.size.width, 0) animated:YES];
    if (segmentControl.selectedSegmentIndex == 2) {
        [_mapView startUpDate];
    }
}

#pragma mark -- UIBarPositioningDelegate
- (UIBarPosition)positionForBar:(id<UIBarPositioning>)bar {
    return UIBarPositionBottom;
}

#pragma mark -- UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    int index = scrollView.contentOffset.x/scrollView.frame.size.width;
    self.segmentControl.selectedSegmentIndex = index;
   
}
#pragma mark -- 保存记录
- (void)saveActivity {
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"放弃" destructiveButtonTitle:nil otherButtonTitles:@"储存", nil];
    [sheet addButtonWithTitle:@"继续"];
    [sheet showInView:self.view];
}
#pragma mark -- UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0:
            //save activity
        {
            self.hidesBottomBarWhenPushed = YES;
            SaveActivityViewController *saveActivityVC = [[SaveActivityViewController alloc] initWithNibName:@"SaveActivityViewController" bundle:nil];
            saveActivityVC.delegate = self;
            [self.navigationController pushViewController:saveActivityVC animated:YES];
            self.hidesBottomBarWhenPushed = NO;
        }
            break;
        case 1:
            //give up
            [self dealWithActivity:ActivityStop];
            NSLog(@"give up");
            break;
        case 2:
            //going on
            [self dealWithActivity:ActivityStart];
            NSLog(@"going on");
            
            break;
        default:
            break;
    }
    
}

#pragma mark --select ActivityType--骑车、跑步
- (void)selectActivityType:(id)sender forEvent:(UIEvent*)event {
    
    __block UIButton *barItem = sender;
    
    UIView *selectView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 60, 80)];
    TSPopoverController *popoverController = [[TSPopoverController alloc] initWithView:selectView];
    popoverController.popoverBaseColor = RGBACOLOR(230, 230, 230, 1);
    popoverController.popoverGradient= NO;
    //popoverController.arrowPosition = TSPopoverArrowPositionHorizontal;
    [popoverController showPopoverWithTouch:event];
    CustomButton *runBtn = [[CustomButton alloc] initWithFrame:CGRectMake(0, 0, 60, 40) NormalImage:@"_run.png" selectImage:@"s_run.png" whenTouchUpInside:^(id sender){
        [DataModel getInstance].sport = run;
        [barItem setImage:[UIImage imageNamed:@"run.png"] forState:UIControlStateNormal];
        [barItem setImage:[UIImage imageNamed:@"run.png"] forState:UIControlStateHighlighted];
        [popoverController dismissPopoverAnimatd:YES];
    }];
    
    CustomButton *raidBtn = [[CustomButton alloc] initWithFrame:CGRectMake(0, 40, 60, 40) NormalImage:@"_raid.png" selectImage:@"s_raid.png" whenTouchUpInside:^(id sender){
        [DataModel getInstance].sport = ride;
        [barItem setImage:[UIImage imageNamed:@"raid.png"] forState:UIControlStateNormal];
        [barItem setImage:[UIImage imageNamed:@"raid.png"] forState:UIControlStateHighlighted];
        [popoverController dismissPopoverAnimatd:YES];
    }];
    
    raidBtn.selected = NO;
    runBtn.selected = YES;
    if ([DataModel getInstance].sport == ride) {
        raidBtn.selected = YES;
        runBtn.selected = NO;
    }
    [raidBtn setImage:[UIImage imageNamed:@"s_raid.png"] forState:UIControlStateSelected];
    [runBtn setImage:[UIImage imageNamed:@"s_run.png"] forState:UIControlStateSelected];
    
    [selectView addSubview:runBtn];
    [selectView addSubview:raidBtn];
}

#pragma mark -- settingView
- (void)settingView:(id)sender forEvent:(UIEvent *)event {
    
    SettingView *settingView = [[SettingView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 200) style:UITableViewStyleGrouped];
    TSPopoverController *popoverController = [[TSPopoverController alloc] initWithView:settingView];
    //popoverController.titleText = @"运动设置";
    popoverController.popoverBaseColor = [UIColor whiteColor];
    popoverController.popoverGradient= YES;
    //    popoverController.arrowPosition = TSPopoverArrowPositionHorizontal;
    [popoverController showPopoverWithTouch:event];
}

#pragma mark -- settingViewDelegate
- (void)didChangeSwitch:(UISwitch *)sender {
    _recordView.pacePK.hidden = !sender.on;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    NSLog(@"memoryworning activityviewcontroller!!!");
    // Dispose of any resources that can be recreated.
}

#pragma mark --处理运动开始，结束，暂停时间
- (void)dealWithActivity:(ActivityStateType)type {
    switch (type) {
        case ActivityStart:
        {
            [_recordView activityStart];
            [_mapView beginingActivity];
        }
            break;
        case ActivityPause:
            [_recordView activityPause];
            [_mapView paseActivity];
            break;
            
        case ActivityStop:
            [_recordView activityStop];
            [_mapView freaMap];
            [_pieceWiseView freePiece];
            break;
        default:
            break;
    }
}

- (void)activityDealWithType:(ActivityStateType)type {
    [self dealWithActivity:type];
}

- (void)goingOnActivity:(ActivityStateType)type {
    [self dealWithActivity:type];
}

- (void)didSaveActivity:(ActivityStateType)type {
    [self dealWithActivity:type];
    [self.tabBarController setSelectedIndex:1];
    
}

@end
