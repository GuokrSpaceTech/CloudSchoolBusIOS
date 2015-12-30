//
//  TeacherViewController.h
//  CloudBusParent
//
//  Created by HELLO  on 15/11/9.
//  Copyright (c) 2015年 BeiJingYinChuang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TeacherViewController : UITableViewController
{
    BOOL isIntoChat;
}
@property (nonatomic,strong)NSMutableArray * contactArray;
@property (nonatomic,strong)NSString * viewTitle;
@property (nonatomic,strong)NSMutableDictionary * offscreenCells;
@end
