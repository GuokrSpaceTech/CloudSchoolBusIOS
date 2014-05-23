//
//  GKRelationViewController.h
//  SchoolBusPhoto
//
//  Created by wen peifang on 14-5-14.
//  Copyright (c) 2014年 mactop. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GKBaseViewController.h"
#import "EKRequest.h"
#import "MBProgressHUD.h"
@interface GKRelationViewController : GKBaseViewController<EKProtocol,UIAlertViewDelegate>
{
    MBProgressHUD *HUD;
}
@property(nonatomic,retain)NSString *student;
@property(nonatomic,retain)NSString *tel;
@property (nonatomic,retain)NSString *parentid;

@property (nonatomic,retain)NSString *name;
@property (nonatomic,retain)NSString *birthday;
@property (nonatomic,assign)int sex;
@end
