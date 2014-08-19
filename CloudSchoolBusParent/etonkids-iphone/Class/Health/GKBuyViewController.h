//
//  GKBuyViewController.h
//  etonkids-iphone
//
//  Created by wen peifang on 14-8-15.
//  Copyright (c) 2014年 wpf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EKRequest.h"
@interface GKBuyViewController : UIViewController<EKProtocol>
{
    UITextField *textfiled;
    UILabel * sumLabel;
}
@property (nonatomic,assign)int count;
@end
