//
//  UploadingTableViewCell.m
//  CloudSchoolBusTeacher
//
//  Created by macbook on 15/12/16.
//  Copyright © 2015年 BeiJingYinChuang. All rights reserved.
//
#import "CB.h"
#import "Calculate.h"
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

#define COL_NUM = 4;
@implementation UploadingTableViewCell

- (void)awakeFromNib {
    [_imagesCollectionView registerNib:[UINib nibWithNibName:@"UploadingPictureCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"uploadingCell"];
    _flowLayout.minimumInteritemSpacing = 0;
    _flowLayout.minimumLineSpacing = 0;
    _imagesCollectionView.backgroundColor = [UIColor whiteColor];
    _imagesCollectionView.delegate = self;
    _imagesCollectionView.dataSource = self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setUploadingRecords:(NSMutableArray *)records
{
    if(records.count>0)
    {
        UploadRecord *rec = records[0];
        _timestampLabel.text = [Calculate dateFromTimeStamp:[rec.ftime intValue]];

        uploadingRecords = records;
        [_imagesCollectionView reloadData];
    }
}

// If you are not using auto layout, override this method, enable it by setting
// "fd_enforceFrameLayout" to YES.
- (CGSize)sizeThatFits:(CGSize)size {
    float IMAGE_HEIGHT = (SCREENWIDTH-8*5)/4;

    CGFloat totalHeight = 0;
    totalHeight += [self.timestampLabel sizeThatFits:size].height;
    totalHeight += ceil((double)uploadingRecords.count / 4) * IMAGE_HEIGHT;
    totalHeight += 40; // margins
    return CGSizeMake(size.width, totalHeight);
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
    
    //0,fail, 1,success, 2,waiting 3,uploading
    cell.activityIndicatorView.hidesWhenStopped = YES;
    if([record.status isEqualToString:@"2"] || [record.status isEqualToString:@"3"])
    {
        [cell.activityIndicatorView startAnimating];
        cell.retryButton.hidden = YES;
        cell.coverView.hidden = NO;
    } else {
        [cell.activityIndicatorView stopAnimating];
        if([record.status isEqualToString:@"1"])
        {
            cell.retryButton.hidden = YES;
            cell.coverView.hidden = YES;
        }
        else if([record.status isEqualToString:@"0"])
        {
            cell.retryButton.hidden = YES;
            cell.coverView.hidden = NO;
        }
    }
    
    
    return cell;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeZero;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    return CGSizeZero;;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((SCREENWIDTH-8*5)/4,(SCREENWIDTH-8*5)/4);
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsZero;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    UploadRecord *record = uploadingRecords[indexPath.row];
    if([record.status isEqualToString:@"0"])
    {
        //TODO: at the moment, retry failed upload is automatic.
    }
    
}

#pragma mark - UICollectionViewDelegate Methods

@end
