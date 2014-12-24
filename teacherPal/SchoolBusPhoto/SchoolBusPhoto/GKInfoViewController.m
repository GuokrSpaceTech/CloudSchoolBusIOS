//
//  GKInfoViewController.m
//  SchoolBusPhoto
//
//  Created by wen peifang on 13-10-22.
//  Copyright (c) 2013年 mactop. All rights reserved.
//

#import "GKInfoViewController.h"
#import "GKMarketGird.h"
#import "GKMarket.h"

#import "GKUserLogin.h"
#import "KKNavigationController.h"
#import "GKAppDelegate.h"
#define TAGMARKET 222
@interface GKInfoViewController ()

@end

@implementation GKInfoViewController
@synthesize _tableView;
@synthesize dataArr;
@synthesize alreadyArr;
@synthesize buymarket;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)back:(UIButton *)btn
{
    
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [(KKNavigationController *)self.navigationController setNavigationTouch:YES];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    //    [user addObserver:self forKeyPath:@"credit_orders" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:NULL];
//    [user addObserver:self forKeyPath:@"credit" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:NULL];
    titlelabel.text=NSLocalizedString(@"credits", @"");
    
//    GKMarketGird *girdView=[[GKMarketGird alloc]initWithFrame:CGRectMake(100, 200, 190/2+10 , 190/2 +10 + 30)];
//    girdView.backgroundColor=[UIColor redColor];
//    [self.view addSubview:girdView];
    
    UIButton *buttonBack=[UIButton buttonWithType:UIButtonTypeCustom];
    buttonBack.frame=CGRectMake(10, 5, 34, 35);
    [buttonBack setBackgroundImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [buttonBack setBackgroundImage:[UIImage imageNamed:@"backH.png"] forState:UIControlStateHighlighted];
    [navigationView addSubview:buttonBack];
    [buttonBack addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    

    
    UIView *BGView=[[UIView alloc]initWithFrame:CGRectMake(0, navigationView.frame.size.height+navigationView.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height)];
    BGView.backgroundColor=[UIColor colorWithRed:237/255.0 green:234/255.0 blue:225/255.0 alpha:1];
    [self.view addSubview:BGView];
    [BGView release];
    

    topView=[[UIView alloc]initWithFrame:CGRectMake(0, navigationView.frame.size.height+navigationView.frame.origin.y, 320, 50)];
    [self.view addSubview:topView];
    [topView release];
    UIImageView *topImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    topImageView.image=IMAGENAME(IMAGEWITHPATH(@"topImage"));
    [topView addSubview:topImageView];
    [topImageView release];
    
//    balance"="Balance"
//    "spent"="History"
//    "total" = "Total"
//    
    allCredetbutton=[[GKMarketButton alloc]initWithFrame:CGRectMake(0,0 , 212/2.0, 50)];
    allCredetbutton.textLabel.text=NSLocalizedString(@"balance", @"");
    //allCredetbutton.countLabel.text=@"3500";
    allCredetbutton.tag=TAGMARKET;
    allCredetbutton.delegate=self;
    allCredetbutton.isSelected=YES;
  //  allCredetbutton.frame=CGRectMake(10, navigationView.frame.size.height+navigationView.frame.origin.y, 100, 20);
    [topView addSubview:allCredetbutton];
    [allCredetbutton release];
    
    
    userCredetbutton=[[GKMarketButton alloc]initWithFrame:CGRectMake(212/2.0,0,  212/2.0, 50) ];
    userCredetbutton.tag=TAGMARKET+1;
    userCredetbutton.delegate=self;
    userCredetbutton.textLabel.text=NSLocalizedString(@"spent", @"");
    //userCredetbutton.countLabel.text=@"3500";
    
    [topView addSubview:userCredetbutton];
    [userCredetbutton release];
    
    
    alreadyCredetbutton=[[GKMarketButton alloc]initWithFrame:CGRectMake(212/2.0 *2,0, 212/2.0, 50)];
   // alreadyCredetbutton.frame=CGRectMake(220, navigationView.frame.size.height+navigationView.frame.origin.y, 100, 20);
   // [alreadyCredetbutton addTarget:self action:@selector(statisticsClick:) forControlEvents:UIControlEventTouchUpInside];
    alreadyCredetbutton.tag=TAGMARKET+2;
    alreadyCredetbutton.delegate=self;
    
    alreadyCredetbutton.textLabel.text=NSLocalizedString(@"total", @"");
    //alreadyCredetbutton.countLabel.text=@"3500";
    [topView addSubview:alreadyCredetbutton];
    
    [alreadyCredetbutton release];
//
    
    
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0,navigationView.frame.size.height+navigationView.frame.origin.y + 50,  self.view.frame.size.width, self.view.frame.size.height-topView.frame.size.height-topView.frame.origin.y) style:UITableViewStylePlain];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.backgroundColor=[UIColor clearColor];
    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    dataArr=[[NSMutableArray alloc]init];
    alreadyArr=[[NSMutableArray alloc]init];
    
    index=0;
    
    
    nodataView=[[GKNODataView alloc]initWithFrame:CGRectMake(0,navigationView.frame.size.height+navigationView.frame.origin.y + 50,  self.view.frame.size.width, self.view.frame.size.height-topView.frame.size.height-topView.frame.origin.y)];
    [self.view addSubview:nodataView];
    [nodataView release];
    
    nodataView.hidden=YES;
    
    
    
    GKAppDelegate *app = (GKAppDelegate *)[UIApplication sharedApplication].delegate;
    
    if ([app connectedToNetWork])
    {
        [[EKRequest Instance]EKHTTPRequest:Credit parameters:nil requestMethod:GET forDelegate:self];
        
        NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:@"0",@"isorders", nil];
        [[EKRequest Instance]EKHTTPRequest:Creditshop parameters:dic requestMethod:GET forDelegate:self];
    }
    else
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"alert", @"") message:NSLocalizedString(@"network", @"") delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }
    
    
    
  //  Credit
    

    
    //[[EKRequest Instance]EKHTTPRequest:Creditshop parameters:nil requestMethod:GET forDelegate:self];
    
    
	// Do any additional setup after loading the view.
}

-(void)noData:(NSArray *)arr
{
    if([arr count]==0)
    {
        nodataView.hidden=NO;
    }
    else
    {
        nodataView.hidden=YES;
    }
}
-(void)getEKResponse:(id)response forMethod:(RequestFunction)method parm:(NSDictionary *)parm resultCode:(int)code
{
   // NSString *str=[[NSString alloc]initWithData:response encoding:NSUTF8StringEncoding];
   // NSLog(@"%@",str);
    NSArray *parmArr=[parm allKeys];
    GKUserLogin *user=[GKUserLogin  currentLogin];
    if(code==1 && method==Credit)
    {
        NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:response options:0 error:nil];
//        NSLog(@"%@",dic);
        if(dic!=nil)
        {

            
            user.credit=[NSString stringWithFormat:@"%@",[dic objectForKey:@"credit"]] ;
            user.credit_last=[NSString stringWithFormat:@"%@",[dic objectForKey:@"credit_last"]];
            user.credit_orders=[NSString stringWithFormat:@"%@",[dic objectForKey:@"credit_orders"]];
//
           // [dic objectForKey:@"credit_photo"];// paizai
           // [dic objectForKey:@"credit_photo"];
            //[dic objectForKey:@"credit_photo"];
            
   
            
            NSString *term = [NSString stringWithFormat:@"%@",[dic objectForKey:@"credit_term"]];
            NSString *year = [NSString stringWithFormat:@"%@",[dic objectForKey:@"credit_year"]];
            
            user.vipCredit = [NSString stringWithFormat:@"%d",term.intValue + year.intValue];
            user.photoCredit = [NSString stringWithFormat:@"%@",[dic objectForKey:@"credit_photo"]];
            user.predCredit = [NSString stringWithFormat:@"%@",[dic objectForKey:@"credit_publicize"]];
            
            
            allCredetbutton.countLabel.text=user.credit_last;
            userCredetbutton.countLabel.text=user.credit_orders;
            alreadyCredetbutton.countLabel.text=user.credit;

            [_tableView reloadData];
        }
    }
    else if(method==Credit)
    {
        
    }
    if(code==1 && method==Creditshop)
    {
        
        
       // NSCalendar
         NSArray *arr=[NSJSONSerialization JSONObjectWithData:response options:0 error:nil];
      
        
        if([parmArr containsObject:@"isorders"] && [[parm objectForKey:@"isorders"] isEqualToString:@"1"])
        {
            [alreadyArr removeAllObjects];
            for (int i=0; i<[arr count]; i++) {
                GKMarket *market=[[GKMarket alloc]init];
                market.marketName=[[arr objectAtIndex:i] objectForKey:@"goodsname"];
                
                market.marketUrl=[[arr objectAtIndex:i] objectForKey:@"filename"];
                market.marketCredits=[[arr objectAtIndex:i] objectForKey:@"credit"];
                market.marketIntro=[[arr objectAtIndex:i] objectForKey:@"intro"];
                market.marketId=[[arr objectAtIndex:i] objectForKey:@"goodsid"];
                market.addtime=[[arr objectAtIndex:i] objectForKey:@"addtime"];
                market.status= [[arr objectAtIndex:i] objectForKey:@"status"];
                market.num=[[arr objectAtIndex:i] objectForKey:@"buynum"];
                [alreadyArr addObject:market];
                [market release];

            }
            
            [_tableView reloadData];
            
            [self noData:alreadyArr];
            return;
        }
        
       
        if([parmArr containsObject:@"isorders"] && [[parm objectForKey:@"isorders"] isEqualToString:@"0"])
        {
            [dataArr removeAllObjects];
            for (int i=0; i<[arr count]; i++) {
                
                GKMarket *market=[[GKMarket alloc]init];
                market.marketName=[[arr objectAtIndex:i] objectForKey:@"goodsname"];
                
                
                market.marketUrl=[[arr objectAtIndex:i] objectForKey:@"filename"];
                market.marketCredits=[[arr objectAtIndex:i] objectForKey:@"credit"];
                market.marketIntro=[[arr objectAtIndex:i] objectForKey:@"intro"];
                
               
                
                market.marketId=[[arr objectAtIndex:i] objectForKey:@"goodsid"];
                
                [dataArr addObject:market];
                [market release];
                
            }
          
            [self noData:dataArr];
            [_tableView reloadData];
        }
        
        if([parmArr containsObject:@"goodsid"])
        {
            //NSString *str=[[NSString alloc]initWithData:response encoding:NSUTF8StringEncoding];
            //NSLog(@"%@",str);
            GKUserLogin *user=[GKUserLogin currentLogin];
            
            // user.credit_last=@"11";
            NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:response options:0 error:nil];
            
            user.credit=[NSString stringWithFormat:@"%@",[dic objectForKey:@"credit"]];
            
            user.credit_orders=[NSString stringWithFormat:@"%@",[dic objectForKey:@"credit_orders"]];
            user.credit_last=[NSString stringWithFormat:@"%@",[dic objectForKey:@"credit_last"]];
            allCredetbutton.countLabel.text=user.credit_last;
            userCredetbutton.countLabel.text=user.credit_orders;
            alreadyCredetbutton.countLabel.text=user.credit;
            
            if(countView)
            {
                
                if(tapGest)
                {
                    [_tableView removeGestureRecognizer:tapGest];
                    tapGest=nil;
                }
                [countView removeFromSuperview];
                countView=nil;
            }
            

            
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"alert", @"") message:NSLocalizedString(@"buysucess", @"") delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:nil, nil];
            [alert show];
            [alert release];

        }

    }
    else if (method==Creditshop)
    {
        if([parmArr containsObject:@"goodsid"])
        {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"alert", @"") message:NSLocalizedString(@"buyfailed", @"") delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:nil, nil];
            [alert show];
            [alert release];
        }

    }
}

-(void)getErrorInfo:(NSError *)error forMethod:(RequestFunction)method
{
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"alert", @"") message:NSLocalizedString(@"network", @"") delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:nil, nil];
    [alert show];
    [alert release];
}
-(void)isSelectedTheButton:(GKMarketButton *)marketView isSelected:(BOOL)selected
{
    NSInteger a=marketView.tag;
    
    
//    if(a==TAGMARKET +2)
//    {
//        GKStatisticsViewController *statisticsVC=[[GKStatisticsViewController alloc]init];
//        
//        [self.navigationController presentViewController:statisticsVC animated:YES completion:^{
//            
//        }];
//        
//        [statisticsVC release];
//        
//        return;
//    }
    
    for (UIView *view in topView.subviews) {
        if([view isKindOfClass:[GKMarketButton class]])
        {
            GKMarketButton *button=(GKMarketButton *)view;
            button.isSelected=NO;
        }
    }

    GKMarketButton *btn=(GKMarketButton *)[self.view viewWithTag:a];
    btn.isSelected=YES;
     nodataView.hidden=YES;
    if(a==TAGMARKET)
    {
        _tableView.hidden=NO;
        etScrollView.hidden=YES;
      //  isorders == 1
        index=0;
       // [dataArr removeAllObjects];
        [_tableView reloadData];
        
        NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:@"0",@"isorders", nil];
        [[EKRequest Instance]EKHTTPRequest:Creditshop parameters:dic requestMethod:GET forDelegate:self];
    }
    if(a==TAGMARKET+1)
    {
        
        //  isorders == 0
         _tableView.hidden=NO;
          etScrollView.hidden=YES;
        index=1;
          [_tableView reloadData];
        NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:@"1",@"isorders", nil];
         [[EKRequest Instance]EKHTTPRequest:Creditshop parameters:dic requestMethod:GET forDelegate:self];
    }
    
    if(a==TAGMARKET+2)
    {
        index=3;
        GKUserLogin *user=[GKUserLogin currentLogin];
         _tableView.hidden=YES;
          etScrollView.hidden=NO;
        if(etScrollView==nil)
        {
             etScrollView = [[ETScoreView alloc] initWithFrame:CGRectMake(0,navigationView.frame.size.height +navigationView.frame.origin.y+50 , 320, self.view.frame.size.height-navigationView.frame.size.height-navigationView.frame.origin.y-50)];
            etScrollView.bottomScore=[NSArray arrayWithObjects:user.vipCredit,user.photoCredit,user.predCredit, nil];
            [self.view addSubview:etScrollView];
            [etScrollView release];

        }
      
        
    }
    
}


-(void)statisticsClick:(UIButton *)btn
{

}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if(index==1)
        return [alreadyArr count];
    if(index==0)
        return [dataArr count];
    
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(index==0)
    {
        static NSString *cellIdentifier=@"cell";
        GKMarketCell *cell=(GKMarketCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if(cell==nil)
        {
            cell=[[[GKMarketCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            cell.delegate=self;
            
        }

            GKMarket *market_= [dataArr objectAtIndex:indexPath.row];
            cell.tag=indexPath.row;
            cell.market=market_;
      

         return cell;
    }
    if(index==1)
    {
        static NSString *cellalreadyIdentifier=@"cellalready";
        GKAlreadyCell *cell=(GKAlreadyCell *)[tableView dequeueReusableCellWithIdentifier:cellalreadyIdentifier];
        if(cell==nil)
        {
            cell=[[[GKAlreadyCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellalreadyIdentifier] autorelease];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;

        }
        
        GKMarket *market_= [alreadyArr objectAtIndex:indexPath.row];
        //cell.tag=indexPath.row;
        cell.market=market_;
        
        
        return cell;

    }
    
    return nil;
   
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(index==0)
      return 92;
    return 55;
    
}


-(void)clickBuy:(GKMarketCell *)cell isselected:(BOOL)select market:(GKMarket *)mark
{
    self.buymarket=mark;
    

    
    if(select)
    {
        if(countView)
        {
            
            if(tapGest)
            {
                [_tableView removeGestureRecognizer:tapGest];
                tapGest=nil;
            }
            [countView removeFromSuperview];
            countView=nil;
        }

        
        if(countView==nil)
        {
            countView=[[GKBuyCountView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height-60, 320, 60)];
            [self.view addSubview:countView];
            if(tapGest==nil)
            {
                tapGest =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick:)];
                [_tableView addGestureRecognizer:tapGest];
                [tapGest release];
            }
    
            countView.buyCount=^(int count){
                buyCount=count;
                
                NSLog(@"%d",count);
                
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"alert", @"") message:NSLocalizedString(@"buyConfirm", @"") delegate:self cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:NSLocalizedString(@"cancel", @""), nil];
                [alert show];
                [alert release];

                
                
            };
            [countView release];
        }
    }
    else
    {
        if(countView)
        {
            if(tapGest)
            {
                [_tableView removeGestureRecognizer:tapGest];
                tapGest=nil;
            }

            [countView removeFromSuperview];
            countView=nil;
        }
    }
    
}
-(void)tapClick:(UITapGestureRecognizer *)tap
{
    if(countView)
    {
        
    
        for (UIView *view in _tableView.subviews) {
            if([view isKindOfClass:[GKMarketCell class]])
            {
               
                GKMarketCell *cell=(GKMarketCell *)view;
                
                cell.buyButton.selected=NO;;
            }
        }

        
        [countView removeFromSuperview];
        countView=nil;
    }
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    
    if(buttonIndex==0)
    {
        NSLog(@"fdfd");
        
        
        NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:buymarket.marketId,@"goodsid",[NSNumber numberWithInt:buyCount],@"buynum", nil];
        [[EKRequest Instance]EKHTTPRequest:Creditshop parameters:dic requestMethod:POST forDelegate:self];
        
        
        
    }
    if(buttonIndex==1)
    {
        NSLog(@"111");
    }
}


-(void)dealloc
{
    self._tableView=nil;
    self.buymarket=nil;
    [super dealloc];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
