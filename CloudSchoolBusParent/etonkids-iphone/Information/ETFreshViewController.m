//
//  ETFreshViewController.m
//  etonkids-iphone
//
//  Created by wen peifang on 13-7-11.
//  Copyright (c) 2013年 wpf. All rights reserved.
//

#import "ETFreshViewController.h"
#import "UserLogin.h"
#import "keyedArchiver.h"
@interface ETFreshViewController ()

@end

@implementation ETFreshViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)removeFooterView
{
    if(_refreshFooterView && [_refreshFooterView superview])
    {
        [_refreshFooterView removeFromSuperview];
    }
    _refreshFooterView = nil;
}

-(void)setFooterView
{
    UserLogin * user = (UserLogin *)[keyedArchiver getArchiver:@"LOGIN" forKey:@"LOGIN"];
    if(user.loginStatus==LOGIN_SERVER)
    {
        [self removeFooterView];
        CGFloat height = MAX(_tableView.contentSize.height, _tableView.frame.size.height);
        if(_refreshFooterView && [_refreshFooterView superview])
        {
            _refreshFooterView.frame = CGRectMake(0.0f, height, _tableView.frame.size.width, _tableView.bounds.size.height);
        }
        else
        {
            _refreshFooterView = [[LoadMoreTableFooterView alloc] initWithFrame:CGRectMake(0.0f, height, _tableView.frame.size.width, _tableView.bounds.size.height)];
            _refreshFooterView.delegate = self;
            [_tableView addSubview:_refreshFooterView];
            _refreshFooterView.backgroundColor=[UIColor clearColor];
        }

    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UserLogin * user = (UserLogin *)[keyedArchiver getArchiver:@"LOGIN" forKey:@"LOGIN"];
    if(user.loginStatus==LOGIN_SERVER)
    {
        if(_refreshHeaderView && [_refreshHeaderView superview])
        {
            [_refreshHeaderView removeFromSuperview];
        }
        _refreshHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - _tableView.bounds.size.height, self.view.frame.size.width, _tableView.bounds.size.height)];
        _refreshHeaderView.delegate = self;
        _refreshFooterView.backgroundColor=[UIColor clearColor];
        [_tableView addSubview:_refreshHeaderView];
        [_refreshHeaderView refreshLastUpdatedDate];

        return;
    }

    
    
   
	// Do any additional setup after loading the view.
}

#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
	if(_refreshHeaderView)
    {
        [_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    }
    if(_refreshFooterView)
    {
        [_refreshFooterView egoRefreshScrollViewDidScroll:scrollView];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
	if(_refreshHeaderView)
    {
        [_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
    }
    if(_refreshFooterView)
    {
        [_refreshFooterView egoRefreshScrollViewDidEndDragging:scrollView];
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotate
{
    //    if ([self isKindOfClass:[ETShowBigImageViewController class]]) { // 如果是这个 vc 则支持自动旋转
    //        return YES;
    //    }
    return NO;
}

//- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
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
