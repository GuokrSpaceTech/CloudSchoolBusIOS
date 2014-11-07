//
//  GKPersionalViewController.m
//  etonkids-iphone
//
//  Created by wen peifang on 14-11-6.
//  Copyright (c) 2014年 wpf. All rights reserved.
//

#import "GKPersionalViewController.h"
#import "ETKids.h"
#import "UserLogin.h"

#import "AlixPayOrder.h"
#import "AlixLibService.h"
#import "DataSigner.h"
#import "DataVerifier.h"
#import "AlixPayResult.h"
#import "PartnerConfig.h"
#import "SBJsonWriter.h"
#define ALIPAY_SAFEPAY     @"SafePay"
#define ALIPAY_DATASTRING  @"dataString"
#define ALIPAY_SCHEME      @"fromAppUrlScheme"
#define ALIPAY_TYPE        @"requestType"

#define LEFTLABELTAG 1000
#define RIGHTLABELTAG 1111
#define LEFTIMAGEVIEWTAG 2222
#define BUTTONTAG 3333

@interface GKPersionalViewController ()

@end

@implementation GKPersionalViewController
@synthesize _tableView;
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

-(void)dealloc
{
    self._tableView=nil;
    self.funArr=nil;
    self.descArr=nil;
    self.price=nil;
    [super dealloc];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor blackColor];
    
    if (ios7) {
        [self setNeedsStatusBarAppearanceUpdate];
        
        UIView *statusbar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
        statusbar.backgroundColor = [UIColor blackColor];
        [self.view addSubview:statusbar];
        [statusbar release];
        
    }
    self.price=@"";
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, (ios7 ? 20 : 0) + NAVIHEIGHT, 320, self.view.frame.size.height - NAVIHEIGHT - (ios7 ? 20 : 0))];
    backView.backgroundColor = CELLCOLOR;
    [self.view insertSubview:backView atIndex:0];
    [backView release];
    
    UIImageView *navigationBackView=[[UIImageView alloc]initWithFrame:CGRectMake(0, (ios7 ? 20 : 0), 320, NAVIHEIGHT)];
    navigationBackView.image=[UIImage imageNamed:@"navigationNoText.png"];
    [self.view addSubview:navigationBackView];
    [navigationBackView release];
    
    
    UIButton *leftButton =[UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setFrame:CGRectMake(0, 0, 50, 35)];
    [leftButton setCenter:CGPointMake(10 + 34/2, navigationBackView.frame.size.height/2+ (ios7 ? 20 : 0))];
    [leftButton setImage:[UIImage imageNamed:@"backBtnDefault_3.0.png"] forState:UIControlStateNormal];
    [leftButton setImage:[UIImage imageNamed:@"backBtnSel_3.0.png"] forState:UIControlStateHighlighted];
    [leftButton addTarget:self action:@selector(leftButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:leftButton];
    UISwipeGestureRecognizer *popGes = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(leftButtonClick:)];
    popGes.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:popGes];
    [popGes release];
    
    UILabel * middleLabel=[[UILabel alloc]initWithFrame:CGRectMake(160-100, 13 + (ios7 ? 20 : 0), 200, 20)];
    middleLabel.textAlignment=UITextAlignmentCenter;
    middleLabel.textColor=[UIColor whiteColor];
    middleLabel.text =@"购买登陆服务";//  NSLocalizedString(@"doctor_con", @"医生咨询");
    middleLabel.backgroundColor=[UIColor clearColor];
    [self.view addSubview:middleLabel];
    [middleLabel release];
    
    
    _tableView= [[UITableView alloc] initWithFrame:CGRectMake(0, NAVIHEIGHT + (ios7 ? 20 : 0), 320, (iphone5 ? 548 : 460) - NAVIHEIGHT) style:UITableViewStyleGrouped];
    _tableView.backgroundView = nil;
    _tableView.backgroundColor = CELLCOLOR;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    
    UserLogin *user=[UserLogin currentLogin];
    NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:user.schooldID,@"schoolid", nil];
    [[EKRequest Instance] EKHTTPRequest:price parameters:dic requestMethod:GET forDelegate:self];
    
    
    

    self.funArr=[NSArray arrayWithObjects:@"孩子班级日志",@"孩子通知",@"孩子食谱",@"孩子考勤", nil];
    self.descArr=[NSArray arrayWithObjects:@"登陆服务",@"数量",@"价格", nil];

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section==0)
    {
        return [_descArr count];
    }
    if(section==1)
    {
        return [_funArr count];
    }
    
    return 1;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellDetifier=@"cell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellDetifier];
    if(cell==nil)
    {
        cell=[[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellDetifier] autorelease];
        
        
        UILabel *leftlabel=[[UILabel alloc]initWithFrame:CGRectZero];
        leftlabel.backgroundColor=[UIColor clearColor];
        leftlabel.tag=LEFTLABELTAG;
        [cell.contentView addSubview:leftlabel];
        [leftlabel release];
        
        
        UILabel *rightlabel=[[UILabel alloc]initWithFrame:CGRectZero];
        rightlabel.backgroundColor=[UIColor clearColor];
        rightlabel.tag=RIGHTLABELTAG;
        [cell.contentView addSubview:rightlabel];
        [rightlabel release];
        
        
        UIImageView *iamgeView=[[UIImageView alloc]initWithFrame:CGRectZero];
        iamgeView.backgroundColor=[UIColor clearColor];
        [cell.contentView addSubview:iamgeView];
        iamgeView.tag=LEFTIMAGEVIEWTAG;
        [iamgeView release];
        
        UIButton  *btn=[UIButton buttonWithType:UIButtonTypeCustom];
        btn.backgroundColor=[UIColor clearColor];
        [cell.contentView addSubview:btn];
        btn.tag=BUTTONTAG;
     
        
    }
    UILabel *leftLabel=(UILabel *)[cell.contentView viewWithTag:LEFTLABELTAG];
    UILabel *rightLabel=(UILabel *)[cell.contentView viewWithTag:RIGHTLABELTAG];
    leftLabel.font=[UIFont systemFontOfSize:17];
    rightLabel.font=[UIFont systemFontOfSize:17];
    cell.backgroundColor=[UIColor whiteColor];
    UIImageView *imageView=(UIImageView *)[cell.contentView viewWithTag:LEFTIMAGEVIEWTAG];
    UIButton *button=(UIButton *)[cell.contentView viewWithTag:BUTTONTAG];
    imageView.frame=CGRectZero;
    leftLabel.frame=CGRectZero;
    rightLabel.frame=CGRectZero;
    button.frame=CGRectZero;
    if(indexPath.section==0)
    {
        leftLabel.frame=CGRectMake(10, 10, 200, 20);
        rightLabel.frame=CGRectMake(250, 10, 60, 20);

        leftLabel.text=[_descArr objectAtIndex:indexPath.row];
        
        if(indexPath.row==0)
        {
            rightLabel.text=@"";
        }
        if(indexPath.row==1)
        {
            rightLabel.text=@"6个月";
        }
        else if (indexPath.row==2)
        {
            if([self.price isEqualToString:@""])
            {
                rightLabel.text=@"";
            }
            else
            {
                rightLabel.text=[NSString stringWithFormat:@"%@元",self.price];
            }
            
        }
    }
    else if(indexPath.section==1)
    {
        leftLabel.frame=CGRectMake(10, 10, 200, 20);
        rightLabel.frame=CGRectMake(250, 10, 60, 20);
        leftLabel.text=[_funArr objectAtIndex:indexPath.row];
        rightLabel.text=@"";
    }
    else if(indexPath.section==2)
    {
        imageView.frame=CGRectMake(7, 7, 30, 30);
        imageView.image=[UIImage imageNamed:@"health_buy_btn_icon.png"];
        leftLabel.frame=CGRectMake(50, 5, 200, 20);
        rightLabel.frame=CGRectMake(50, 25, 200, 18);
        rightLabel.font=[UIFont systemFontOfSize:15];
        rightLabel.font=[UIFont systemFontOfSize:12];
        leftLabel.text=@"支付宝客户端支付";
        rightLabel.text=@"推荐安装支付宝客户端的用户使用";
    }
    else
    {
        cell.backgroundColor=[UIColor clearColor];
        button.frame=CGRectMake(10, 0, self.view.frame.size.width-20, 40);
        [button setBackgroundColor:[UIColor orangeColor]];
        [button addTarget:self action:@selector(toBuy:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setTitle:@"确定购买" forState:UIControlStateNormal];
    }
    return cell;
}
-(void)toBuy:(UIButton *)sender
{

    UserLogin *user=[UserLogin currentLogin];
    NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:user.studentId,@"studentid",user.schooldID,@"schoolid", nil];
    [[EKRequest Instance] EKHTTPRequest:personalorder parameters:dic requestMethod:GET forDelegate:self];
   
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if(section==1)
    {
        return @"购买后即可享受服务";
    }
    else if(section==2)
    {
        return @"支付方式";
    }
    return @"";
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section==3)
    {
        return 5;
    }
    return 20;
}
-(void)getEKResponse:(id)response forMethod:(RequestFunction)method resultCode:(int)code withParam:(NSDictionary *)param
{
    NSString *aa=[[NSString alloc]initWithData:response encoding:NSUTF8StringEncoding];
    NSLog(@"%@",aa);
    if(method==price)
    {
        if(code==1)
        {
            NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:response options:0 error:nil];
            self.price=[NSString stringWithFormat:@"%@",[dic objectForKey:@"price"]];
            [_tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
        }
        else if(code==-1)
        {
        }
    }
    else if (method==personalorder)
    {
        if(code==1)
        {
            NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:response options:0 error:nil];
            NSLog(@"%@",dic);
            
            
            AlixPayOrder *order = [[AlixPayOrder alloc] init];
            order.partner = PartnerID;
            order.seller = SellerID;
            
            order.tradeNO = [dic objectForKey:@"oriderid"];; //订单ID（由商家自行制定）
            order.productName = [dic objectForKey:@"title"]; //商品标题
            order.productDescription = [dic objectForKey:@"description"]; //商品描述
            order.amount = [NSString stringWithFormat:@"%@",[dic objectForKey:@"price"]]; //商品价格
            //order.amount = [NSString stringWithFormat:@"%.2f",self.count*0.01]; //商品价格
            order.notifyURL =   [dic objectForKey:@"notifyURL"]; //回调URL
            

            
            NSString *appScheme = @"yunxiaocheparent";
            NSString* orderInfo = order.description;
            NSString* signedStr = [self doRsa:orderInfo];
            
            NSLog(@"%@",signedStr);
            
            NSString *orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                                     orderInfo, signedStr, @"RSA"];
            
            
            
            
            
            NSDictionary * oderParams = [NSDictionary dictionaryWithObjectsAndKeys:
                                         orderString,ALIPAY_DATASTRING,
                                         appScheme, ALIPAY_SCHEME,
                                         ALIPAY_SAFEPAY, ALIPAY_TYPE,
                                         nil];
            
            //采用SBjson将params转化为json格式的字符串
            SBJsonWriter * OderJsonwriter = [SBJsonWriter new];
            NSString * jsonString = [OderJsonwriter stringWithObject:oderParams];
            [OderJsonwriter release];
            
            //将数据拼接成符合alipay规范的Url
            //注意：这里改为接入独立安全支付客户端
            
            //支付宝钱包
            NSString * urlString = [NSString stringWithFormat:@"alipay://alipayclient/?%@",
                                    [jsonString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            NSURL * dataUrl = [NSURL URLWithString:urlString];
            
            //快捷支付
            NSString * safeUrlString = [NSString stringWithFormat:@"safepay://alipayclient/?%@",
                                        [jsonString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            NSURL * safeDataUrl = [NSURL URLWithString:safeUrlString];
            
            //通过打开Url调用安全支付服务
            //实质上,外部商户只需保证把商品信息拼接成符合规范的字符串转为Url并打开,其余任何函数代码都可以自行优化
            if (![[UIApplication sharedApplication] canOpenURL:dataUrl] && ![[UIApplication sharedApplication] canOpenURL:safeDataUrl])
            {
                //[[UIApplication sharedApplication] openURL:dataUrl];
                UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                     message:@"您还没有安装支付宝快捷支付，请先安装。"
                                                                    delegate:self
                                                           cancelButtonTitle:@"确定"
                                                           otherButtonTitles:nil];
                [alertView setTag:123];
                [alertView show];
                [alertView release];
                
                return;
            }
            
            [AlixLibService payOrder:orderString AndScheme:appScheme seletor:@selector(paymentResult:) target:self];
            

        }
        else
        {
            UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"提示" message:@"订单生成失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
            [alertView release];
        }
    }
        

}
//wap回调函数
-(void)paymentResult:(NSString *)resultd
{
    //结果处理
#if ! __has_feature(objc_arc)
    AlixPayResult* result = [[[AlixPayResult alloc] initWithString:resultd] autorelease];
#else
    AlixPayResult* result = [[AlixPayResult alloc] initWithString:resultd];
#endif
    if (result)
    {
        
        if (result.statusCode == 9000)
        {
            /*
             *用公钥验证签名 严格验证请使用result.resultString与result.signString验签
             */
            
            NSString* key = AlipayPubKey;
            id<DataVerifier> verifier;
            verifier = CreateRSADataVerifier(key);
            
            if ([verifier verifyString:result.resultString withSign:result.signString])
            {
                //验证签名成功，交易结果无篡改
                
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"交易成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
                [alert release];
                
            }
        }
        else
        {
            //交易失败
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:result.statusMessage delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            [alert release];
            
        }
    }
    else
    {
        //失败
        
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"交易失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }
    // exit(1);
}

-(NSString*)doRsa:(NSString*)orderInfo
{
    id<DataSigner> signer;
    signer = CreateRSADataSigner(PartnerPrivKey);
    NSString *signedString = [signer signString:orderInfo];
    return signedString;
}
-(void)getErrorInfo:(NSError *)error forMethod:(RequestFunction)method
{
    
}
-(void)leftButtonClick:(UIButton *)btn
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
