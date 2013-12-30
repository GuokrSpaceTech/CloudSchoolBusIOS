//
//  GKUploaderCell.h
//  SchoolBusPhoto
//
//  Created by wen peifang on 13-11-18.
//  Copyright (c) 2013年 mactop. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GKUpWraper.h"
#import "myProgressView.h"
//#import "DACircularProgressView.h"
@interface GKUploaderCell : UITableViewCell
@property (nonatomic,retain)GKUpWraper *upwraper;
@property (nonatomic,retain)UIImageView *imageView;
@property (nonatomic,retain)myProgressView *process;

@property (nonatomic,retain)UILabel *nameLabel;
@property (nonatomic,retain)UILabel *sizeLabel;
@end
