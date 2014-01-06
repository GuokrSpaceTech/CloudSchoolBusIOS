//
//  ETSummaryViewController.h
//  etonkids-iphone
//
//  Created by WenPeiFang on 2/2/13.
//  Copyright (c) 2013 wpf. All rights reserved.
//

#import "ETBaseViewController.h"
#import "ClassShareCell.h"
#import "MBProgressHUD.h"
#import <MessageUI/MessageUI.h>
@interface ETSummaryViewController : ETBaseViewController<headerViewdelegate,ClassShareCellDelegate,MFMessageComposeViewControllerDelegate,MFMailComposeViewControllerDelegate,UINavigationControllerDelegate>
{
    MBProgressHUD *HUD;
    int  currentIndex;
    
    
    BOOL isMore;
}
@property (nonatomic,retain)ShareContent *shareContent;
@property(nonatomic,retain)NSMutableArray *arrList;
@property BOOL isLoading;
@end
