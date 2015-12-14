//
//  CommentsViewController.m
//  CloudSchoolBusTeacher
//
//  Created by mactop on 12/14/15.
//  Copyright © 2015 BeiJingYinChuang. All rights reserved.
//

#import "CommentsViewController.h"
#import "PhotoViewCell.h"
#import "StudentCollectionViewCell.h"
#import "TagCollectionViewCell.h"
#import "UIImageView+WebCache.h"
#import "Student.h"
#import "Tag.h"
#import "Photo.h"

@interface CommentsViewController () <UICollectionViewDataSource,UICollectionViewDelegate>

@end

@implementation CommentsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _studentCollectionView.delegate = self;
    _studentCollectionView.dataSource = self;

    _tagCollectionView.delegate = self;
    _tagCollectionView.dataSource = self;

    _pictureCollectionView.delegate = self;
    _pictureCollectionView.dataSource = self;
    
    [_studentCollectionView registerNib:[UINib nibWithNibName:@"StudentCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"cellstudent"];
    [_tagCollectionView registerNib:[UINib nibWithNibName:@"TagCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"celltag"];
    [_pictureCollectionView registerClass:[PhotoViewCell class] forCellWithReuseIdentifier:@"cellpicture"];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if(collectionView == _pictureCollectionView)
    {
        return _pictureArray.count;
    }
    else if(collectionView == _tagCollectionView)
    {
        return _tagArray.count;
    }
    else if(collectionView == _studentCollectionView)
    {
        return _studentArray.count;
    }
    else
        return 0;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(collectionView == _pictureCollectionView)
    {
        PhotoViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellpicture" forIndexPath:indexPath];
        Photo *photo = _pictureArray[indexPath.row];
        cell.photoImageView.image = [UIImage imageWithCGImage:[photo.asset thumbnail]];
        
        return cell;
    }
    else if(collectionView == _tagCollectionView)
    {
        TagCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"celltag" forIndexPath:indexPath];
        Tag *tag = _tagArray[indexPath.row];
        cell.tagLabel.text=tag.tagname;
        return cell;
    }
    else if(collectionView == _studentCollectionView)
    {
        StudentCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellstudent" forIndexPath:indexPath];
        Student *student = _studentArray[indexPath.row];
        [cell.avatarImageView sd_setImageWithURL:[NSURL URLWithString:student.avatar] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        }];
        cell.studentNameLabel.text = student.cnname;
        return cell;
    }
    else
    {
        UICollectionViewCell *cell = nil;
        return cell;
    }
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
    if(collectionView == _studentCollectionView)
    {
        return CGSizeMake(self.view.frame.size.width/6.0 ,self.view.frame.size.width/5.0);
    }
    return CGSizeMake(self.view.frame.size.width/6.0 ,self.view.frame.size.width/6.0);
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsZero;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
}

@end
