//
//  GKAlumbViewController.m
//  SchoolBusPhoto
//
//  Created by wen peifang on 13-12-24.
//  Copyright (c) 2013年 mactop. All rights reserved.
//

#import "GKAlumbViewController.h"

#import "GKMainViewController.h"
#import "GKImagePickerController.h"

#import "GKImagePickerViewController.h"
@interface GKAlumbViewController ()

@end

@implementation GKAlumbViewController
@synthesize _tableView;
@synthesize arr;
@synthesize _labery;
@synthesize _slimeView;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    

 

    UIButton *buttom=[UIButton buttonWithType:UIButtonTypeCustom];
    buttom.frame=CGRectMake(12, 6, 35, 35);
    [buttom setBackgroundImage:IMAGENAME(IMAGEWITHPATH(@"left")) forState:UIControlStateNormal];
    [buttom setBackgroundImage:IMAGENAME(IMAGEWITHPATH(@"leftN")) forState:UIControlStateHighlighted];
    buttom.tag=0;
    [buttom addTarget:self action:@selector(leftClick:) forControlEvents:UIControlEventTouchUpInside];
    [navigationView addSubview:buttom];
    
    
    
    
    
    
    
    
    UIButton *photobutton=[UIButton buttonWithType:UIButtonTypeCustom];
    photobutton.frame=CGRectMake(275, 5, 35, 35);
    [photobutton setBackgroundImage:IMAGENAME(IMAGEWITHPATH(@"视频1")) forState:UIControlStateNormal];
    [photobutton setBackgroundImage:IMAGENAME(IMAGEWITHPATH(@"视频2")) forState:UIControlStateHighlighted];
    [photobutton addTarget:self action:@selector(takePhoto:) forControlEvents:UIControlEventTouchUpInside];
    [navigationView addSubview:photobutton];
    
    
    arr=[[NSMutableArray alloc]init];
    usr=[GKUserLogin currentLogin];
    
    [usr addObserver:self forKeyPath:@"badgeNumber" options:NSKeyValueObservingOptionNew context:NULL];
    
    titlelabel.text=usr.classInfo.classname;
    
    
    if(ios7)
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, IOS7OFFSET+46, self.view.frame.size.width, self.view.frame.size.height-46-IOS7OFFSET) style:UITableViewStylePlain];
    else
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 46, self.view.frame.size.width, self.view.frame.size.height-46) style:UITableViewStylePlain];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.backgroundColor=[UIColor colorWithRed:232/255.0 green:229/255.0 blue:220/255.0 alpha:1];
    [self.view addSubview:_tableView];
    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;


    
    _slimeView = [[SRRefreshView alloc] init];
    _slimeView.delegate = self;
    _slimeView.upInset = 0;
    _slimeView.slimeMissWhenGoingBack = YES;
    _slimeView.slime.bodyColor = [UIColor blackColor];
    _slimeView.slime.skinColor = [UIColor blackColor];
    _slimeView.slime.lineWith = 1;
    _slimeView.slime.shadowBlur = 4;
    _slimeView.slime.shadowColor = [UIColor blackColor];

    [_tableView addSubview:self._slimeView];
    
    badgeView=[[GKBadgeView alloc]initWithFrame:CGRectMake(38, 2, 16, 16)];
    badgeView.backgroundColor=[UIColor clearColor];
    
    [navigationView addSubview:badgeView];
    [badgeView release];
    //NOData
    badgeView.bagde=[usr.badgeNumber integerValue];
    
    if (!_labery) {
        _labery = [[ALAssetsLibrary alloc] init];
    }
    isRefresh=NO;
    [self loadAlum];
    
	// Do any additional setup after loading the view.
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [(KKNavigationController *)self.navigationController setNavigationTouch:NO];
}
-(void)loadAlum
{
// 加载相册

    if(isRefresh==NO)
    {
        isRefresh=YES;
        [arr removeAllObjects];
        
        [_labery enumerateGroupsWithTypes:ALAssetsGroupAll  usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
            
            if(group)
            {
                NSLog(@"%d",group.numberOfAssets);
                
                
                [arr insertObject:group atIndex:0];
                
                NSLog(@"dddd");
            }
            else
            {
                   isRefresh=NO;
                [_slimeView endRefresh];
                [_tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
            }
            
        } failureBlock:^(NSError *error) {
            [_slimeView endRefresh];
            NSLog(@"------%@",error.description);
            
            NSLog(@"%d",error.code);
         
            if(error.code==-3311)
            {
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"alert", @"") message:@"请在\"设置\"-\"隐私\"-\"照片\"中, 允许\"教师助手\"使用！" delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:nil, nil];
                [alert show];
                [alert release];
            }
            isRefresh=NO;
            
        }];

    }
   
}
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{

    badgeView.bagde=[usr.badgeNumber integerValue];

}
-(void)takePhoto:(UIButton *)btn
{
//    UIImagePickerController *p = [[UIImagePickerController alloc] init];
//    p.sourceType = UIImagePickerControllerSourceTypeCamera;
//    [self presentModalViewController:p animated:YES];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:[[GKImagePickerController alloc] init]];
    [self presentViewController:nav animated:YES completion:nil];
    /*
    AVCamViewController *avVC=[[AVCamViewController alloc]initWithNibName:@"AVCamViewController" bundle:nil];
    [self.navigationController pushViewController:avVC animated:YES];
    [avVC release];
    */
    
    //[self setAllPhotoSelect:YES];
}

-(void)leftClick:(UIButton *)btn
{
    
    GKMainViewController *main=[GKMainViewController share];
    if(main.state==0)
    {
        if ([[GKMainViewController share] respondsToSelector:@selector(showSideBarControllerWithDirection:)]) {
            [[GKMainViewController share] showSideBarControllerWithDirection:SideBarShowDirectionLeft];
        }
    }
    else
    {
        if ([[GKMainViewController share] respondsToSelector:@selector(showSideBarControllerWithDirection:)]) {
            [[GKMainViewController share] showSideBarControllerWithDirection:SideBarShowDirectionNone];
        }
    }
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [arr count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellDefiner=@"cell";
    
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellDefiner];
    if(cell==nil)
    {
        cell=[[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellDefiner] autorelease];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        cell.backgroundColor=[UIColor clearColor];
        
        UIImageView *alumbImageView=[[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 50, 50)];
        alumbImageView.backgroundColor=[UIColor clearColor];
        alumbImageView.tag=852;
        [cell addSubview:alumbImageView];
        [alumbImageView release];
        
        
        UILabel *namelabel=[[UILabel alloc]initWithFrame:CGRectMake(65, 20, 200, 20)];
        namelabel.backgroundColor=[UIColor clearColor];
        namelabel.tag=853;
        [cell addSubview:namelabel];
    
        [namelabel release];
        
        UIImageView *imageline=[[UIImageView alloc]initWithFrame:CGRectMake(0, 58, 320, 2)];
        imageline.image=IMAGENAME(IMAGEWITHPATH(@"line"));;
        [cell addSubview:imageline];
        [imageline release];
    
    }
     ALAssetsGroup *group=[arr objectAtIndex:indexPath.row];
    UIImageView *iamgeView=(UIImageView *)[cell viewWithTag:852];
    iamgeView.image=[UIImage imageWithCGImage:[group posterImage]];
    
    UILabel *label=(UILabel *)[cell viewWithTag:853];
    label.text=[group valueForProperty:ALAssetsGroupPropertyName];
    
   // cell.textLabel.text=[group valueForProperty:ALAssetsGroupPropertyName];
    //cell.imageView.image=[UIImage imageWithCGImage:[group posterImage]];
    return cell;


   
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    GKImagePickerViewController *imagePickVC=[[GKImagePickerViewController alloc]init];
    imagePickVC.group_=[arr objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:imagePickVC animated:YES];
    [imagePickVC release];
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{

    if (self._slimeView) {
        [self._slimeView scrollViewDidScroll];
    }

}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (self._slimeView) {
        [self._slimeView scrollViewDidEndDraging];
    }


}
- (void)slimeRefreshStartRefresh:(SRRefreshView *)refreshView
{
    NSLog(@"start refresh");
    //    [self showHUD:YES];
    [self loadAlum];
    //theRefreshPos = EGORefreshHeader;
    //[self requestNoticeData:nil];
}

-(void)viewDidUnload
{
    self._tableView=nil;
    self._labery=nil;
    self.arr=nil;
    self._slimeView=nil;
    [super viewDidUnload];
}
-(void)dealloc
{
    [usr removeObserver:self forKeyPath:@"badgeNumber" context:nil];
    self._tableView=nil;
    self.arr=nil;
    self._labery=nil;
    self._slimeView=nil;
    [super dealloc];
}
-(void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
 
}


@end
