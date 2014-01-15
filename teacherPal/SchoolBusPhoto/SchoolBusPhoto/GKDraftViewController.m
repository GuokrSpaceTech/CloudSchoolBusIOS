//
//  GKDraftViewController.m
//  SchoolBusPhoto
//
//  Created by CaiJingPeng on 14-1-10.
//  Copyright (c) 2014年 mactop. All rights reserved.
//

#import "GKDraftViewController.h"
#import "GKCoreDataManager.h"
#import "GKUserLogin.h"
#import "MovieDraft.h"
#import "GKSendMediaViewController.h"
#import "KKNavigationController.h"
@interface GKDraftViewController ()

@end

@implementation GKDraftViewController
@synthesize _tableView,dataArray;

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
    [(KKNavigationController *)self.navigationController setNavigationTouch:YES];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    titlelabel.text=NSLocalizedString(@"moviedraft", @"");
    
    self.view.backgroundColor = [UIColor colorWithRed:232/255.0 green:229/255.0 blue:220/255.0 alpha:1];
    
    UIButton *buttonBack=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    buttonBack.frame=CGRectMake(10, 5, 34, 35);
    [buttonBack setBackgroundImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [buttonBack setBackgroundImage:[UIImage imageNamed:@"backH.png"] forState:UIControlStateHighlighted];
    [navigationView addSubview:buttonBack];
    [buttonBack addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    
    GKUserLogin *user = [GKUserLogin currentLogin];
    self.dataArray = [NSMutableArray arrayWithArray:[GKCoreDataManager searchMovieDraftByUserid:[NSString stringWithFormat:@"%@",user.classInfo.classid]]];
    
    
    
    if (self.dataArray.count == 0)
    {
        UILabel *noDataLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 50)];
        noDataLab.center = CGPointMake(160, 160);
        noDataLab.text = NSLocalizedString(@"nodata", @"");
        noDataLab.textAlignment = UITextAlignmentCenter;
        noDataLab.backgroundColor = [UIColor clearColor];
        [self.view addSubview:noDataLab];
        [noDataLab release];
    }
    else
    {
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
        
        UITableView *tv = [[UITableView alloc]initWithFrame:CGRectMake(0, navigationView.frame.size.height+navigationView.frame.origin.y, 320, self.view.frame.size.height-( navigationView.frame.size.height+navigationView.frame.origin.y)) style:UITableViewStylePlain];
        tv.backgroundColor=[UIColor clearColor];
        tv.backgroundColor=[UIColor colorWithRed:232/255.0 green:229/255.0 blue:220/255.0 alpha:1];
        tv.backgroundView=nil;
        tv.delegate=self;
//        [tv setEditing:YES animated:YES];
        tv.dataSource=self;
        [self.view addSubview:tv];
        [tv release];
        
        self._tableView = tv;
    }
    
    
}
- (void)editDraft:(id)sender
{
    if (self._tableView.editing) {
        [self._tableView setEditing:NO animated:YES];
    }else{
        [self._tableView setEditing:YES animated:YES];
    }
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier=@"cell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell==nil)
    {
        cell=[[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
        
        UIImageView *thumbImgV = [[UIImageView alloc] initWithFrame:CGRectMake(15, 7, 50, 50)];
        thumbImgV.tag = 555;
        [cell.contentView addSubview:thumbImgV];
        [thumbImgV release];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(80, 7, 200, 50)];
        label.backgroundColor = [UIColor clearColor];
        label.tag = 666;
        label.font = [UIFont systemFontOfSize:13];
        [cell.contentView addSubview:label];
        [label release];
    }
    
    MovieDraft *draft = [self.dataArray objectAtIndex:indexPath.row];
    
    NSDate *createDate = [NSDate dateWithTimeIntervalSince1970:draft.createdate.intValue];
    NSDateFormatter *format = [[[NSDateFormatter alloc] init] autorelease];
    [format setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    if (draft.thumbnail) {
        UIImageView *imgV = (UIImageView *)[cell.contentView viewWithTag:555];
        imgV.image = [UIImage imageWithData:draft.thumbnail];
    }
    cell.backgroundColor = [UIColor clearColor];
    
    UILabel *textLabel = (UILabel *)[cell.contentView viewWithTag:666];
    textLabel.text = [format stringFromDate:createDate];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MovieDraft *draft = [self.dataArray objectAtIndex:indexPath.row];
    GKSendMediaViewController *sendMediaVC = [[GKSendMediaViewController alloc] init];
    sendMediaVC.moviePath = draft.moviepath;
    sendMediaVC.thumbnail = [UIImage imageWithData:draft.thumbnail];
    sendMediaVC.isPresent = YES;
    [self presentModalViewController:sendMediaVC animated:YES];
    [sendMediaVC release];
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 删除 数据库 和 本地视频文件
    MovieDraft *draft = [self.dataArray objectAtIndex:indexPath.row];
    [GKCoreDataManager removeMovieDraftByUserid:draft.userid moviePath:draft.moviepath];
    
    [[NSFileManager defaultManager] removeItemAtPath:draft.moviepath error:nil];

    [self.dataArray removeObjectAtIndex:indexPath.row];
    
    if (self.dataArray.count == 0) {
        editButton.hidden = YES;
        
        tableView.hidden = YES;
        
        UILabel *noDataLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 50)];
        noDataLab.center = CGPointMake(160, 160);
        noDataLab.text = NSLocalizedString(@"nodata", @"");
        noDataLab.textAlignment = UITextAlignmentCenter;
        noDataLab.backgroundColor = [UIColor clearColor];
        [self.view addSubview:noDataLab];
        [noDataLab release];
    }

    [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                     withRowAnimation:UITableViewRowAnimationFade];
    
    
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NSLocalizedString(@"删除", @"");
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

//- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    
//    return YES;
//}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65;
}

- (void)dealloc
{
    self._tableView = nil;
    self.dataArray = nil;
    [super dealloc];
}

-(void)back:(UIButton *)btn
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
