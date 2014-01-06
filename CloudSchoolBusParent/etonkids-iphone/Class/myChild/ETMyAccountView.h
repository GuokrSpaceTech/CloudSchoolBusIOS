//
//  ETMyAccountView.h
//  etonkids-iphone
//
//  Created by CaiJingPeng on 13-10-30.
//  Copyright (c) 2013年 wpf. All rights reserved.
//

#import "ETBoardSideView.h"

@interface ETMyAccountView : ETBoardSideView<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, retain)UITableView *mainTV;

@end
