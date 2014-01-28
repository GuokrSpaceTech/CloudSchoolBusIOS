//
//  GKImagePickerViewController.m
//  SchoolBusPhoto
//
//  Created by wen peifang on 13-10-22.
//  Copyright (c) 2013年 mactop. All rights reserved.
//

#import "GKImagePickerViewController.h"
#import "ETPhoto.h"
#import "GKAppDelegate.h"
#import "GKBadgeView.h"
#import "GKLoaderManager.h"
#import <QuartzCore/QuartzCore.h>
#import "UpLoader.h"
#import "DBManager.h"

#define UPBUTTONTAG 1000
@interface GKImagePickerViewController ()

@end

@implementation GKImagePickerViewController
@synthesize imageArr;
@synthesize selectArr;
//@synthesize countLabel;
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
    
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(LoadPhotoIfDeviceActive) name:@"ACTIVEPHOTO" object:nil];
    
    // 增加监听 ，当相册相片改变时 执行
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(LoadPhotoIfDeviceActive:) name:ALAssetsLibraryChangedNotification object:nil];
    //ALAssetsLibraryChangedNotification
    if(imageArr==nil)
        imageArr=[[NSMutableArray alloc]init];
    else
        [imageArr removeAllObjects];

 // 存放选中的照片
    selectArr=[[NSMutableArray alloc]init];

    UIButton *buttonBack=[UIButton buttonWithType:UIButtonTypeCustom];
    buttonBack.frame=CGRectMake(10, 5, 34, 35);
    [buttonBack setBackgroundImage:IMAGENAME(IMAGEWITHPATH(@"back")) forState:UIControlStateNormal];
    [buttonBack setBackgroundImage:IMAGENAME(IMAGEWITHPATH(@"backH")) forState:UIControlStateHighlighted];
    [navigationView addSubview:buttonBack];
    [buttonBack addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];

    NSLog(@"%f",self.view.frame.size.height);
    if(ios7)
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, IOS7OFFSET+46, self.view.frame.size.width, self.view.frame.size.height-46-IOS7OFFSET) style:UITableViewStylePlain];
    else
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 46, self.view.frame.size.width, self.view.frame.size.height-46) style:UITableViewStylePlain];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.backgroundColor=[UIColor colorWithRed:232/255.0 green:229/255.0 blue:220/255.0 alpha:1];
    [self.view addSubview:_tableView];
    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [_tableView release];
    
    
    
    
    delButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [delButton setBackgroundImage:IMAGENAME(IMAGEWITHPATH(@"delN")) forState:UIControlStateNormal];
    [delButton setBackgroundImage:IMAGENAME(IMAGEWITHPATH(@"delH")) forState:UIControlStateHighlighted];
    [delButton setFrame:CGRectMake(self.view.frame.size.width/2.0-35/2, self.view.frame.size.height-35-5, 35, 35)];
    [delButton addTarget:self action:@selector(deleteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:delButton];
    delButton.hidden=YES;
    
    
    photobutton=[UIButton buttonWithType:UIButtonTypeCustom];
    photobutton.frame=CGRectMake(280, 5, 35, 35);
    [photobutton setBackgroundImage:[UIImage imageNamed:@"upNormal.png"] forState:UIControlStateNormal];
    [photobutton setBackgroundImage:[UIImage imageNamed:@"upHight.png"] forState:UIControlStateHighlighted];
    [photobutton addTarget:self action:@selector(upLoaderClilck:) forControlEvents:UIControlEventTouchUpInside];
    [navigationView addSubview:photobutton];

  //    badgeView=[[GKBadgeView alloc]initWithFrame:CGRectMake(38, 2, 16, 16)];
    badgeView =[[GKBadgeView alloc]initWithFrame:CGRectMake(300, 2, 16, 16)];
    badgeView.backgroundColor=[UIColor clearColor];
    badgeView.bagde=0;
    [navigationView addSubview:badgeView];
    [badgeView release];
    
    
//    UIView *bottomview=[[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height-45, 320, 45)];
//    bottomview.backgroundColor=[UIColor colorWithPatternImage:IMAGENAME(IMAGEWITHPATH(@"bottomView"))];
//    [self.view addSubview:bottomview];
//    [bottomview release];
//    
//    countLabel=[[UILabel alloc]initWithFrame:CGRectMake(255, 5, 60, 35)];
//    countLabel.backgroundColor=[UIColor clearColor];
//    [bottomview addSubview:countLabel];
//    countLabel.textColor=[UIColor whiteColor];
//    countLabel.font=[UIFont systemFontOfSize:15];
//    countLabel.text=[NSString stringWithFormat:@""];
//    if(IOSVERSION>=6.0)
//        countLabel.textAlignment=NSTextAlignmentCenter;
//    else
//        countLabel.textAlignment=UITextAlignmentCenter;
    
//    UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
//
//    button.frame=CGRectMake(30, 4, 225, 37);
//    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [button setTitle:NSLocalizedString(@"UpPic", @"") forState:UIControlStateNormal];
//    [button setBackgroundImage:IMAGENAME(IMAGEWITHPATH(@"upbuttonH"))  forState:UIControlStateNormal];
//    [button setBackgroundImage:IMAGENAME(IMAGEWITHPATH(@"upbutton")) forState:UIControlStateHighlighted];
//    [button addTarget:self action:@selector(upLoaderClilck:) forControlEvents:UIControlEventTouchUpInside];
//    [bottomview addSubview:button];
    

    
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

-(void)deleteBtnClick:(UIButton *)btn
{
    // 把 数据加入到数据库
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"忽略照片" message:@"选择忽略后，改照片将不再程序中显示，并不会删除照片，你依然可以在相册中查看" delegate:self cancelButtonTitle:NSLocalizedString(@"no", @"") otherButtonTitles:NSLocalizedString(@"yes", @""), nil];
    [alert show];
    [alert release];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==0)
    {
       
    }
    else
    {
        //把 数据加入到数据库
       
        
        
        [self performSelectorInBackground:@selector(addIgnore:) withObject:nil];
    
  //  [manager addNewPicToCoreData:filename name:representation.filename iSloading:[NSNumber numberWithInt:1] nameId:photo.nameId studentId:studentId time:[NSNumber numberWithInt:ftime] fsize:[NSNumber numberWithInt:representation.size] classID:[NSNumber numberWithInt:[user.classInfo.uid integerValue]] intro:introduce data:UIImageJPEGRepresentation(thumbiamge, 0.5) tag:@""];// 图片tag
        

    }
}
-(void)addIgnore:(id)sender
{
   // GKLoaderManager *manager=[GKLoaderManager createLoaderManager];
    for (int i=0; i<[selectArr count]; i++) {
        ETPhoto *photo=[selectArr objectAtIndex:i];
        
        
        [[DBManager shareInstance]insertObject:^(NSManagedObject *object) {
            UpLoader *aa=(UpLoader *)object;
            aa.image=@"";
            aa.nameID=photo.nameId;
            aa.classUid=[NSNumber numberWithInt:0];
            aa.name=@"";
            aa.studentId=@"";
            aa.fsize=[NSNumber numberWithInt:0];
            aa.ftime=[NSNumber numberWithInt:0];
            aa.introduce=@"";
            aa.tag=@"";
            aa.isUploading=[NSNumber numberWithInt:2];
            aa.smallImage=nil;
            
        } entityName:@"UpLoader" success:^{
            
            
            NSLog(@"cccccfggggg");
            
            //[manager addWraperToArr:filename name:representation.filename iSloading:[NSNumber numberWithInt:1] nameId:photo.nameId studentId:studentId time:[NSNumber numberWithInt:ftime] fsize:[NSNumber numberWithInt:representation.size] classID:[NSNumber numberWithInt:[user.classInfo.uid integerValue]] intro:introduce data:UIImageJPEGRepresentation(thumbiamge, 0.5) tag:@""];
            
            
        } failed:^(NSError *err) {
            NSLog(@"ssssbbbbbbb");
        }];

        
        //[manager addNewPicToCoreData:@"" name:@"" iSloading:[NSNumber numberWithInt:2] nameId:photo.nameId studentId:@"" time:[NSNumber numberWithInt:0] fsize:[NSNumber numberWithInt:0] classID:[NSNumber numberWithInt:0] intro:@"" data:nil tag:@""];// 图片tag
    }
    
    [self performSelectorOnMainThread:@selector(uploadUI) withObject:nil waitUntilDone:YES];
}
-(void)uploadUI
{

  
    if([selectArr count] >0)
    {
        // GKLoaderManager *manager=[GKLoaderManager createLoaderManager];
        // NSArray *coreArr= [manager getAllUploaderPhotoFromCoreData];
        
        for (int i=0; i<[selectArr count]; i++) {
            ETPhoto *photo=[selectArr objectAtIndex:i];
            for (int j=0; j<[imageArr count]; j++) {
                ETPhoto *temp=[imageArr objectAtIndex:j];

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
      
    
    }
    
    [selectArr removeAllObjects];
    [self setAllPhotoSelect:NO];
    [_tableView reloadData];
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"alert", @"") message:@"忽略成功" delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:nil, nil];
    [alert show];
    [alert release];
}
//-(id)retain {
//    return [super retain];
//}
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
    delButton.hidden = YES;
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

-(void)LoadPhotoIfDeviceActive:(NSNotification *)no
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
     // countLabel.text=[NSString stringWithFormat:@"%d/%d",0,[imageArr count]];
    
    [self playAnimation:0];
    
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
    
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        [imageArr removeAllObjects];
        [self setAllPhotoSelect:NO];
        [selectArr removeAllObjects];
        [_tableView reloadData];
        
      
        ALAssetsFilter *fiter=[ALAssetsFilter allPhotos];
       
       // NSLog(@"%d",group_.numberOfAssets);
        
        [group_ setAssetsFilter:fiter];
        [group_ enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
            
            if(result)
            {
                
                ETPhoto *photo=[[ETPhoto alloc]init];
                photo.isSelected=NO;
                photo.asset=result;
                
                photo.date=[result valueForProperty:ALAssetPropertyDate];
                photo.nameId= [NSString stringWithFormat:@"%@",[result defaultRepresentation].url];
                if(photo.nameId)  // 如果图片删除，判断该照片是否为空 ，如果为空就不加入到数组
                    [imageArr insertObject:photo atIndex:0];
                [photo release];
                
            }
            else
            {
                
               // GKLoaderManager *manager=[GKLoaderManager createLoaderManager];
               // NSArray *arr= [manager getAllUploaderPhotoFromCoreData];
                
                
                GKAppDelegate *delegate=APPDELEGATE;
                NSEntityDescription *entity=[NSEntityDescription entityForName:@"UpLoader" inManagedObjectContext:delegate.managedObjectContext];
               
                NSFetchRequest *request=[[NSFetchRequest alloc]init];
                [request setEntity:entity];
                


                
                [[DBManager shareInstance]retriveObject:request success:^(NSArray *array) {
                    for (NSObject *obj in array) {
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
                            // countLabel.text=[NSString stringWithFormat:@"%d/%d",0,[imageArr count]];
                            [self playAnimation:0];
                        }
                        else
                        {
                            [self setNOView:NO];
                        }
                    });
                    

                } failed:^(NSError *err) {
                    
                }];
                
                
                
                
                
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
   // showVC.type=1;
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
        
       // countLabel.text=[NSString stringWithFormat:@"%d/%d",0,[imageArr count]];
       
        [selectArr removeAllObjects];
        [self playAnimation:0];
        delButton.hidden=YES;
    }
   
    else
    {
        [selectArr removeAllObjects];
        self.selectArr=[NSMutableArray arrayWithArray:self.imageArr];
        [self playAnimation:[selectArr count]];
      //  countLabel.text=[NSString stringWithFormat:@"%d/%d",[selectArr count],[imageArr count]];
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
       // countLabel.text=[NSString stringWithFormat:@"%d/%d",0,[imageArr count]];
        
        [self playAnimation:0];
        
        
        delButton.hidden=YES;
    }
    else
    {
        //countLabel.text=[NSString stringWithFormat:@"%d/%d",[selectArr count],[imageArr count]];
        delButton.hidden=NO;
        [self playAnimation:[selectArr count]];
    }
    
    
    
}
-(void)playAnimation:(int)a
{
    CABasicAnimation *an=[CABasicAnimation animationWithKeyPath:@"transform.scale"];
    
    an.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    an.duration =0.15;
    an.repeatCount = 1;
    //an.autoreverses = YES;
    an.fromValue = [NSNumber numberWithFloat:0.2];
    an.toValue = [NSNumber numberWithFloat:1.0];
    [badgeView.layer addAnimation:an forKey:@"dfdf"];
    
    badgeView.bagde=a;

}
-(void)dealloc
{

     [[NSNotificationCenter defaultCenter]removeObserver:self name:ALAssetsLibraryChangedNotification object:nil];
   // [[NSNotificationCenter defaultCenter]removeObserver:self name:@"ACTIVEPHOTO" object:nil];
        [imageArr removeAllObjects];
    [selectArr removeAllObjects];
    self.imageArr=nil;
    self.selectArr=nil;
//    self._slimeView=nil;
    //self.countLabel=nil;
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
