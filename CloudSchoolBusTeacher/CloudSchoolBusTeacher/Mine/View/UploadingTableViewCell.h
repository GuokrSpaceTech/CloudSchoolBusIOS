//
//  UploadingTableViewCell.h
//  CloudSchoolBusTeacher
//
//  Created by macbook on 15/12/16.
//  Copyright © 2015年 BeiJingYinChuang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UploadingTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *timestampLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *imagesCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *flowLayout;

-(void)setUploadingRecords:(NSMutableArray *)records;
@end
