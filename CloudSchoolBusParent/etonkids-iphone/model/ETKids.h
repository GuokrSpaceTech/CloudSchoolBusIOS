//
//  ETKids.h
//  etonkids-iphone
//
//  Created by wpf on 1/30/13.
//  Copyright (c) 2013 wpf. All rights reserved.
//

#define iphone5     ([UIScreen instancesRespondToSelector:@selector(currentMode)]?CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size):NO)

#define ios7  [[[UIDevice currentDevice] systemVersion] floatValue] >= 7
#define IOSVERSION [[[UIDevice currentDevice]systemVersion]floatValue]
#define REMEMBERPSAAWORD @"rememberpassword"  // 记住密码 key
#define AUTOLOGIN @"auto_login"                //自动登陆key

#define REMEMBERPSAAWORDVALUE @"rememberValue" // 记住密码 value
#define AUTOLOGINVALUE @"login"             //自动登陆  value

#define SERVERURL   @"http://mactoptest.azurewebsites.net/jxt/index.php/" //  //
//@"http://192.168.10.95/jxt/index.php/"
#define LOCAL(a,b) NSLocalizedString(a,b) 


#define MAX_IMAGECOUNT 9
#define TITLEFONTSIZE  16.0f
#define CONTENTFONTSIZE  15.0f
#define TIMEFONTSIZE  12.0f
#define CONTENTTEXTCOLOR [UIColor colorWithRed:80/255.0 green:80/255.0 blue:80/255.0 alpha:1.0f]
#define TIMETEXTCOLOR [UIColor colorWithRed:128/255.0 green:128/255.0 blue:128/255.0 alpha:1.0f]

#define CELLCOLOR [UIColor colorWithRed:240/255.0f green:238/255.0f blue:227/255.0f alpha:1.0f]
#define APPCOLOR [UIColor colorWithRed:110/255.0f green:189/255.0f blue:208/255.0f alpha:1.0f]

#define DETAILLEFTMARGIN 50  //正文页面 cell 距左边距离

#define HEADMAXCOUNT 7     //正文页面 可显示最多头像数

#define NAVIHEIGHT 46                         

#define ORDER_BLOCK_WIDTH 140
#define ORDER_BLOCK_HEIGHT 120

#define LEFT_MARGIN 13


#define LIMIT_NICKNAME 20
#define LIMIT_COMMENT 70

#define MOVIESIZE 300


#define GESTUREPASSWORD @"GesturePassword"
#define SWITHGESTURE @"isOnGesPwd"


#define RIGHTMARGIN 268

#define SERVICE_NUMBER @"400-606-3996"

typedef enum
{
    logoutType = 0,
    loginType
    
} RequestType;

