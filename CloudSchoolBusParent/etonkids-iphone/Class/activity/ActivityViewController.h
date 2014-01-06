//
//  ActivityViewController.h
//  etonkids-iphone
//
//  Created by CaiJingPeng on 13-9-10.
//  Copyright (c) 2013年 wpf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ETBaseViewController.h"
#import "EKRequest.h"
#import "ETKids.h"
#import "ETCustomAlertView.h"
#import "ETActiveDetailViewController.h"

typedef enum
{
    MyActivityType = 0,
    AllActivity,
    NoStartActivity
    
}ChooseType;

@interface ActivityViewController : ETBaseViewController<UIGestureRecognizerDelegate,EKProtocol,ETActiveDetailViewControllerDelegate>
{
    EGORefreshPos theRefreshPos;
    UIImageView *selImgV;
    
    ChooseType currentType;
    RequestType reqType;
    
    BOOL isMoreMyAct;
    BOOL isMoreNoStart;
    BOOL isMoreAllAct;
    
    BOOL isMore;
    
    BOOL isLoading;
    
    BOOL isFirLoadMyAct;
    BOOL isFirLoadNoStartAct;
    
}


@property (nonatomic, retain) NSMutableArray *activityList;
@property (nonatomic, retain) NSMutableArray *myActivityList;
@property (nonatomic, retain) NSMutableArray *noStartActivityList;


@property (nonatomic, retain) NSDictionary *photoParam;
@property (nonatomic, retain) NSMutableArray *requestArray;
@property (nonatomic, retain) NSDictionary *eventParam;

@property (nonatomic, retain) NSMutableArray *dataList;

@end
