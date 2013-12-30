//
//  GKLetterCell.h
//  SchoolBusPhoto
//
//  Created by wen peifang on 13-10-28.
//  Copyright (c) 2013年 mactop. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Letter.h"
@protocol letterCellDelegate;
@interface GKLetterCell : UITableViewCell
@property (nonatomic,assign)id<letterCellDelegate>delegate;

//@property (nonatomic,retain)UILabel *labelWho;
//@property (nonatomic,retain)UILabel *labeTime;
@property (nonatomic,retain)UILabel *labelcontent;

@property (nonatomic,retain)Letter *letter;
@end

@protocol letterCellDelegate <NSObject>

-(void)clickImageViewLookImage:(NSString *)path;

@end