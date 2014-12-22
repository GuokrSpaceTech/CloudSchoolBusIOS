//
//  GKMessageView.m
//  etonkids-iphone
//
//  Created by wen peifang on 14-12-20.
//  Copyright (c) 2014年 wpf. All rights reserved.
//

#import "GKMessageView.h"
#import "ETKids.h"
#import "GKContactObj.h"
#import "GKLetterViewController.h"
#import "AppDelegate.h"
@implementation GKMessageView
-(void)dealloc
{
    self.tableView=nil;
    self.dataArr=nil;
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        middleLabel.text=@"最近留言";
        
        _dataArr=[[NSMutableArray alloc]init];
        UIButton *rightButton =[UIButton buttonWithType:UIButtonTypeCustom];
        [rightButton setFrame:CGRectMake(0, 0, 50, 35)];
        [rightButton setCenter:CGPointMake(320 - 10 - 34/2 , navigationBackView.frame.size.height/2)];
        [rightButton addTarget:self action:@selector(rightButtonClick:) forControlEvents:UIControlEventTouchUpInside];
       // [rightButton setImage:[UIImage imageNamed:@"OKBtn.png"] forState:UIControlStateNormal];
        //[rightButton setImage:[UIImage imageNamed:@"OKBtn_sel.png"] forState:UIControlStateHighlighted];
        [self addSubview:rightButton];
        
        
        UIImageView *txtBack = [[UIImageView alloc] initWithFrame:CGRectMake(15, 10 + NAVIHEIGHT, 291, 160)];
        txtBack.image = [UIImage imageNamed:@"SetingContent.png"];
        [self addSubview:txtBack];
        [txtBack release];
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NAVIHEIGHT, 320, self.frame.size.height - NAVIHEIGHT) style:UITableViewStylePlain];
        //        tv.backgroundView.backgroundColor = CELLCOLOR;
        _tableView.backgroundView = nil;
        _tableView.backgroundColor = CELLCOLOR;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [self addSubview:_tableView];
        
    
//        
//        UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(leftButtonClick:)];
//        swipe.direction = UISwipeGestureRecognizerDirectionRight;
//        [self addGestureRecognizer:swipe];
//        [swipe release];
        
        
        
        [self loadLatestMessage];
        
    }
    return self;
}


-(void)loadLatestMessage
{
    [[EKRequest Instance]EKHTTPRequest:lastestletter parameters:nil requestMethod:GET forDelegate:self];
}

-(void)getErrorInfo:(NSError *)error forMethod:(RequestFunction)method
{
    
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:LOCAL(@"alert", @"提示") message:LOCAL(@"busy", @"网络故障，请稍后重试") delegate:nil cancelButtonTitle:LOCAL(@"ok", @"确定") otherButtonTitles:nil, nil];
    [alert show];
    [alert release];
}

-(void)getEKResponse:(id)response forMethod:(RequestFunction)method resultCode:(int)code withParam:(NSDictionary *)param
{
  
    
    if(code==1&& method==lastestletter)
    {
        
        
        [_dataArr removeAllObjects];
        
        NSArray *arr=[NSJSONSerialization JSONObjectWithData:response options:0 error:NULL];
        
        for (int i=0; i<[arr count]; i++) {
            
            GKContactObj *obj=[[GKContactObj alloc]init];
            NSDictionary *dic=[arr objectAtIndex:i];
            obj.cnname=[dic objectForKey:@"cnname"];
            obj.type=[[dic objectForKey:@"content"] objectForKey:@"type"];
            obj.content=[[dic objectForKey:@"content"] objectForKey:@"content"];
            obj.from_id=[dic objectForKey:@"from_id"];
            obj.state=[dic objectForKey:@"state"];
            [_dataArr addObject:obj];
            [obj release];
            
        }
        
        [_tableView reloadData];
        
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataArr count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier=@"cell";
    UITableViewCell *cell=(UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell==nil)
    {
        cell=[[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        
        cell.backgroundColor=[UIColor clearColor];
        
        UILabel * nameLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 5, 100, 20)];
        nameLabel.backgroundColor=[UIColor clearColor];
        nameLabel.tag=100;
        [cell.contentView addSubview:nameLabel];
        [nameLabel release];
        
        
        
        UILabel *contentLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 25, 270, 20)];
        contentLabel.backgroundColor=[UIColor clearColor];
        contentLabel.tag=101;
        contentLabel.font=[UIFont systemFontOfSize:12];
        [cell.contentView addSubview:contentLabel];
        [contentLabel release];
        
        
        UIImageView *pointImageView=[[UIImageView alloc]initWithFrame:CGRectMake(self.frame.size.width-10-10, 20, 8, 8)];
        //pointImageView.image=IMAGENAME(IMAGEWITHPATH(@"yellowPoint"));;
        pointImageView.tag=102;
        [cell.contentView addSubview:pointImageView];
        [pointImageView release];
        
        
 
        
    }
    
    
    UILabel *nameLabel=(UILabel *)[cell.contentView viewWithTag:100];
    UILabel *contentLabel=(UILabel *)[cell.contentView viewWithTag:101];
    UIImageView *pointImageView=(UIImageView *)[cell.contentView viewWithTag:102];
    GKContactObj *obj=[_dataArr objectAtIndex:indexPath.row];
    
    nameLabel.text=obj.cnname;
    
    
    if([obj.type isEqualToString:@"txt"])
    {
        contentLabel.text=obj.content;
    }
    else
    {
        contentLabel.text=@"图片";
    }
    
    if([obj.state isEqualToString:@"1"])
    {
        pointImageView.image=[UIImage imageNamed:@"yellowPoint.png"];
    }
    else
    {
        pointImageView.image=nil;
    }
    
    
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AppDelegate *app = SHARED_APP_DELEGATE;
    GKContactObj *obj=[_dataArr objectAtIndex:indexPath.row];
    GKLetterViewController *letterViewController=[[GKLetterViewController alloc]init];
    letterViewController.contactObj=obj;
    
    [app.bottomNav pushViewController:letterViewController animated:YES];
 
    [letterViewController release];
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
