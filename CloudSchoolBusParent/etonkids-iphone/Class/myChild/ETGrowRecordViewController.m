//
//  ETGrowRecordViewController.m
//  etonkids-iphone
//
//  Created by CaiJingPeng on 13-11-14.
//  Copyright (c) 2013年 wpf. All rights reserved.
//

#import "ETGrowRecordViewController.h"
#import "ETKids.h"

@interface ETGrowRecordViewController ()

@end

@implementation ETGrowRecordViewController

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
	// Do any additional setup after loading the view.
    
    
    UIImageView *navigationBackView=[[UIImageView alloc]initWithFrame:CGRectMake(0, ios7 ? 20 : 0, 320, NAVIHEIGHT)];
    navigationBackView.image=[UIImage imageNamed:@"navigationNoText.png"];
    [self.view addSubview:navigationBackView];
    [navigationBackView release];
    
    
    UIButton *leftButton =[UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setFrame:CGRectMake(0, 0, 50, 35)];
    [leftButton setCenter:CGPointMake(10 + 34/2, navigationBackView.frame.size.height/2 + (ios7 ? 20 : 0))];
    [leftButton setImage:[UIImage imageNamed:@"backBtnDefault_3.0.png"] forState:UIControlStateNormal];
    [leftButton setImage:[UIImage imageNamed:@"backBtnSel_3.0.png"] forState:UIControlStateHighlighted];
    [leftButton addTarget:self action:@selector(doClickCancel:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:leftButton];
    
    
    UILabel *middleLabel=[[UILabel alloc]initWithFrame:CGRectMake(160-100, 13 + (ios7 ? 20 : 0), 200, 20)];
    middleLabel.textAlignment=UITextAlignmentCenter;
    middleLabel.textColor=[UIColor whiteColor];
    middleLabel.text = LOCAL(@"chengzhangdangan", @"");
    middleLabel.backgroundColor=[UIColor clearColor];
    [self.view addSubview:middleLabel];
    [middleLabel release];
    
    
    mainTV = [[UITableView alloc] initWithFrame:CGRectMake(0, navigationBackView.frame.origin.y + navigationBackView.frame.size.height, 320, self.view.frame.size.height - NAVIHEIGHT - (ios7 ? 20 : 0)) style:UITableViewStylePlain];
    mainTV.dataSource = self;
    mainTV.delegate = self;
    [self.view addSubview:mainTV];
    [mainTV release];
    
//    NSArray *originArr = [NSArray arrayWithObjects:@"", nil]
    
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *secView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
    secView.backgroundColor = [UIColor redColor];
    secView.tag = 333 + section;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapSectionView:)];
    [secView addGestureRecognizer:tap];
    [tap release];
    
    return [secView autorelease];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"normal";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell==nil)
    {
        cell=[[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
//        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    cell.textLabel.text = @"1111";
    
    return cell;
}

- (void)tapSectionView:(UIGestureRecognizer *)sender
{
    int section = sender.view.tag%333;
    
//    mainTV inde
    
    if ([mainTV numberOfRowsInSection:section] != 0) {
//        mainTV deleteRowsAtIndexPaths:[NSArray arrayWithObjects:[], nil] withRowAnimation:<#(UITableViewRowAnimation)#>
//        [mainTV deleteSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationBottom];
    }else{
//        [mainTV inser]
    }
    
}


- (void)doClickCancel:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
