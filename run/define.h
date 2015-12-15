//
//  define.h
//  run1.1
//
//  Created by runner on 14/12/30.
//  Copyright (c) 2014年 runner. All rights reserved.
//

#import "UIViewController+HUD.h"
#import "LineView.h"
#import "CoreData+MagicalRecord.h"
#import "MessageManager.h"
#import "NSNumber+NumberWithString.h"


//计算
#define saveTime 5
#define Error_message @"err_msg"
#define SOUND_SWITCH @"SoundSwitch"
#define SHARE_SWITCH @"shareSwitch"
#define SPEED_PK_SWITCH @"speedPKSwitch"

typedef NS_ENUM(NSInteger, ActivityStateType)
{
    ActivityStart = 0,
    ActivityPause = 1,
    ActivityStop = 2
};

typedef NS_ENUM(NSInteger, SelfDetailType) {
    ActivityType = 0,
    CountType = 1,
    GroupType = 2,
    RouteType = 3
};

typedef NS_ENUM(NSInteger, LoginType) {
    LoginSystemType = 0,
    LoginWebChatType = 1,
    LoginQQType = 2,
    LoginWeibo = 3
};
//方法名，通知名等
#define Show_Login @"show_login"
#define Sahara_Name @"name"
#define Sahara_Password @"password"
#define Login_Message @"login_message"
#define Start_Login @"startLogin"
#define DidSaveLocation @"saveloavtion"
#define SaveActivity @"saveActivity"
#define CutMapPicture @"cutMapPicture"

#define DATAMODEL [DataModel getInstance]

#define PACE 20

#define UpDateTime 5

#define WIDTH_SCALE 320.0/375.0
#define iPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhone4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)

#define IMAGE_WITH_NAME(name) [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForAuxiliaryExecutable:name]]

#define SharedUser [UserInterfaceCenter shareNowUser]

#define IOS7 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)

#define IOS8 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)


#define kColor(r,g,b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

#define kBackgroundColor kColor(24,156,203)
//获取当前屏幕的宽度
#define kMainScreenWidth ([UIScreen mainScreen].applicationFrame.size.width)

//获取当前屏幕的高度
#define kMainScreenHeight ([UIScreen mainScreen].applicationFrame.size.height)

//iPhone5
#define kScreenIphone5 (([[UIScreen mainScreen] bounds].size.height)>=568)

#define IS_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )

#define JBackGroundColor [UIColor colorWithRed:232/255.0 green:233/255.0 blue:232/255.0 alpha:1]

// View 坐标(x,y)和宽高(width,height)
#define X(v)                    (v).frame.origin.x
#define Y(v)                    (v).frame.origin.y
#define WIDTH(v)                (v).frame.size.width
#define HEIGHT(v)               (v).frame.size.height

#define MinX(v)                 CGRectGetMinX((v).frame)
#define MinY(v)                 CGRectGetMinY((v).frame)

#define MidX(v)                 CGRectGetMidX((v).frame)
#define MidY(v)                 CGRectGetMidY((v).frame)

#define MaxX(v)                 CGRectGetMaxX((v).frame)
#define MaxY(v)                 CGRectGetMaxY((v).frame)

// 系统控件默认高度
#define kStatusBarHeight        (20.f)

#define kTopBarHeight           (44.f)
#define kBottomBarHeight        (49.f)

#define kCellDefaultHeight      (44.f)

#define kEnglishKeyboardHeight  (216.f)
#define kChineseKeyboardHeight  (252.f)

/* ****************************************************************************************************************** */

// 字体大小(常规/粗体)
#define BOLDSYSTEMFONT(FONTSIZE)[UIFont boldSystemFontOfSize:FONTSIZE]
#define SYSTEMFONT(FONTSIZE)    [UIFont systemFontOfSize:FONTSIZE]
#define FONT(NAME, FONTSIZE)    [UIFont fontWithName:(NAME) size:(FONTSIZE)]

// 颜色(RGB)
#define RGBCOLOR(r, g, b)       [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
#define RGBACOLOR(r, g, b, a)   [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]

#define isPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

//工程字体

#define BOLD_18_FONT [UIFont boldSystemFontOfSize:18]
#define SYSTEM_18_FONT [UIFont systemFontOfSize:18]

#define BOLD_16_FONT [UIFont boldSystemFontOfSize:16]
#define SYSTEM_16_FONT [UIFont systemFontOfSize:16]

#define BOLD_14_FONT [UIFont boldSystemFontOfSize:14]
#define SYSTEM_14_FONT [UIFont systemFontOfSize:14]

#define BOLD_12_FONT [UIFont boldSystemFontOfSize:12]
#define SYSTEM_12_FONT [UIFont systemFontOfSize:12]

#define BOLD_10_FONT [UIFont boldSystemFontOfSize:10]
#define SYSTEM_10_FONT [UIFont systemFontOfSize:10]

#define cell_Font_small [UIFont systemFontOfSize:12]
#define cell_Font_big [UIFont systemFontOfSize:14]
//颜色
#define BackGroundColor [UIColor lightGrayColor]
#define CurrentAlpha 0.8
#define layColor [UIColor orangeColor].CGColor
#define NaVBarColor [UIColor colorWithRed:255/255.0f green:90/255.0f blue:0/255.0f alpha:1]
#define sahara_Gray [UIColor colorWithRed:61/255.0f green:66/255.0f blue:69/255.0f alpha:1]
#define sahara_BackGroundColor [UIColor colorWithRed:239/255.0f green:239/255.0f blue:244/255.0f alpha:1]

#define sahara_color [UIColor colorWithRed:255/255.0f green:90/255.0f blue:0/255.0f alpha:1]


