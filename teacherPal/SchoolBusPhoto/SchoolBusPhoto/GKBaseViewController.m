//
//  GKBaseViewController.m
//  SchoolBusPhoto
//
//  Created by wen peifang on 13-10-24.
//  Copyright (c) 2013年 mactop. All rights reserved.
//

#import "GKBaseViewController.h"

@interface GKBaseViewController ()

@end

@implementation GKBaseViewController
@synthesize titlelabel,navigationView;
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
    self.navigationController.navigationBarHidden=YES;
   // self.view.backgroundColor=[UIColor colorWithRed:103/255.0 green:183/255.0 blue:204/255.0 alpha:1];
    

    
    
  
    if (ios7)
    {
        _imageView11=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 20)];
        _imageView11.backgroundColor=[UIColor blackColor];
        [self.view addSubview:_imageView11];
        [_imageView11 release];

    }
    
    
    
    if (ios7)
        navigationView=[[UIView alloc]initWithFrame:CGRectMake(0, 0+IOS7OFFSET, 320, 46)];
    else
        navigationView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 46)];
    navigationView.backgroundColor=[UIColor clearColor];

    [self.view addSubview:navigationView];
    
    UIImageView *iamgeBG=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 46)];
    iamgeBG.image= IMAGENAME(IMAGEWITHPATH(@"navBarImage"));
   
    iamgeBG.backgroundColor=[UIColor clearColor];
    [navigationView addSubview:iamgeBG];
    [iamgeBG release];
  
    
//    UIView *bgView=[[UIView alloc]initWithFrame:CGRectMake(0, navigationView.frame.size.height+navigationView.frame.origin.y, 320, self.view.frame.size.height-(navigationView.frame.size.height+navigationView.frame.origin.y))];
//    bgView.backgroundColor=[UIColor colorWithRed:232/255.0 green:229/255.0 blue:220/255.0 alpha:1];
//    [self.view addSubview:bgView];
//    [bgView release];
    
    
    
    titlelabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 320, 46)];
    titlelabel.backgroundColor=[UIColor clearColor];
    titlelabel.text=@"";
    titlelabel.userInteractionEnabled=NO;
    titlelabel.textColor=[UIColor whiteColor];
    [navigationView addSubview:titlelabel];

    if(IOSVERSION>=6.0)
        titlelabel.textAlignment=NSTextAlignmentCenter;
    else
        titlelabel.textAlignment=UITextAlignmentCenter;
    
	// Do any additional setup after loading the view.
}
-(void)dealloc
{
    self.titlelabel=nil;
    self.navigationView=nil;
    [super dealloc];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
