//
//  ETChildManagerViewController.h
//  etonkids-iphone
//
//  Created by CaiJingPeng on 13-10-25.
//  Copyright (c) 2013年 wpf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface ETChildManagerViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *mainTV;
    MBProgressHUD *HUD;
}

@end
