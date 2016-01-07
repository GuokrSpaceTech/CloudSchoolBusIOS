//
//  CommentsViewController.h
//  CloudSchoolBusTeacher
//
//  Created by mactop on 12/14/15.
//  Copyright © 2015 BeiJingYinChuang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentsViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextView *commentTextView;
@property (weak, nonatomic) IBOutlet UICollectionView *pictureCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *tagCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *studentCollectionView;
@property (weak, nonatomic) IBOutlet UILabel *textCountLabel;


@property (strong, nonatomic) NSMutableArray *pictureArray;
@property (strong, nonatomic) NSMutableArray *tagArray;
@property (strong, nonatomic) NSMutableArray *studentArray;

@end
