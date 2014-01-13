//
//  GKImagePickerViewController.m
//  SchoolBusPhoto
//
//  Created by wen peifang on 13-10-22.
//  Copyright (c) 2013年 mactop. All rights reserved.
//

#import "GKImagePickerViewController.h"
#import "ETPhoto.h"
#import "GKLoaderManager.h"
#import "AVCamViewController.h"

#import <QuartzCore/QuartzCore.h>
#import "UpLoader.h"


#define UPBUTTONTAG 1000
@interface GKImagePickerViewController ()

@end

@implementation GKImagePickerViewController
@synthesize imageArr;
@synthesize selectArr;
@synthesize countLabel;
//@synthesize _slimeView;
//@synthesize libery;
@synthesize group_;
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
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(LoadPhotoIfDeviceActive) name:@"ACTIVEPHOTO" object:nil];
    
    
    if(imageArr==nil)
        imageArr=[[NSMutableArray alloc]init];
    else
        [imageArr removeAllObjects];

 // 存放选中的照片
    selectArr=[[NSMutableArray alloc]init];

    UIButton *buttonBack=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    buttonBack.frame=CGRectMake(10, 5, 34, 35);
    [buttonBack setBackgroundImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [buttonBack setBackgroundImage:[UIImage imageNamed:@"backH.png"] forState:UIControlStateHighlighted];
    [navigationView addSubview:buttonBack];
    [buttonBack addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];

    

    
    
    
    
    
//    UIButton *photobutton=[UIButton buttonWithType:UIButtonTypeCustom];
//    photobutton.frame=CGRectMake(280, 5, 35, 35);
//    [photobutton setBackgroundImage:IMAGENAME(IMAGEWITHPATH(@"photoBtn")) forState:UIControlStateNormal];
//    [photobutton setBackgroundImage:IMAGENAME(IMAGEWITHPATH(@"photoBtnH")) forState:UIControlStateHighlighted];
//    [photobutton addTarget:self action:@selector(takePhoto:) forControlEvents:UIControlEventTouchUpInside];
//    [navigationView addSubview:photobutton];
    
 
    
//    usr=[GKUserLogin currentLogin];
// 
//    [usr addObserver:self forKeyPath:@"badgeNumber" options:NSKeyValueObservingOptionNew context:NULL];
//    
//    titlelabel.text=usr.classInfo.classname;

    NSLog(@"%f",self.view.frame.size.height);
    if(ios7)
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, IOS7OFFSET+46, self.view.frame.size.width, self.view.frame.size.height-46-IOS7OFFSET - 45) style:UITableViewStylePlain];
    else
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 46, self.view.frame.size.width, self.view.frame.size.height-46 - 45) style:UITableViewStylePlain];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.backgroundColor=[UIColor colorWithRed:232/255.0 green:229/255.0 blue:220/255.0 alpha:1];
    [self.view addSubview:_tableView];
    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [_tableView release];
    
    UIView *bottomview=[[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height-45, 320, 45)];
    bottomview.backgroundColor=[UIColor colorWithPatternImage:IMAGENAME(IMAGEWITHPATH(@"bottomView"))];
    [self.view addSubview:bottomview];
    [bottomview release];
    
    countLabel=[[UILabel alloc]initWithFrame:CGRectMake(255, 5, 60, 35)];
    countLabel.backgroundColor=[UIColor clearColor];
    [bottomview addSubview:countLabel];
    countLabel.textColor=[UIColor whiteColor];
    countLabel.font=[UIFont systemFontOfSize:15];
    countLabel.text=[NSString stringWithFormat:@""];
    if(IOSVERSION>=6.0)
        countLabel.textAlignment=NSTextAlignmentCenter;
    else
        countLabel.textAlignment=UITextAlignmentCenter;
    
//    _slimeView = [[SRRefreshView alloc] init];
//    _slimeView.delegate = self;
//    _slimeView.upInset = 0;
//    _slimeView.slimeMissWhenGoingBack = YES;
//    _slimeView.slime.bodyColor = [UIColor blackColor];
//    _slimeView.slime.skinColor = [UIColor blackColor];
//    _slimeView.slime.lineWith = 1;
//    _slimeView.slime.shadowBlur = 4;
//    _slimeView.slime.shadowColor = [UIColor blackColor];
//    
//    [_tableView addSubview:self._slimeView];
    
    
 //   libery=[[ALAssetsLibrary alloc] init];

    
    UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];

    button.frame=CGRectMake(30, 4, 225, 37);
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitle:NSLocalizedString(@"UpPic", @"") forState:UIControlStateNormal];
    [button setBackgroundImage:IMAGENAME(IMAGEWITHPATH(@"upbuttonH"))  forState:UIControlStateNormal];
    [button setBackgroundImage:IMAGENAME(IMAGEWITHPATH(@"upbutton")) forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(upLoaderClilck:) forControlEvents:UIControlEventTouchUpInside];
    [bottomview addSubview:button];
    

    
    UIView *noView=[[UIView alloc]initWithFrame:CGRectMake(320/2.0-303/4,self.view.frame.size.height/2.0-262/4-30, 303/2, 262/2+30) ];
    noView.tag=232;
    UIImageView *noImage=[[UIImageView alloc]initWithFrame:CGRectMake(0,0, 303/2, 262/2)];
    noImage.image=IMAGENAME(IMAGEWITHPATH(@"NOData"));
    [noView addSubview:noImage];
    [noImage release];
    
    UIButton *instancebutton=[UIButton buttonWithType:UIButtonTypeCustom];
    instancebutton.frame=CGRectMake(25, 262/2,  100, 30);
    [self.view addSubview:noView];
    [noView release];
    
     titlelabel.text=[group_ valueForProperty:ALAssetsGroupPropertyName];
    [self setNOView:YES];
    
    NSLog(@"----------%@",[NSDate date]);
    
    [self loadPhoto];
    
    //450 75
   // [self performSelectorInBackground:@selector(<#selector#>) withObject:<#(id)#>];
	// Do any additional setup after loading the view.
}

-(void)back:(UIButton *)btn
{
    
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)setNOView:(BOOL)an
{
    UIView *view=[self.view viewWithTag:232];
    
    view.hidden=an;
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [(KKNavigationController *)self.navigationController setNavigationTouch:YES];
}
//-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
//{
//    //if([keyPath isEqualToString:@"badgeNumber"])
//    //{
//        
//        badgeView.bagde=[usr.badgeNumber integerValue];
//        //myLabel.text = [stockForKVO valueForKey:@"price"];
//   // }
//}

-(void)LoadPhotoIfDeviceActive
{
    [self loadPhoto];
}
-(void)refreashPickViewController:(NSArray *)arr
{
    
    if(arr==nil)
    {
        [self setAllPhotoSelect:NO];
            [selectArr removeAllObjects];
        [_tableView reloadData];
        return;
    }
    [selectArr removeAllObjects];
      countLabel.text=[NSString stringWithFormat:@"%d/%d",0,[imageArr count]];
    if([arr count] >0)
    {
       // GKLoaderManager *manager=[GKLoaderManager createLoaderManager];
       // NSArray *coreArr= [manager getAllUploaderPhotoFromCoreData];
        
        for (int i=0; i<[arr count]; i++) {
            ETPhoto *photo=[arr objectAtIndex:i];
            
//            NSArray * arr =[photo.asset valueForProperty:ALAssetPropertyRepresentations];
//            NSDictionary *dic=[photo.asset valueForProperty:ALAssetPropertyURLs];
//            NSString *pid=[NSString stringWithFormat:@"%@",[dic objectForKey:[arr objectAtIndex:0]]];
            
//            NSArray *keydd=[photo.asset valueForProperty:ALAssetPropertyRepresentations];
//            NSDictionary *dic=[photo.asset valueForProperty:ALAssetPropertyURLs];
//            NSString *pid= [NSString stringWithFormat:@"%@",[dic objectForKey:[keydd objectAtIndex:0]]];
            
            //NSLog(@"??????%@",loader.nameID);
            for (int j=0; j<[imageArr count]; j++) {
                ETPhoto *temp=[imageArr objectAtIndex:j];
                //NSLog(@"~~~~~~~~~~~%@",photo.nameId);
                
//                NSArray * arr1 =[temp.asset valueForProperty:ALAssetPropertyRepresentations];
//                NSDictionary *dic1=[temp.asset valueForProperty:ALAssetPropertyURLs];
//                NSString *pid1=[NSString stringWithFormat:@"%@",[dic1 objectForKey:[arr1 objectAtIndex:0]]];

                
                if([photo.nameId isEqualToString:temp.nameId])
                {
                    [imageArr removeObject:photo];
                }
            }
        }

        if([imageArr count]==0)
        {
            [self setNOView:NO];
        }
        else
            [self setNOView:YES];
        [_tableView reloadData];
    }
    
}
//-(void)takePhoto:(UIButton *)btn
//{
//    
//
//    AVCamViewController *avVC=[[AVCamViewController alloc]initWithNibName:@"AVCamViewController" bundle:nil];
//    [self.navigationController pushViewController:avVC animated:YES];
//    [avVC release];
//
//    
//}
//-(void)leftClick:(UIButton *)btn
//{
//    
//    GKMainViewController *main=[GKMainViewController share];
//    if(main.state==0)
//    {
//        if ([[GKMainViewController share] respondsToSelector:@selector(showSideBarControllerWithDirection:)]) {
//            [[GKMainViewController share] showSideBarControllerWithDirection:SideBarShowDirectionLeft];
//        }
//    }
//    else
//    {
//        if ([[GKMainViewController share] respondsToSelector:@selector(showSideBarControllerWithDirection:)]) {
//            [[GKMainViewController share] showSideBarControllerWithDirection:SideBarShowDirectionNone];
//        }
//    }
//    
//  
// 
//}

-(void)loadPhoto
{
    
    [imageArr removeAllObjects];
    [_tableView reloadData];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
      
        ALAssetsFilter *fiter=[ALAssetsFilter allPhotos];
       
       // NSLog(@"%d",group_.numberOfAssets);
        
        [group_ setAssetsFilter:fiter];
        [group_ enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
            
            if(result)
            {
                
                ETPhoto *photo=[[ETPhoto alloc]init];
                photo.isSelected=NO;
                photo.asset=result;
                
                //NSLog(@"%@",[result defaultRepresentation].url);
                //NSDate *date= [result valueForProperty:ALAssetPropertyDate];
                photo.date=[result valueForProperty:ALAssetPropertyDate];
//                NSArray *key=[result valueForProperty:ALAssetPropertyRepresentations];
//                NSDictionary *dic=[result valueForProperty:ALAssetPropertyURLs];
//                photo.nameId= [NSString stringWithFormat:@"%@",[dic objectForKey:[key objectAtIndex:0]]];
                //NSLog(@"_____________%@",photo.nameId);
                
                  photo.nameId= [NSString stringWithFormat:@"%@",[result defaultRepresentation].url];
                
                [imageArr insertObject:photo atIndex:0];
                [photo release];
                
            }
            else
            {
                
                GKLoaderManager *manager=[GKLoaderManager createLoaderManager];
                NSArray *arr= [manager getAllUploaderPhotoFromCoreData];
                for (NSObject *obj in arr) {
                //for (int i=0; i<[arr count]; i++) {
                   // UpLoader *loader=[arr objectAtIndex:i];
                    UpLoader *loader=(UpLoader *)obj;
                    //NSLog(@"??????%@",loader.nameID);
                    for (int j=0; j<[imageArr count]; j++) {
                        ETPhoto *photo=[imageArr objectAtIndex:j];
                        //NSLog(@"~~~~~~~~~~~%@",photo.nameId);
                        
                        //NSLog(@"????%@",[photo.asset valueForProperty:ALAssetPropertyRepresentations]);
                        
//                        NSArray *keydd=[photo.asset valueForProperty:ALAssetPropertyRepresentations];
//                        NSDictionary *dic=[photo.asset valueForProperty:ALAssetPropertyURLs];
//                        NSString *pid= [NSString stringWithFormat:@"%@",[dic objectForKey:[keydd objectAtIndex:0]]];
                        
                        if([loader.nameID isEqualToString:photo.nameId])
                        {
                            [imageArr removeObject:photo];
                        }
                    }
                }

                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [_tableView reloadData];
                 
                    if([imageArr count]>0)
                    {
                        [self setNOView:YES];
                         countLabel.text=[NSString stringWithFormat:@"%d/%d",0,[imageArr count]];
                    }
                    else
                    {
                        [self setNOView:NO];
                    }
                });
                
            }
            
        }];

        
    });
    
    
}


-(void)upLoaderClilck:(UIButton *)btn
{
    if([selectArr count]==0)
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"alert", @"") message:NSLocalizedString(@"pic", @"") delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        return;
    }

    GKShowViewController *showVC=[[GKShowViewController alloc]init];
    showVC.assetArr=self.selectArr;
    showVC.type=1;
    showVC.delegate=self;
    
//    [self.navigationController presentViewController:showVC animated:NO completion:^{
//    }];
    
    [self.navigationController pushViewController:showVC animated:YES];

   // [self.navigationController pushViewController:showVC animated:YES];
    
    [showVC release];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return ceil( (float)imageArr.count/4 );
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellDefiner=@"cell";
    
    ETPhotoCell *cell=(ETPhotoCell *)[tableView dequeueReusableCellWithIdentifier:cellDefiner];
    if(cell==nil)
    {
        cell=[[[ETPhotoCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellDefiner] autorelease];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell.delegate=self;
    }
    
    int first=indexPath.row *4;
    int last=first+4;
    
    int currentIndex=0;
    int c =MIN(last, imageArr.count);
    NSLog(@"-------------------------%d",c);
    for ( ; first+currentIndex < c; currentIndex++) {
        ETPhoto *photo= [imageArr objectAtIndex:currentIndex+first];
        // ALAsset *aset= [assetsArr objectAtIndex:currentIndex+first];
        UIImage *image = [UIImage imageWithCGImage: [photo.asset thumbnail]];
        switch (currentIndex) {
            case 0:
            {
                cell.imageView1.image=image;
                cell.isSelect1=photo.isSelected;
                cell.imageView1.userInteractionEnabled=YES;
                cell.imageView1.tag=first+currentIndex;
                
                cell.imageView2.image=nil;
                cell.isSelect2=NO;
                cell.imageView2.userInteractionEnabled=NO;
                cell.imageView3.image=nil;
                cell.isSelect3=NO;
                cell.imageView3.userInteractionEnabled=NO;
                cell.imageView4.image=nil;
                cell.isSelect4=NO;
                cell.imageView4.userInteractionEnabled=NO;
            }
                break;
                
            case 1:
            {
                cell.imageView2.image=image;
                cell.isSelect2=photo.isSelected;
                cell.imageView2.tag=first+currentIndex;
                cell.imageView2.userInteractionEnabled=YES;
                
                
                cell.imageView3.image=nil;
                cell.isSelect3=NO;
                cell.imageView3.userInteractionEnabled=NO;
                cell.imageView4.image=nil;
                cell.isSelect4=NO;
                cell.imageView4.userInteractionEnabled=NO;
            }
                break;
            case 2:
            {
                cell.imageView3.image=image;
                cell.isSelect3=photo.isSelected;
                cell.imageView3.tag=first+currentIndex;
                cell.imageView3.userInteractionEnabled=YES;
                
                cell.imageView4.image=nil;
                cell.isSelect4=NO;
                cell.imageView4.userInteractionEnabled=NO;
            }
                break;
            case 3:
            {
                cell.imageView4.image=image;
                cell.isSelect4=photo.isSelected;
                cell.imageView4.tag=first+currentIndex;
                cell.imageView4.userInteractionEnabled=YES;
            }
                break;
            default:
                break;
        }
    }
    
    return cell;
}



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}
-(void)setAllPhotoSelect:(BOOL)an
{
    for (int i=0; i<[selectArr count]; i++) {
        ETPhoto *photo=[selectArr objectAtIndex:i];
        
        photo.isSelected=an;
        
    }
    if(!an)
    {
        
          countLabel.text=[NSString stringWithFormat:@"%d/%d",0,[imageArr count]];
        [selectArr removeLastObject];
    }
   
    else
    {
        [selectArr removeAllObjects];
        self.selectArr=[NSMutableArray arrayWithArray:self.imageArr];
        countLabel.text=[NSString stringWithFormat:@"%d/%d",[selectArr count],[imageArr count]];
    }
    
    [_tableView reloadData];
}
-(void)selectPhoto:(int)tag select:(BOOL)an

{
    NSLog(@"%d---------tag :%d",an,tag);
    

    ETPhoto *photo=[imageArr objectAtIndex:tag];
    
    photo.isSelected=an;

    if(an)
    {
        BOOL found=NO;
        for (int i=0; i<[selectArr count]; i++) {
            
            ETPhoto *temp= [selectArr objectAtIndex:i];
            
            if([temp isEqual:photo])
            {
                
                found=YES;
            }
            
        }
        if(!found)
            [selectArr addObject:photo];
        
    }
    else
    {
        for (int i=0; i<[selectArr count]; i++) {
            
            ETPhoto *temp= [selectArr objectAtIndex:i];
            
            if([temp isEqual:photo])
            {
                [selectArr removeObject:photo];
                
            }
            
        }
        
    
    }
    
    if([selectArr count]>9)
    {

       
     

        
       // ETPhoto *photo=[imageArr objectAtIndex:tag];
        photo.isSelected=NO;
        [selectArr removeObject:photo];
        [_tableView reloadData];
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"alert", @"") message:NSLocalizedString(@"maxpic", @"")  delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        return;
    }
    
    if([selectArr count]==0)
    {
          countLabel.text=[NSString stringWithFormat:@"%d/%d",0,[imageArr count]];
    }
    else
    {
        countLabel.text=[NSString stringWithFormat:@"%d/%d",[selectArr count],[imageArr count]];
    }
    
    
    
}
    // [self uploadUI];
    
   // [tableView_ reloadData];

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    
//    if (self._slimeView) {
//        [self._slimeView scrollViewDidScroll];
//    }
//    
//}
//
//- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
//{
//    if (self._slimeView) {
//        [self._slimeView scrollViewDidEndDraging];
//    }
//    
//
//}
//- (void)slimeRefreshStartRefresh:(SRRefreshView *)refreshView
//{
//    NSLog(@"start refresh");
//    //    [self showHUD:YES];
//    [self loadImageFromPick];
//    //theRefreshPos = EGORefreshHeader;
//    //[self requestNoticeData:nil];
//}
-(void)dealloc
{

    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"ACTIVEPHOTO" object:nil];
    
    [imageArr removeAllObjects];
    [selectArr removeAllObjects];
    self.imageArr=nil;
    self.selectArr=nil;
//    self._slimeView=nil;
    self.countLabel=nil;
    self.group_=nil;
//    self.libery=nil;
    [super dealloc];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
