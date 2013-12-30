//
//  GKButton.h
//  SchoolBusPhoto
//
//  Created by wen peifang on 13-10-25.
//  Copyright (c) 2013年 mactop. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Student.h"
@interface GKButton : UIButton
@property (nonatomic,retain)Student *student;
@property (nonatomic,assign)BOOL isSelect;
@end
