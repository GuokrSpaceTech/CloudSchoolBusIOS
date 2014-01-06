//
//  ETBaseViewController.h
//  etonkids-iphone
//
//  Created by wpf on 1/21/13.
//  Copyright (c) 2013 wpf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ETTableViewHeaderView.h"

#import "EGORefreshTableHeaderView.h"
#import "LoadMoreTableFooterView.h"

#import "WeiboAccounts.h"
#import "WeiboSignIn.h"
#import "TCWBEngine.h"
#import "ETApi.h"
#import "ETShareViewController.h"
#import "SRRefreshView.h"


#define HEADERHEIGHT 40

@interface ETBaseViewController : UIViewController<EGORefreshTableDelegate,UITableViewDataSource,UITableViewDelegate,headerViewdelegate,UIActionSheetDelegate,WeiboSignInDelegate,SRRefreshDelegate>
{
    UITableView *_tableView;
    ETTableViewHeaderView *_topView;
    WeiboSignIn *_weiboSignIn;
    TCWBEngine                  *weiboEngine;
 
    
//    EGORefreshTableHeaderView *_refreshHeaderView;
    
    
    //SRRefreshView   *_slimeView;
    UIButton *toTopBtn;
    
}

@property (nonatomic, retain) TCWBEngine   *weiboEngine;
@property(nonatomic,retain)ETTableViewHeaderView *_topView;
@property (nonatomic, retain)SRRefreshView   *_slimeView;
@property (nonatomic, retain)UIImageView *topBackImgView;
@property(nonatomic,retain) UITableView *_tableView;
@property (nonatomic, retain) LoadMoreTableFooterView *_refreshFooterView;


-(void)pushShareViewController:(UIViewController *)control;
-(void)setFooterView;
-(void)removeFooterView;
-(void)hidTabBar:(NSString *)str;
-(void)showActionSheet;
- (void)setTopView;
- (void)autoDragScrollLoading;  // 默认自动 下拉刷新.


@end
