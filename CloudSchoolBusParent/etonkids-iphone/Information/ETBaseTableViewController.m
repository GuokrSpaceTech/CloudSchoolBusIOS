//
//  ETBaseTableViewController.m
//  etonkids-iphone
//
//  Created by wen peifang on 13-7-10.
//  Copyright (c) 2013年 wpf. All rights reserved.
//

#import "ETBaseTableViewController.h"
#define NAVIHEIGHT 44
@interface ETBaseTableViewController ()

@end

@implementation ETBaseTableViewController
@synthesize _tableView;
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
    
          
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, NAVIHEIGHT, 320, self.view.frame.size.height-NAVIHEIGHT) style:UITableViewStylePlain];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    self._tableView=nil;
    [super dealloc];
}

- (BOOL)shouldAutorotate
{
    //    if ([self isKindOfClass:[ETShowBigImageViewController class]]) { // 如果是这个 vc 则支持自动旋转
    //        return YES;
    //    }
    return NO;
}

//- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
//
//{
//    
//    //    if([[self selectedViewController] isKindOfClass:[子类 class]])
//    return NO;
//    
//}
//- (NSUInteger)supportedInterfaceOrientations
//{
//    return UIInterfaceOrientationLandscapeLeft | UIInterfaceOrientationLandscapeRight | UIInterfaceOrientationPortrait;
//}


@end
