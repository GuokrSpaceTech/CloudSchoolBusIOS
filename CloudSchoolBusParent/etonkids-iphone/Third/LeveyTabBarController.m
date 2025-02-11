//
//  LeveyTabBarControllerViewController.m
//  LeveyTabBarController
//
//  Created by zhang on 12-10-10.
//  Copyright (c) 2012年 jclt. All rights reserved.
//
//

#import "LeveyTabBarController.h"
#import "LeveyTabBar.h"
#import "ETShowBigImageViewController.h"
#import "ETClassViewController.h"
#import "ETEducationViewController.h"
#define kTabBarHeight 57.0

static LeveyTabBarController *leveyTabBarController;

@implementation UIViewController (LeveyTabBarControllerSupport)

- (LeveyTabBarController *)leveyTabBarController
{
	return leveyTabBarController;
}

@end

@interface LeveyTabBarController (private)
- (void)displayViewAtIndex:(NSUInteger)index;
@end

@implementation LeveyTabBarController
@synthesize delegate = _delegate;
@synthesize selectedViewController = _selectedViewController;
@synthesize viewControllers = _viewControllers;
@synthesize selectedIndex = _selectedIndex;
@synthesize tabBarHidden = _tabBarHidden;
@synthesize animateDriect;

#pragma mark -
#pragma mark lifecycle
- (id)initWithViewControllers:(NSArray *)vcs imageArray:(NSArray *)arr withFrame:(CGRect)frame
{
	self = [super init];
	if (self != nil)
	{
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadBadge:) name:@"RELOADBADGE" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(BudgeHidden:) name:@"BUDGEHIDDEN" object:nil];
        
        
		_viewControllers = [[NSMutableArray arrayWithArray:vcs] retain];
        
		_containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, frame.size.height)];
        _containerView.backgroundColor = [UIColor blueColor];
//		_containerView.backgroundColor=[UIColor clearColor];
		_transitionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320.0f, _containerView.frame.size.height - kTabBarHeight)];
		_transitionView.backgroundColor = CELLCOLOR;
		
		_tabBar = [[LeveyTabBar alloc] initWithFrame:CGRectMake(0, _containerView.frame.size.height - kTabBarHeight, 320.0f, kTabBarHeight) buttonImages:arr];
		_tabBar.delegate = self;
//        _tabBar.backgroundColor=[UIColor clearColor];
        _tabBar.backgroundView.image = [UIImage imageNamed:@"tabbarBackGround.png"];
		
        leveyTabBarController = self;
        animateDriect = 0;
        
        
	}
	return self;
}

- (void)reloadBadge:(NSNotification *)info
{
    [[EKRequest Instance] EKHTTPRequest:status parameters:nil requestMethod:GET forDelegate:self];
}
- (void)getEKResponse:(id)response forMethod:(RequestFunction)method resultCode:(int)code withParam:(NSDictionary *)param
{
    if (method == status && code == 1) {
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:response options:nil error:nil];
        NSLog(@"new message number : %@",result);
        [_tabBar setBadgeNumber:result];
    }
}
- (void)getErrorInfo:(NSError *)error forMethod:(RequestFunction)method
{
    
}

- (void)loadView 
{
	[super loadView];
	
//	_containerView.frame=CGRectMake(0, 0, 320, self.view.frame.size.height);
//    _transitionView.frame=CGRectMake(0, 0, 320.0f, _containerView.frame.size.height - kTabBarHeight);
//    _tabBar.frame=CGRectMake(0, _containerView.frame.size.height - kTabBarHeight, 320.0f, kTabBarHeight);
	[_containerView addSubview:_transitionView];
	[_containerView addSubview:_tabBar];
	[self.view addSubview:_containerView];
    
    
    self.view.frame = CGRectMake(self.view.frame.origin.x,46, self.view.frame.size.width, self.view.frame.size.height);
//    NSLog(@"%f,%f",self.view.frame.origin.x,self.view.frame.size.height);
    
    _containerView.autoresizesSubviews=YES;
    _transitionView.autoresizesSubviews=YES;
    _tabBar.autoresizesSubviews=YES;
    self.view.autoresizesSubviews=YES;
    
    _containerView.autoresizingMask=UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin ;
    _transitionView.autoresizingMask=UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin ;
    _tabBar.autoresizingMask=UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin ;
    self.view.autoresizingMask=UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin ;
}

- (void)viewDidLoad 
{
    [super viewDidLoad];
    
    // 首次创建时 界面未完全更新 需延时加载
    [self performSelector:@selector(createFirstVC) withObject:nil afterDelay:0.00001f];
    
//    [self createFirstVC];
    
    
//    NSLog(@"%f,%f",self.view.frame.origin.x,self.view.frame.size.height);
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)createFirstVC
{
    if (self.selectedIndex == 0 || self.selectedIndex >= _viewControllers.count) {
        self.selectedIndex = 0;
    }
}

-(void)BudgeHidden:(NSNotification *)notification
{
   // eys:@"1",@"TYPE",
    NSDictionary *info=[notification userInfo];
    
    NSString  *result=[info objectForKey:@"TYPE"];
    
    [_tabBar setBadgeViewHidden:[result integerValue]];
    
    
}
-(void)BudgeShow:(NSNotification *)notification
{
    NSDictionary *info=[notification userInfo];
    
    NSDictionary *result=[info objectForKey:@"Budge"];
    
    NSString *num1=[result objectForKey:@"notice"];
    NSString *num2=[result objectForKey:@"article"];
    
    if(![num1 isEqualToString:@"0"] && num1!=nil)
    {
        [_tabBar setLabelText:num1 Function:2];
    }
    if(![num2 isEqualToString:@"0"] && num2 !=nil )
    {
         [_tabBar setLabelText:num2 Function:1];
    }
    
    
    //[_tabBar setLabelText:dd Function:2];
}
-(void)backLogin:(NSNotification *)no
{
    
    //[self dismissModalViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];

}
-(void)back:(NSNotification *)no
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
-(void)Hide:(NSNotification *)no
{
    NSDictionary *dic=[no userInfo];

    if([[dic objectForKey:@"Hide"] isEqualToString:@"0"])
    {
        [self hidesTabBar:YES animated:NO];
        [self setTabBarTransparent:YES];
    }
    else
    {
       [self hidesTabBar:NO animated:NO];
        [self setTabBarTransparent:NO];
    }
}
- (void)viewDidUnload
{
	[super viewDidUnload];
	
//	_tabBar = nil;
//	_viewControllers = nil;
}

- (void)dealloc 
{
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"TabBarHidden"  object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"backback"  object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"BUDGESHOW"  object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"BUDGEHIDDEN"  object:nil];
//    _tabBar.delegate = nil;
//	[_tabBar release];
//    [_containerView release];
//    [_transitionView release];
//    NSLog(@"~~~~~~~~~~~~~~~~~~~~~~~~~~~~%d",_viewControllers.retainCount);
//	[_viewControllers release];
    self.viewControllers = nil;
    [super dealloc];
}

#pragma mark - instant methods

- (LeveyTabBar *)tabBar
{
	return _tabBar;
}

- (BOOL)tabBarTransparent
{
	return _tabBarTransparent;
}

- (void)setTabBarTransparent:(BOOL)yesOrNo
{
	if (yesOrNo == YES)
	{
		_transitionView.frame = _containerView.bounds;
	}
	else
	{
		_transitionView.frame = CGRectMake(0, 0, 320.0f, _containerView.frame.size.height - kTabBarHeight);
	}
}




- (void)hidesTabBar:(BOOL)yesOrNO animated:(BOOL)animated
{
	if (yesOrNO == YES)
	{
		if (self.tabBar.frame.origin.y == self.view.frame.size.height)
		{
			return;
		}
	}
	else 
	{
		if (self.tabBar.frame.origin.y == self.view.frame.size.height - kTabBarHeight)
		{
			return;
		}
	}
	
	if (animated == YES)
	{
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.3f];
		if (yesOrNO == YES)
		{
			self.tabBar.frame = CGRectMake(self.tabBar.frame.origin.x, self.tabBar.frame.origin.y + kTabBarHeight, self.tabBar.frame.size.width, self.tabBar.frame.size.height);
		}
		else 
		{
			self.tabBar.frame = CGRectMake(self.tabBar.frame.origin.x, self.tabBar.frame.origin.y - kTabBarHeight, self.tabBar.frame.size.width, self.tabBar.frame.size.height);
		}
		[UIView commitAnimations];
	}
	else 
	{
		if (yesOrNO == YES)
		{
			self.tabBar.frame = CGRectMake(self.tabBar.frame.origin.x, self.tabBar.frame.origin.y + kTabBarHeight, self.tabBar.frame.size.width, self.tabBar.frame.size.height);
		}
		else 
		{
			self.tabBar.frame = CGRectMake(self.tabBar.frame.origin.x, self.tabBar.frame.origin.y - kTabBarHeight, self.tabBar.frame.size.width, self.tabBar.frame.size.height);
		}
	}
}


- (NSUInteger)selectedIndex
{
	return _selectedIndex;
}
- (UIViewController *)selectedViewController
{
    return [_viewControllers objectAtIndex:_selectedIndex];
}

-(void)setSelectedIndex:(NSUInteger)index
{
    [self displayViewAtIndex:index];
    [_tabBar selectTabAtIndex:index];
}

- (void)removeViewControllerAtIndex:(NSUInteger)index
{
    if (index >= [_viewControllers count])
    {
        return;
    }
    // Remove view from superview.
    [[(UIViewController *)[_viewControllers objectAtIndex:index] view] removeFromSuperview];
    // Remove viewcontroller in array.
    [_viewControllers removeObjectAtIndex:index];
    // Remove tab from tabbar.
    [_tabBar removeTabAtIndex:index];
}

- (void)insertViewController:(UIViewController *)vc withImageDic:(NSDictionary *)dict atIndex:(NSUInteger)index
{
    [_viewControllers insertObject:vc atIndex:index];
    [_tabBar insertTabWithImageDic:dict atIndex:index];
}


#pragma mark - Private methods
- (void)displayViewAtIndex:(NSUInteger)index
{
    // Before change index, ask the delegate should change the index.
    if ([_delegate respondsToSelector:@selector(tabBarController:shouldSelectViewController:)]) 
    {
        if (![_delegate tabBarController:self shouldSelectViewController:[self.viewControllers objectAtIndex:index]])
        {
            return;
        }
    }
    // If target index if equal to current index, do nothing.
    if (_selectedIndex == index && [[_transitionView subviews] count] != 0) 
    {
        return;
    }
    NSLog(@"Display View.");
    NSInteger preSelectedIndex = _selectedIndex;
    _selectedIndex = index;
    
	UIViewController *selectedVC = [self.viewControllers objectAtIndex:index];
	NSLog(@"transitionview height : %f , %f",_transitionView.frame.size.height,_transitionView.frame.origin.y);
	selectedVC.view.frame = _transitionView.frame;
    
    NSLog(@"selectedvc height : %f , %f",selectedVC.view.frame.size.height,selectedVC.view.frame.origin.y);
    
    
    [[_viewControllers objectAtIndex:preSelectedIndex] viewWillDisappear:YES];
	if ([selectedVC.view isDescendantOfView:_transitionView]) 
	{
        
		[_transitionView bringSubviewToFront:selectedVC.view];
        [selectedVC viewWillAppear:YES];
	}
	else
	{
		[_transitionView addSubview:selectedVC.view];
	}
    
    // Notify the delegate, the viewcontroller has been changed.
    if ([_delegate respondsToSelector:@selector(tabBarController:didSelectViewController:)]) 
    {
        [_delegate tabBarController:self didSelectViewController:selectedVC];
    }
    
//    NSLog(@"containerview height : %f , %f",_containerView.frame.size.height,_containerView.frame.origin.y);
    
//

}

#pragma mark -
#pragma mark tabBar delegates
- (void)tabBar:(LeveyTabBar *)tabBar didSelectIndex:(NSInteger)index
{
	if (self.selectedIndex == index) {
        UINavigationController *nav = [self.viewControllers objectAtIndex:index];
        [nav popToRootViewControllerAnimated:YES];
    }else {
        [self displayViewAtIndex:index];
        [_tabBar selectTabAtIndex:index];
    }
    
//    if (index != 3) {
//        ETEducationViewController *eduVC = [self.viewControllers objectAtIndex:3];
//        [eduVC setAllBlockNormal];
//    }
}


- (BOOL)shouldAutorotate
{
    return NO;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    //    if([[self selectedViewController] isKindOfClass:[子类 class]])
    return toInterfaceOrientation==UIInterfaceOrientationPortrait;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationPortrait;
}

@end
