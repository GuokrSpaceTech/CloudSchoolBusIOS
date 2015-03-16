//
//  GKRouteViewController.h
//  etonkids-iphone
//
//  Created by wen peifang on 15-3-16.
//  Copyright (c) 2015年 wpf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GKAllStopViewController.h"
@protocol routeDelegate;
@interface GKRouteViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,AllStopDelegate>
{ 
   
   
}
@property (nonatomic,assign)id<routeDelegate>delegate;
@property (nonatomic,retain)UITableView *_tableView;
@property (nonatomic,retain)NSMutableArray *list;

@end

@protocol routeDelegate <NSObject>

-(void)refreshVC;

@end