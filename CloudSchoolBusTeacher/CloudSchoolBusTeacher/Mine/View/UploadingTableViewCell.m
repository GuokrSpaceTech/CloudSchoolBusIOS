//
//  UploadingTableViewCell.m
//  CloudSchoolBusTeacher
//
//  Created by macbook on 15/12/16.
//  Copyright © 2015年 BeiJingYinChuang. All rights reserved.
//

#import "UploadingTableViewCell.h"
#import "UploadingPictureCollectionViewCell.h"
#import "UploadRecord.h"
#import <AssetsLibrary/ALAsset.h>
#import <AssetsLibrary/ALAssetsLibrary.h>
#import <AssetsLibrary/ALAssetsGroup.h>
#import <AssetsLibrary/ALAssetRepresentation.h>

@interface UploadingTableViewCell()<UICollectionViewDataSource, UICollectionViewDelegate>
{
    NSMutableArray *uploadingRecords;
}
@end

@implementation UploadingTableViewCell

- (void)awakeFromNib {
    [_imagesCollectionView  registerNib:[UINib nibWithNibName:@"UploadingPictureCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"uploadingCell"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

- (void)setUploadingRecords:(NSMutableArray *)records
{
    uploadingRecords = records;
    _imagesCollectionView.delegate = self;
    _imagesCollectionView.dataSource = self;
}

#pragma mark - UICollectionViewDataSource Methods
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [uploadingRecords count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UploadingPictureCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"uploadingCell" forIndexPath:indexPath];
    UploadRecord *record = uploadingRecords[indexPath.row];
    ALAssetsLibrary * library = [[ALAssetsLibrary alloc] init];
    [library assetForURL:[NSURL URLWithString:record.fbody] resultBlock:^(ALAsset *asset) {
        cell.imageView.image = [UIImage imageWithCGImage:[asset thumbnail]];
    } failureBlock:^(NSError *error) {
        NSLog(@"assetForURL error");
    }];
    
    return cell;
}


#pragma mark - UICollectionViewDelegate Methods

@end
