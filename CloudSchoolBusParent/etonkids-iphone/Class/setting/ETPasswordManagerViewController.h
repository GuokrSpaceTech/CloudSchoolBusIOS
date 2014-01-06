//
//  ETPasswordManagerViewController.h
//  etonkids-iphone
//
//  Created by CaiJingPeng on 13-10-8.
//  Copyright (c) 2013年 wpf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ETChangeGestureViewController.h"

@interface ETPasswordManagerViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    UISwitch *gesSwitch;
    UITableView *mainTV;
    
    int n;
}

@end
