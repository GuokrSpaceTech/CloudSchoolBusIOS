//
//  OperationCollectionViewController.m
//  CloudSchoolBusTeacher
//
//  Created by macbook on 15/12/22.
//  Copyright © 2015年 BeiJingYinChuang. All rights reserved.
//
#import "CB.h"
#import "OperationCollectionViewController.h"
#import "OperationCollectionViewCell.h"
#import "HeaderCollectionReusableView.h"
#import "CBWebViewController.h"
#import "CBLoginInfo.h"
#import "School.h"
#import "ClassModule.h"

@interface OperationCollectionViewController ()
{
    NSArray *classModuleArr;
}
@end

@implementation OperationCollectionViewController

static NSString * const reuseIdentifier = @"ClassOperationCell";
static NSString * const reuseHeaderIdentifier = @"ClassOperationHeaderCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    /*
     * Init the data
     */
    //TODO:目前只支持一个学校
    School *school = [CBLoginInfo shareInstance].schoolArr[0];
    classModuleArr = school.classModuleArr;

    // Register cell nib and header nib
    [self.collectionView registerNib:[UINib nibWithNibName:@"OperationCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:reuseIdentifier];
    [self.collectionView registerNib:[UINib nibWithNibName:@"HeaderCollectionReusableView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:reuseHeaderIdentifier];
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

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionVie
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return classModuleArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    OperationCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    cell.module = classModuleArr[indexPath.row];
    
//    cell.layer.borderColor=[UIColor grayColor].CGColor;
//    cell.layer.borderWidth=1;
    
    return cell;
}

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableview = nil;
    CBLoginInfo *info = [CBLoginInfo shareInstance];
    
    if (kind == UICollectionElementKindSectionHeader){
        
        HeaderCollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:reuseHeaderIdentifier forIndexPath:indexPath];
        
        headerView.classLabel.text = [[info myClass] className];
        headerView.schoolLabel.text = [[info mySchool] name];
        NSString *avatarUrl = [[info findMe] avatar];
        [headerView.teacherAvatar sd_setImageWithURL:[NSURL URLWithString:avatarUrl] placeholderImage:nil];
        
        reusableview = headerView;
    }
    
    return reusableview;
}

#pragma mark <UICollectionViewDelegate>
//Header占据1/5的屏幕高度
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    CGSize size = {SCREENWIDTH, SCREENHEIGHT/5};
    return size;
}
//没有Footer
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    return CGSizeZero;
}
//屏幕下部分为3行，3列
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    float cellWidth = (screenWidth)/ 3.0; //Replace the divisor with the column count requirement. Make sure to have it in float.
    CGSize size = CGSizeMake(cellWidth-7, cellWidth-7);
    
    return size;
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsZero;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *sid = [[CBLoginInfo shareInstance]sid];
    NSString *classid = [[CBLoginInfo shareInstance]currentClassId];
    ClassModule *module = classModuleArr[indexPath.row];
    NSString *url = [module.url stringByAppendingFormat:@"?%@=%@&%@=%@", @"sid",sid,@"classid",classid];
    
    CBWebViewController *webview = [[CBWebViewController alloc]init];
    webview.urlStr = url;
    webview.titleStr = module.title;
    [self.navigationController pushViewController:webview animated:YES];
}

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

@end
