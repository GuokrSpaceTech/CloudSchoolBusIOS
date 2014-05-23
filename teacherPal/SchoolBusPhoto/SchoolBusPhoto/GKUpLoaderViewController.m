//
//  GKUpLoaderViewController.m
//  SchoolBusPhoto
//
//  Created by mactop on 10/19/13.
//  Copyright (c) 2013 mactop. All rights reserved.
//

#import "GKUpLoaderViewController.h"
#import "KKNavigationController.h"
#import "GKLoaderManager.h"
#import "GKUpQueue.h"

#import "DBManager.h"
#import "GKMainViewController.h"

@interface GKUpLoaderViewController ()

@end

@implementation GKUpLoaderViewController
@synthesize _tableView;
@synthesize upArr;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [(KKNavigationController *)self.navigationController setNavigationTouch:NO];
}
-(void)removieFinished:(NSNotification *)no
{
    NSString *key=[[no userInfo]objectForKey:@"key"];
    
    for (int i=0; i<[upArr count]; i++) {
        
        GKUpObject *obj=[upArr objectAtIndex:i];
        if([obj.nameID isEqualToString:key])
        {
            [upArr removeObject:obj];
        }
    }
    if([upArr count]==0)
    {
        [self setNOView:NO];
         editButton.hidden=YES;
    }
    else
    {
        [self setNOView:YES];
        editButton.hidden=NO;
    }
    [_tableView reloadData];

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
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    NSNotificationCenter *center=[NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(removieFinished:) name:@"changeupload" object:nil];
    
 

    
  //  self.navigationItem.title=@"上传队列";
    
  
    UIButton *buttonBack=[UIButton buttonWithType:UIButtonTypeCustom];
    buttonBack.frame=CGRectMake(10, 5, 34, 35);
    [buttonBack setBackgroundImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [buttonBack setBackgroundImage:[UIImage imageNamed:@"backH.png"] forState:UIControlStateHighlighted];
    [navigationView addSubview:buttonBack];
    [buttonBack addTarget:self action:@selector(leftClick:) forControlEvents:UIControlEventTouchUpInside];
    
    

    if (editButton == nil) {
        editButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [editButton setBackgroundImage:[[UIImage imageNamed:@"navbar-button-blue-active"] stretchableImageWithLeftCapWidth:3 topCapHeight:15] forState:UIControlStateNormal];
        [editButton setBackgroundImage:[[UIImage imageNamed:@"navbar-button-blue"] stretchableImageWithLeftCapWidth:3 topCapHeight:15] forState:UIControlStateHighlighted];
        [editButton setBackgroundImage:[[UIImage imageNamed:@"navbar-button-blue"] stretchableImageWithLeftCapWidth:3 topCapHeight:15] forState:UIControlStateSelected];
        [editButton setTitle:NSLocalizedString(@"draftedit", @"") forState:UIControlStateNormal];
        [editButton setFrame:CGRectMake(320 - 50 - 10, (navigationView.frame.size.height - 30)/2, 50, 30)];
        editButton.titleLabel.font = [UIFont systemFontOfSize:13];
        [editButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [editButton addTarget:self action:@selector(editDraft:) forControlEvents:UIControlEventTouchUpInside];
        [navigationView addSubview:editButton];
    }

    if(ios7)
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, IOS7OFFSET+46, self.view.frame.size.width, self.view.frame.size.height-46-IOS7OFFSET) style:UITableViewStylePlain];
    else
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 46, self.view.frame.size.width, self.view.frame.size.height-46) style:UITableViewStylePlain];
    _tableView.delegate=self;
    _tableView.dataSource=self;
  //  _tableView.backgroundColor=[UIColor clearColor];
    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
      _tableView.backgroundColor=[UIColor colorWithRed:232/255.0 green:229/255.0 blue:220/255.0 alpha:1];
    [self.view addSubview:_tableView];
    
    upArr=[[NSMutableArray alloc]init];
    titlelabel.text=NSLocalizedString(@"uplist", @"");
   
    
    
    
    UIView *bottomView=[[UIView alloc]initWithFrame:CGRectMake(0,self.view.frame.size.height-30, 320, 30)];
    bottomView.backgroundColor=[UIColor colorWithRed:93/255.0 green:177/255.0 blue:201/255.0 alpha:1];
    [self.view addSubview:bottomView];
    numLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 5, 310, 20)];
    numLabel.backgroundColor=[UIColor clearColor];
    numLabel.font=[UIFont systemFontOfSize:14];
    numLabel.textColor=[UIColor whiteColor];
    [bottomView addSubview:numLabel];
    [numLabel release];
    
    [bottomView release];
    
    
    
    
    UIView *noView=[[UIView alloc]initWithFrame:CGRectMake(0,self.view.frame.size.height/2.0-167/2-30, 320, 157+60) ];
    noView.tag=232;
    UIImageView *noImage=[[UIImageView alloc]initWithFrame:CGRectMake(320/2-150/2,0, 150, 157)];
    noImage.image=IMAGENAME(IMAGEWITHPATH(@"smilik"));
    [noView addSubview:noImage];
    [noImage release];
    
    UILabel *instancelabel=[[UILabel alloc]initWithFrame:CGRectMake(20, 157,  280, 40)];
    instancelabel.backgroundColor=[UIColor clearColor];
    instancelabel.numberOfLines=0;
    instancelabel.textColor=[UIColor colorWithRed:93/255.0 green:177/255.0 blue:201/255.0 alpha:1];
    if(IOSVERSION>=6.0)
        instancelabel.textAlignment=NSTextAlignmentCenter;
    else
        instancelabel.textAlignment=UITextAlignmentCenter;
    NSString *contentstr=NSLocalizedString(@"uploadsuccess", @"");
    
    CGSize size=[contentstr sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(280, 100) lineBreakMode:NSLineBreakByWordWrapping];
    
    instancelabel.frame=CGRectMake(20, 157, 280, size.height);
    instancelabel.text=contentstr;
   // instancelabel.text=@"恭喜你，所有照片已上传成功！";
    //instancelabel.text=@"Congratulations, all photos have been uploaded successfully";
    instancelabel.font=[UIFont systemFontOfSize:14];

    [noView addSubview:instancelabel];
    [instancelabel release];
    [self.view addSubview:noView];
    [noView release];
    
    
    [self setNOView:YES];

     [self loadUploading];
    
    [[EKRequest Instance]EKHTTPRequest:uploadimg parameters:nil requestMethod:GET forDelegate:self];
    
    
    
    
	// Do any additional setup after loading the view.
}
-(void)setNOView:(BOOL)an
{
    UIView *view=[self.view viewWithTag:232];
    
    view.hidden=an;
}
-(void) getEKResponse:(id) response forMethod:(RequestFunction) method parm:(NSDictionary *)parm resultCode:(int) code
{
    
    NSLog(@"code = %d",code);
    if(method==uploadimg)
    {
        if(code==1)
        {
            
            NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:response options:0 error:nil];
            if(dic!=nil)
            {
                NSString *numstr=[NSString stringWithFormat:@"%@%@%@ %@%@%@",NSLocalizedString(@"uptotle", @""),[dic objectForKey:@"zongshu"],NSLocalizedString(@"zhang", @""),NSLocalizedString(@"upvedio", @""),[dic objectForKey:@"mp4zongshu"],NSLocalizedString(@"zhang", @"")];
                numLabel.text=numstr;
            }
            
        }
    }
}
-(void) getErrorInfo:(NSError *) error forMethod:(RequestFunction) method
{
//    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"alert", @"") message:NSLocalizedString(@"network", @"") delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:nil, nil];
//    [alert show];
//    [alert release];
}

-(void)loadUploading
{
    
    GKAppDelegate *delegate=APPDELEGATE;
    
    
    NSEntityDescription *entity=[NSEntityDescription entityForName:@"UpLoader" inManagedObjectContext:delegate.managedObjectContext];
    NSPredicate *pred=[NSPredicate predicateWithFormat:@"(isUploading = %@)",[NSNumber numberWithInt:1]];
    NSFetchRequest *request=[[[NSFetchRequest alloc]init] autorelease];
    [request setEntity:entity];
    [request setPredicate:pred];
    [[DBManager shareInstance]retriveObject:request success:^(NSArray *array) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            for (int i=0; i<[array count]; i++) {
                UpLoader *loader=[array objectAtIndex:i];
                
                GKUpObject *wraper=[[GKUpObject alloc]init];
                
                
                wraper.name=loader.name;
                
                wraper.image=loader.image;
                wraper.nameID=loader.nameID;
                wraper.name=loader.name;
                wraper.ftime=loader.ftime;
                
                
                [upArr addObject:wraper];
                
                [wraper release];
                
            }
            
            
            if([upArr count]==0)
            {
                [self setNOView:NO];
                editButton.hidden=YES;
            }
            else
            {
                [self setNOView:YES];
                editButton.hidden=NO;
                
            }
            
            [_tableView reloadData];
        });
        

    } failed:^(NSError *err) {
        
    }];
    
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        
//        GKAppDelegate *delegate=APPDELEGATE;
//        
//        
//        NSEntityDescription *entity=[NSEntityDescription entityForName:@"UpLoader" inManagedObjectContext:delegate.managedObjectContext];
//        NSPredicate *pred=[NSPredicate predicateWithFormat:@"(isUploading = %@)",[NSNumber numberWithInt:1]];
//        NSFetchRequest *request=[[NSFetchRequest alloc]init];
//        [request setEntity:entity];
//        [request setPredicate:pred];
//        NSError *err=nil;
//        NSArray *arr=[delegate.managedObjectContext executeFetchRequest:request error:&err];
//        [request release];
//        
//        
//        
//        for (int i=0; i<[arr count]; i++) {
//            UpLoader *loader=[arr objectAtIndex:i];
//            
//            GKUpObject *wraper=[[GKUpObject alloc]init];
//            
//            
//            wraper.name=loader.name;
//            
//            wraper.image=loader.image;
//            wraper.nameID=loader.nameID;
//            wraper.name=loader.name;
//            wraper.ftime=loader.ftime;
//            
//            
//            [upArr addObject:wraper];
//            
//            [wraper release];
//            
//        }
//        
//        
//    dispatch_async(dispatch_get_main_queue(), ^{
//        if([upArr count]==0)
//        {
//            [self setNOView:NO];
//        }
//        else
//            [self setNOView:YES];
//        [_tableView reloadData];
//
//    });
//        
//        
//});
//    
    
    

}

- (void)editDraft:(id)sender
{
    if (self._tableView.editing) {
        [self._tableView setEditing:NO animated:YES];
        [editButton setTitle:NSLocalizedString(@"draftedit", @"") forState:UIControlStateNormal];
    }else{
        [self._tableView setEditing:YES animated:YES];
        
        [editButton setTitle:NSLocalizedString(@"finish", @"") forState:UIControlStateNormal];

    }
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [upArr count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    NSString *cellIdentifier=@"cell";//;[NSString stringWithFormat:@"cell%d",indexPath.row];
    GKUploaderCell *cell=(GKUploaderCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell==nil)
    {
        cell=[[[GKUploaderCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];

        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    
 
  //  cell.textLabel.text=pathID;
    GKUpObject *obj=[upArr objectAtIndex:indexPath.row];

    NSString *pathID=obj.nameID;
    GKUpWraper *wraper=[GKFindWraper getBookWrapper:pathID];
    cell.upwraper=wraper;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
//   if([[GKUpQueue creatQueue].queue operationCount ] == 0)
//   {
//        [[GKLoaderManager createLoaderManager] setQueueStart];
//   }
    GKAppDelegate *delegate=APPDELEGATE;
    if([delegate connectedToNetWork])
    {
        if([[[GKUpQueue creatQueue] asiQueue] operationCount]==0)
        {
            [[GKLoaderManager createLoaderManager] setQueueStart];
        }
    }
    else
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"alert", @"") message:NSLocalizedString(@"network", @"") delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }

}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}



- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 删除 数据库 和 本地视频文件
    
    
    //[[GKLoaderManager createLoaderManager] setQueueStop];
   // -(void)removeQueueAqueuest:(NSString *)nameid;

    
    
    GKUpObject *obj=[upArr objectAtIndex:indexPath.row];
    GKUpWraper * wraper= [GKFindWraper getBookWrapper:obj.nameID];
    [[GKUpQueue creatQueue]removeQueueAqueuest:obj.nameID];
    [self.upArr removeObjectAtIndex:indexPath.row];
    [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                     withRowAnimation:UITableViewRowAnimationFade];
    [[GKUpQueue creatQueue] ChageCoreDataDeleteOrUoloadingAlter:NO picId:wraper.nameid picPath:wraper.path];
    //[[GKLoaderManager createLoaderManager] startUpLoader];
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NSLocalizedString(@"delete", @"");
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"changeupload" object:nil];

    self._tableView=nil;
    self.upArr=nil;
    [super dealloc];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
