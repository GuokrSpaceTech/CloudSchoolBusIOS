



#import "ETSettingViewController.h"



@implementation ETSettingViewController

-(void)dealloc
{
    
    [super dealloc];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    ETSettingView *sv = [[ETSettingView alloc] initWithFrame:CGRectMake(0, 0, 320, (iphone5 ? 548 : 460) - 46 - 57)];
    [self.view addSubview:sv];
    [sv release];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (BOOL)shouldAutorotate
{
    return NO;
}


@end
