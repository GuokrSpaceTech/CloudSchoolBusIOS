//
//  GKInfoViewController.h
//  SchoolBusPhoto
//
//  Created by wen peifang on 13-10-22.
//  Copyright (c) 2013年 mactop. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GKBaseViewController.h"
#import "GKMainViewController.h"
#import "GKMarketCell.h"
#import "GKMarketButton.h"
#import "EKRequest.h"
#import "GKUserLogin.h"
#import "GKMarket.h"
#import "GKBuyCountView.h"
#import "GKAlreadyCell.h"
#import "GKNODataView.h"
#import "ETScoreView.h"
@interface GKInfoViewController : GKBaseViewController<UITableViewDataSource,UITableViewDelegate,markerButtonDelegate,EKProtocol,marketDelegate,UIAlertViewDelegate>
{
    NSInteger index;
    GKMarketButton *allCredetbutton;
    GKMarketButton *userCredetbutton;
    GKMarketButton *alreadyCredetbutton;
    UIView *topView;
    
    UITapGestureRecognizer *tapGest;
    GKBuyCountView *countView;
    
    ETScoreView *etScrollView;
    int buyCount;
    
    GKNODataView *nodataView;
}

@property (nonatomic,retain)GKMarket *buymarket;
@property (nonatomic,retain)UITableView *_tableView;

@property (nonatomic,retain)NSMutableArray *dataArr;


@property (nonatomic,retain)NSMutableArray *alreadyArr;
@end
