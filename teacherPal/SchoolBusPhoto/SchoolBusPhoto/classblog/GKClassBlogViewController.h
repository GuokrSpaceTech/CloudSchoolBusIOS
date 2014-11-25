//
//  GKZClassBlogViewController.h
//  SchoolBusPhoto
//
//  Created by wen peifang on 14-11-19.
//  Copyright (c) 2014年 mactop. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GKBaseViewController.h"
#import "EKRequest.h"
#import "SRRefreshView.h"
#import "LoadMoreTableFooterView.h"

#import "GKClassBlog.h"

#import <AVFoundation/AVFoundation.h>
#import "MTAuthCode.h"
#import "ClassShareCell.h"
#import "SDWebImageManager.h"
#import "GKBlogDetailViewController.h"

@interface GKClassBlogViewController : GKBaseViewController<UITableViewDataSource,UITableViewDelegate,EKProtocol,SRRefreshDelegate,EGORefreshTableDelegate,ClassShareCellDelegate>
{

    BOOL isMore;
    
    GKClassBlog *shareContent;

    RequestType reqType;
    
    BOOL isVisible; // 判断当前页面是否可见
    

}
@property (nonatomic,retain)UITableView *_tableView;
@property (nonatomic,retain)NSMutableArray *list;
@property (nonatomic,assign)BOOL isLoading;
@property (nonatomic, retain)SRRefreshView   *_slimeView;
@property (nonatomic, retain) LoadMoreTableFooterView *_refreshFooterView;

@property (nonatomic,assign)BOOL isMore;
@end
