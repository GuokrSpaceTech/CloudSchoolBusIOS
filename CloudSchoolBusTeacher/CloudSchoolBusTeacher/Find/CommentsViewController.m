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
#import "CBDateBase.h"
#import "UIImageView+WebCache.h"
#import "CBLoginInfo.h"
#import "Student.h"
#import "Tag.h"
#import "Photo.h"
#import "UploadRecord.h"
#import "UploadWrapper.h"

@interface CommentsViewController () <UICollectionViewDataSource,UICollectionViewDelegate>
{
    NSString *comments;
    NSMutableArray *studentsSelection;
    NSMutableArray *tagsSelection;
}
-(NSString *)timeStamp;
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
    
    UIButton *nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [nextButton setBackgroundImage:[UIImage imageNamed:@"ic_list_white"] forState:UIControlStateNormal];
    nextButton.frame = CGRectMake(0, 0, 30, 30);
    [nextButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [nextButton addTarget:self action:@selector(nextButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * nextItem = [[UIBarButtonItem alloc]initWithCustomView:nextButton];
    self.navigationItem.rightBarButtonItem = nextItem;
    
    tagsSelection = [[NSMutableArray alloc]init];
    studentsSelection = [[NSMutableArray alloc]init];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark
#pragma mark == Collection View Datasource and Delegate
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
        
        cell.selectionIndicateView.hidden = YES;
        for(Student *stu in studentsSelection)
        {
            if([stu.studentid isEqualToString:student.studentid])
            {
                cell.selectionIndicateView.hidden = NO;
            }
        }

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
    if(collectionView == _studentCollectionView)
    {
        BOOL found=NO;
        Student *student = _studentArray[indexPath.row];
        for(Student *stu in studentsSelection)
        {
            if([stu.studentid isEqualToString:student.studentid])
            {
                found = YES;
                break;
            }
        }
        if(found)
        {
            [studentsSelection removeObject:student];
        }
        else
        {
            [studentsSelection addObject:student];
        }
    }
    
    [self.studentCollectionView reloadData];
}

#pragma mark
#pragma mark == User Actions
-(void)nextButtonClick:(id)sender
{
    NSString *studentids = @"";
    int i = 0;
    for(Student *student in studentsSelection)
    {
        studentids = [studentids stringByAppendingString:student.studentid];
        if(i<(studentsSelection.count-1))
        {
            studentids = [studentids stringByAppendingString:@","];
        }
        i++;
    }
    
    i = 0;
    NSString *tagids = @"";
    for(Tag *tag in tagsSelection)
    {
        tagids = [tagids stringByAppendingString:tag.tagid];
        if(i<(tagsSelection.count-1))
        {
            tagids = [tagids stringByAppendingString:@","];
        }
        i++;
    }
    
    for(Photo *photo in _pictureArray)
    {
        NSString *pickey = [NSString stringWithFormat:@"%@%@", [self timeStamp], [[CBLoginInfo shareInstance] userid] ];
        NSString *pictype = @"article";
        NSString *classid = [[[[CBLoginInfo shareInstance] classArr] objectAtIndex: 0] classid];
        NSString *fbody = [photo.asset valueForProperty:ALAssetPropertyAssetURL];
//        ALAssetsLibrary * library = [[ALAssetsLibrary alloc] init];
//        [library assetForURL:assetURL resultBlock:^(ALAsset *asset )
        NSString *teacherid = [[CBLoginInfo shareInstance] userid];
        ALAssetRepresentation *rep = [photo.asset defaultRepresentation];
        NSString *fname = [rep filename];
        
        NSDate* date = [photo.asset valueForProperty:ALAssetPropertyDate];
        NSString *ftime = [NSString stringWithFormat:@"%d", (int)[date timeIntervalSince1970]];
        NSString *status = @"2"; //0,fail, 1,success, 2,waiting 3,uploading
        NSString *content = _commentTextView.text;
        
        //Write to DB
        UploadRecord *uploadRecord = [[UploadRecord alloc] init];
        uploadRecord.pickey = pickey;
        uploadRecord.pictype = pictype;
        uploadRecord.classid = classid;
        uploadRecord.fbody = fbody;
        uploadRecord.teacherid = teacherid;
        uploadRecord.fname = fname;
        uploadRecord.ftime = ftime;
        uploadRecord.status = status;
        uploadRecord.content = content;
        uploadRecord.studentids = studentids;
        uploadRecord.tagids = tagids;
        
        [[CBDateBase sharedDatabase] insertRecordToUploadQueue:uploadRecord];
    }
    
    //Open Up GCD Upload
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [[UploadWrapper shareInstance] uploadFile];
    });
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (NSString *) timeStamp
{
    return [NSString stringWithFormat:@"%d",(int)[[NSDate date] timeIntervalSince1970]];
}
@end
