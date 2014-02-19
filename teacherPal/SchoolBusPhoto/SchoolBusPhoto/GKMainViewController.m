//
//  GKMainViewController.m
//  SchoolBusPhoto
//
//  Created by mactop on 10/19/13.
//  Copyright (c) 2013 mactop. All rights reserved.
//

#import "GKMainViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "GKAppDelegate.h"
#import "GKLoaderManager.h"
#import "GKSaySomethingView.h"
@interface GKMainViewController ()

@end

//@property (strong,nonatomic)RightSideBarViewController *rightSideBarViewController;
@implementation GKMainViewController
@synthesize leftViewController;
@synthesize _currentMainController;
@synthesize state;
const int ContentOffset=266;
const int ContentMinOffset=60;
const float MoveAnimationDuration = 0.3;
static  GKMainViewController*rootViewCon;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        
        
    }
    return self;
}
- (void)rightSideBarSelectWithController:(UIViewController *)controller
{
    
}
+ (id)share
{
    return rootViewCon;
}
-(void) getEKResponse:(id) response forMethod:(RequestFunction) method parm:(NSDictionary *)parm resultCode:(int) code
{
}
-(void) getErrorInfo:(NSError *) error forMethod:(RequestFunction) method
{
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    sideBarShowing=NO;
    currentTranslate=0;
    state=0;
    if (rootViewCon) {
        rootViewCon = nil;
    }
	rootViewCon = self;
    


//    self.contentView.layer.shadowOffset = CGSizeMake(0, 0);
//    self.contentView.layer.shadowColor = [UIColor blackColor].CGColor;
//    self.contentView.layer.shadowOpacity = 1;
   
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loginOUtNoti) name:@"LOGINOUTNOTI" object:nil];
    
    
    GKLeftViewController *leftVC=[[GKLeftViewController alloc]init];
    leftVC.delegate=self;
    UINavigationController *navgation=[[UINavigationController alloc]initWithRootViewController:leftVC];
    
    self.leftViewController=navgation;
    [navgation release];
    [leftVC release];
    
    
    
    [self addChildViewController:self.leftViewController];
    self.leftViewController.view.frame = self.bottomView.bounds;
    [self.bottomView addSubview:self.leftViewController.view];
    
    
    _panGestureReconginzer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panInContentView:)];
    _panGestureReconginzer.delegate=self;
    [self.contentView addGestureRecognizer:_panGestureReconginzer];
    [_panGestureReconginzer release];
    
   
    
    
    // Do any additional setup after loading thce view from its nib.
}
#pragma mark - side bar select delegate
- (void)leftSideBarSelectWithController:(UIViewController *)controller
{
    if ([controller isKindOfClass:[UINavigationController class]]) {
        [(UINavigationController *)controller setDelegate:self];
    }
    if (_currentMainController == nil) {
		controller.view.frame = self.contentView.bounds;
		self._currentMainController = controller;
		[self addChildViewController:_currentMainController];
		[self.contentView addSubview:_currentMainController.view];
		[_currentMainController didMoveToParentViewController:self];
	} else if (_currentMainController != controller && controller !=nil) {
		controller.view.frame = self.contentView.bounds;
		[_currentMainController willMoveToParentViewController:nil];
		[self addChildViewController:controller];
		self.view.userInteractionEnabled = NO;
		[self transitionFromViewController:_currentMainController
						  toViewController:controller
								  duration:0
								   options:UIViewAnimationOptionTransitionNone
								animations:^{}
								completion:^(BOOL finished){
									self.view.userInteractionEnabled = YES;
									[_currentMainController removeFromParentViewController];
									[controller didMoveToParentViewController:self];
									self._currentMainController = controller;
								}
         ];
	}
    
    [self showSideBarControllerWithDirection:SideBarShowDirectionNone];
}
- (void)showSideBarControllerWithDirection:(SideBarShowDirection)direction
{
    
    if (direction!=SideBarShowDirectionNone) {
        UIView *view=nil ;
        if (direction == SideBarShowDirectionLeft)
        {
            state=1;
            view = self.leftViewController.view;
        }else
        {
            return;
           // view = self.rightSideBarViewController.view;
        }
        [self.bottomView bringSubviewToFront:view];
    }
    state=0;
    [self moveAnimationWithDirection:direction duration:MoveAnimationDuration];
}
-(void)loginOut
{
  //  [[EKRequest Instance] EKHTTPRequest:s parameters:nil requestMethod:DELETE forDelegate:self];
    //[self performSelector:@selector(deselect) withObject:nil afterDelay:0.5f];

    
    GKAppDelegate *delegate= APPDELEGATE;
    
    delegate.loginVC.passWord.text=@"";
    

    [GKUserLogin clearpassword];

    [[GKLoaderManager createLoaderManager]setQueueStop];
    [self dismissViewControllerAnimated:YES completion:^{
            
    }];

    
}
-(void)loginOUtNoti
{
    [GKUserLogin clearpassword];
    [[GKLoaderManager createLoaderManager]setQueueStop];
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 增加 去除button 相应时间  扩大button 相应区域
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    UIView* touchedView = [touch view];
    for (UIView* next = [touchedView superview]; next; next = next.superview)
    {
        // 找到GKShowViewController 禁掉拖拽手势手势
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[GKShowViewController class]]) {
            return NO;
            
        }
 
    }
    if([touchedView isKindOfClass:[UIButton class]] ||[touchedView isKindOfClass:[GKSaySomethingView class]] || [touchedView isKindOfClass:[UITextView class]]) {
        
        return NO;
    }
    
    return YES;
}

- (void)panInContentView:(UIPanGestureRecognizer *)panGestureReconginzer
{
    [self.view endEditing:YES];
	if (panGestureReconginzer.state == UIGestureRecognizerStateChanged)
    {
        CGFloat translation = [panGestureReconginzer translationInView:self.contentView].x;
        if (translation+currentTranslate>0)
        self.contentView.transform = CGAffineTransformMakeTranslation(translation+currentTranslate, 0);
        UIView *view ;
        if (translation+currentTranslate>0)
        {
            view = self.leftViewController.view;
        }else
        {
            return;
        }
        [self.bottomView bringSubviewToFront:view];
        
	} else if (panGestureReconginzer.state == UIGestureRecognizerStateEnded)
    {
		currentTranslate = self.contentView.transform.tx;
        if (!sideBarShowing) {
            if (fabs(currentTranslate)<ContentMinOffset) {
                [self moveAnimationWithDirection:SideBarShowDirectionNone duration:MoveAnimationDuration];
            }else if(currentTranslate>ContentMinOffset)
            {
                [self moveAnimationWithDirection:SideBarShowDirectionLeft duration:MoveAnimationDuration];
            }else
            {
               // [self moveAnimationWithDirection:SideBarShowDirectionRight duration:MoveAnimationDuration];
            }
        }else
        {
            if (fabs(currentTranslate)<ContentOffset-ContentMinOffset) {
                [self moveAnimationWithDirection:SideBarShowDirectionNone duration:MoveAnimationDuration];
                
            }else if(currentTranslate>ContentOffset-ContentMinOffset)
            {
                
                [self moveAnimationWithDirection:SideBarShowDirectionLeft duration:MoveAnimationDuration];
                
            }else
            {
                //[self moveAnimationWithDirection:SideBarShowDirectionRight duration:MoveAnimationDuration];
            }
        }
        
        
	}
    
    
}
- (void)moveAnimationWithDirection:(SideBarShowDirection)direction duration:(float)duration
{
    
    
    void (^animations)(void) = ^{
		switch (direction) {
            case SideBarShowDirectionNone:
            {
                state=0;
                self.contentView.transform  = CGAffineTransformMakeTranslation(0, 0);
            }
                break;
            case SideBarShowDirectionLeft:
            {
                state=1;
                self.contentView.transform  = CGAffineTransformMakeTranslation(ContentOffset, 0);
                
            }
                break;
            case SideBarShowDirectionRight:
            {
                //self.contentView.transform  = CGAffineTransformMakeTranslation(-ContentOffset, 0);
            }
                break;
            default:
                break;
        }
	};
    void (^complete)(BOOL) = ^(BOOL finished) {
        self.contentView.userInteractionEnabled = YES;
        self.bottomView.userInteractionEnabled = YES;
        
        if (direction == SideBarShowDirectionNone) {
            
            if (_tapGestureRecognizer) {
                [self.contentView removeGestureRecognizer:_tapGestureRecognizer];
                _tapGestureRecognizer = nil;
            }
            sideBarShowing = NO;
            UIView *flowView=(UIView *)[self.contentView viewWithTag:5679];
            
            if(flowView)
            {
                [flowView removeFromSuperview];
                flowView=nil;
            }

            
        }else
        {
            
            UIView *tempview=(UIView *)[self.contentView viewWithTag:5679];
            
            if(tempview)
            {
             
            }
            else
            {
                UIView *flowView=nil;
                if(ios7)
                    flowView=[[UIView alloc]initWithFrame:CGRectMake(0, IOS7OFFSET+46, self.contentView.frame.size.width, self.contentView.frame.size.height-IOS7OFFSET-46)];
                else
                    
                    flowView=[[UIView alloc]initWithFrame:CGRectMake(0, 46, self.contentView.frame.size.width, self.contentView.frame.size.height-46)];
                
                flowView.tag=5679;
                flowView.backgroundColor=[UIColor blackColor];
                flowView.alpha=0;
                [self.contentView bringSubviewToFront:flowView];
                [self.contentView addSubview:flowView];
                [flowView release];
                
                
                [UIView animateWithDuration:0.3 animations:^{
                    flowView.alpha=0.5;
                }];
                

            }
            
            [self contentViewAddTapGestures];
            sideBarShowing = YES;
        }
        currentTranslate = self.contentView.transform.tx;
	};
    self.contentView.userInteractionEnabled = NO;
    self.bottomView.userInteractionEnabled = NO;
    [UIView animateWithDuration:duration animations:animations completion:complete];
}

- (void)contentViewAddTapGestures
{
    if (_tapGestureRecognizer) {
        [self.contentView   removeGestureRecognizer:_tapGestureRecognizer];
        _tapGestureRecognizer = nil;
    }
    
    _tapGestureRecognizer = [[UITapGestureRecognizer  alloc] initWithTarget:self action:@selector(tapOnContentView:)];
    [self.contentView addGestureRecognizer:_tapGestureRecognizer];
    [_tapGestureRecognizer release];
}
- (void)tapOnContentView:(UITapGestureRecognizer *)tapGestureRecognizer
{
    [self moveAnimationWithDirection:SideBarShowDirectionNone duration:MoveAnimationDuration];
}
- (void)dealloc {
   // [_bottomView release];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"LOGINOUTNOTI" object:nil];
    self.bottomView=nil;
   // [_contentView release];
    self.contentView=nil;
    self.leftViewController=nil;
    self._currentMainController=nil;
    [rootViewCon release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setBottomView:nil];
    [self setContentView:nil];
    [super viewDidUnload];
}
@end
