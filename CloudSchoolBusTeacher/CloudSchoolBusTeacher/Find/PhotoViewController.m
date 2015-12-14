//
//  PhotoViewController.m
//  CloudSchoolBusTeacher
//
//  Created by HELLO  on 15/12/14.
//  Copyright © 2015年 BeiJingYinChuang. All rights reserved.
//

#import "PhotoViewController.h"
#import "PhotoViewCell.h"
#import "Photo.h"
@interface PhotoViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>
{
    UICollectionView * _mCollectionView;
}
@end

@implementation PhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _list = [[NSMutableArray alloc]init];
    
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.minimumLineSpacing = 0;
    _mCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 64) collectionViewLayout:flowLayout];
    _mCollectionView.delegate = self;
    _mCollectionView.dataSource = self;
    _mCollectionView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_mCollectionView];
    [_mCollectionView registerClass:[PhotoViewCell class] forCellWithReuseIdentifier:@"cellchanel"];
    
    [_grop setAssetsFilter:[ALAssetsFilter allPhotos]];
    
    [_grop enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
        if(result)
        {
            Photo *photo= [[Photo alloc]init];
            photo.asset = result;
            photo.isSelected = NO;
            [_list addObject:photo];
        }
        else
        {
            [_mCollectionView reloadData];
        }
    }];

}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [_list count];
    
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
//    static NSString * identify = @"cellchanel";
    PhotoViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellchanel" forIndexPath:indexPath];
    Photo * photo = _list[indexPath.row];
    cell.photoImageView.image = [UIImage imageWithCGImage:[photo.asset thumbnail]];
    
    if(photo.isSelected == YES)
    {
        cell.selectIamgeView.hidden = NO;
    }
    else
    {
        cell.selectIamgeView.hidden = YES;
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

    return CGSizeMake(self.view.frame.size.width/4.0 ,self.view.frame.size.width/4.0);
    
   // return CGSizeMake(50, 50);
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsZero;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    Photo * photo = _list[indexPath.row];
   
    photo.isSelected = !photo.isSelected;
    [_mCollectionView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
