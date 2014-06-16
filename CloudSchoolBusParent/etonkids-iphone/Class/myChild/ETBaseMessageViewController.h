//
//  ETBaseMessageViewController.h
//  etonkids-iphone
//
//  Created by CaiJingPeng on 13-10-30.
//  Copyright (c) 2013年 wpf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MTCustomActionSheet.h"
#import "ETNicknameViewController.h"
#import "EKRequest.h"
#import "ETSendRecevieViewController.h"
@protocol ETBaseMessageViewControllerDelegate <NSObject>
@optional
- (void)reloadChildMessage;

@end

@interface ETBaseMessageViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,MTCustomActionSheetDelegate,ETNicknameViewControllerDelegate,EKProtocol,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate>
{
    UILabel *birthdaylabel;
    MBProgressHUD *HUD;
    UILabel *countlabel;
    UIActivityIndicatorView *activeView;
    
    
    int receiverType;
}

@property (nonatomic, retain)UITableView *mainTV;
@property (nonatomic, retain)NSMutableArray*receiveArr;
@property (nonatomic, assign)id<ETBaseMessageViewControllerDelegate> delegate;

@end
