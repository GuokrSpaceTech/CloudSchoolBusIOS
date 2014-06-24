//
//  ETMyAccountView.m
//  etonkids-iphone
//
//  Created by CaiJingPeng on 13-10-30.
//  Copyright (c) 2013年 wpf. All rights reserved.
//

#import "ETMyAccountView.h"
#import "ETKids.h"
#import "ETForgetPasswordViewController.h"
#import "ETChangeBindViewController.h"
#import "ETChildManagerViewController.h"
#import "ETCoreDataManager.h"

@implementation ETMyAccountView
@synthesize mainTV;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        
        
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateMyAccount) name:@"UPDATEMYACCOUNT" object:nil];
        
        middleLabel.text = LOCAL(@"btm_myaccount", @"");
        
        UITableView *tv = [[UITableView alloc] initWithFrame:CGRectMake(0, NAVIHEIGHT, 320, self.frame.size.height - NAVIHEIGHT) style:UITableViewStyleGrouped];
        //        tv.backgroundView.backgroundColor = CELLCOLOR;
        tv.backgroundView = nil;
        tv.backgroundColor = CELLCOLOR;
        tv.delegate = self;
        tv.dataSource = self;
        [self addSubview:tv];
        [tv release];
        
        UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(leftButtonClick:)];
        swipe.direction = UISwipeGestureRecognizerDirectionRight;
        [self addGestureRecognizer:swipe];
        [swipe release];
        
        self.mainTV = tv;
        
    }
    return self;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"section0";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell==nil)
    {
        cell=[[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    
    }
    


    [[cell.contentView viewWithTag:111] removeFromSuperview];
    [[cell.contentView viewWithTag:222] removeFromSuperview];
    [[cell.contentView viewWithTag:333] removeFromSuperview];
    [[cell.contentView viewWithTag:444] removeFromSuperview];
    
    UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 16, 16)];
    imgV.center = CGPointMake(26, 30);
    imgV.tag=333;
    [cell.contentView addSubview:imgV];
    [imgV release];
    
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(50, 15, 200, 30)];
    label.font = [UIFont systemFontOfSize:TITLEFONTSIZE - 3];
    label.backgroundColor = [UIColor clearColor];
    label.tag=444;
    label.text=@"";
    [cell.contentView addSubview:label];
    [label release];
    
    

    
    UILabel *msgLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    msgLabel.font = [UIFont systemFontOfSize:TITLEFONTSIZE - 3];
    msgLabel.backgroundColor = [UIColor clearColor];
    msgLabel.textColor = [UIColor grayColor];
    msgLabel.tag = 111;
    [cell.contentView addSubview:msgLabel];
    [msgLabel release];
    
    UILabel *msgLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(320 - 40 - 50, 15, 50, 30)];
    msgLabel1.font = [UIFont systemFontOfSize:TITLEFONTSIZE - 3];
    msgLabel1.backgroundColor = [UIColor clearColor];
    msgLabel1.textColor = [UIColor blueColor];
    msgLabel1.tag = 222;
    [cell.contentView addSubview:msgLabel1];
    [msgLabel1 release];
    
    UserLogin *user = [UserLogin currentLogin];
    
    if (indexPath.row == 0)
    {
        NSString *str = LOCAL(@"myaccount_account", @"账户名：");
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        imgV.image = [UIImage imageNamed:@"myaccount1.png"];
        label.text = str;
        msgLabel1.hidden = YES;
        
        CGSize size = [str sizeWithFont:label.font constrainedToSize:CGSizeMake(1000, 30) lineBreakMode:NSLineBreakByWordWrapping];
        label.frame = CGRectMake(50, 15, size.width, 30);
        msgLabel.frame = CGRectMake(50 + size.width, 15, 90, 30);
        
        msgLabel.text = user.username;
        
    }
    else if (indexPath.row == 1)
    {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        imgV.image = [UIImage imageNamed:@"myaccount2.png"];
        msgLabel1.hidden = NO;
        
        if (user.ischeck_mobile.intValue == 0)
        {
            //如果未绑定
            label.text = LOCAL(@"myaccount_unbind",@"未绑定手机号");
            msgLabel.hidden = YES;
            msgLabel1.text = LOCAL(@"myaccount_bind", @"绑定");
        }
        
        else
        {
            // 已绑定
            label.text = LOCAL(@"myaccount_binded", @"已绑定手机号：");
            msgLabel.hidden = NO;
            
            CGSize size = [label.text sizeWithFont:label.font constrainedToSize:CGSizeMake(1000, 30) lineBreakMode:NSLineBreakByWordWrapping];
            label.frame = CGRectMake(50, 15, size.width, 30);
            msgLabel.frame = CGRectMake(50 + size.width, 15, 100, 30);
            
            msgLabel.text = [NSString stringWithFormat:@"%@****%@",[user.mobile substringToIndex:3],[user.mobile substringFromIndex:7]];
            msgLabel1.text = LOCAL(@"myaccount_change", @"更改");
        }
        
    }
    else
    {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        imgV.frame = CGRectMake(0, 0, 18, 16);
        imgV.center = CGPointMake(26, 30);
        imgV.image = [UIImage imageNamed:@"myaccount3.png"];
        
        NSArray * arr = [ETCoreDataManager getUsers:user.regName];
        
        label.text = [NSString stringWithFormat:LOCAL(@"myaccount_link", @"已关联%d个孩子"),arr.count];
        msgLabel1.hidden = YES;
        msgLabel.hidden = YES;
    }
    
    
    
    return cell;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 1)
    {
        [self bindMobile];
    }
    else if (indexPath.row == 2)
    {
        [self toChildren];
    }
}

- (void)bindMobile
{
    
    AppDelegate *appDel = SHARED_APP_DELEGATE;
    UserLogin *user = [UserLogin currentLogin];
    
    // 如果 未绑定  进入绑定页面
    
    if (user.ischeck_mobile.intValue == 0)
    {
        ETForgetPasswordViewController *bindVC = [[ETForgetPasswordViewController alloc] init];
        bindVC.isBind = YES;
        [appDel.bottomNav pushViewController:bindVC animated:YES];
        [bindVC release];
    }
    else
    {
        // 如果 已绑定 进入修改绑定页面
        
        ETChangeBindViewController *cbVC = [[ETChangeBindViewController alloc] init];
        [appDel.bottomNav pushViewController:cbVC animated:YES];
        [cbVC release];
    }
    
    
}

- (void)toChildren
{
    ETChildManagerViewController *cmVC = [[ETChildManagerViewController alloc] init];
    AppDelegate *appDel = SHARED_APP_DELEGATE;
    [appDel.bottomNav pushViewController:cmVC animated:YES];
    [cmVC release];
}

- (void)updateMyAccount
{
    [self.mainTV reloadData];
}
- (void)dealloc
{
    self.mainTV = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"UPDATEMYACCOUNT" object:nil];
    
    [super dealloc];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
