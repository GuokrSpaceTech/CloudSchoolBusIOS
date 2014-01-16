//
//  GKButton.h
//  SchoolBusPhoto
//
//  Created by wen peifang on 13-10-25.
//  Copyright (c) 2013年 mactop. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Student.h"
@interface GKButton : UIView
@property (nonatomic,retain)Student *student;
@property (nonatomic,assign)BOOL isSelect;
@property (nonatomic,retain)UIImageView *backgroundView;
@property (nonatomic,retain)UIImageView *photoImageView;
@end
