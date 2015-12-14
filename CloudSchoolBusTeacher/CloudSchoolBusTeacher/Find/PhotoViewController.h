//
//  PhotoViewController.h
//  CloudSchoolBusTeacher
//
//  Created by HELLO  on 15/12/14.
//  Copyright © 2015年 BeiJingYinChuang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
@interface PhotoViewController : UIViewController
@property (nonatomic,strong)ALAssetsGroup * grop;
@property (nonatomic,strong)NSMutableArray * list;
@end
