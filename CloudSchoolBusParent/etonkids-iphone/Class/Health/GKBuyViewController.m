//
//  GKBuyViewController.m
//  etonkids-iphone
//
//  Created by wen peifang on 14-8-15.
//  Copyright (c) 2014年 wpf. All rights reserved.
//

#import "GKBuyViewController.h"
#import "ETKids.h"
#import "ETCommonClass.h"
#import "AlixPayOrder.h"
#import "AlixLibService.h"
#import "DataSigner.h"
#import "DataVerifier.h"
#import "AlixPayResult.h"
#import "PartnerConfig.h"
#import "SBJsonWriter.h"
#import "BuyButton.h"
#define ALIPAY_SAFEPAY     @"SafePay"
#define ALIPAY_DATASTRING  @"dataString"
#define ALIPAY_SCHEME      @"fromAppUrlScheme"
#define ALIPAY_TYPE        @"requestType"
@interface GKBuyViewController ()

@end

@implementation GKBuyViewController
@synthesize count;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}
- (void)viewDidLoad
{
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
    
    UILabel *middleLabel=[[UILabel alloc]initWithFrame:CGRectMake(160-100, 13 + (ios7 ? 20 : 0), 200, 20)];
    middleLabel.textAlignment=UITextAlignmentCenter;
    middleLabel.textColor=[UIColor whiteColor];
    middleLabel.text = NSLocalizedString(@"buychunyutitle", @"");
    middleLabel.backgroundColor=[UIColor clearColor];
    [self.view addSubview:middleLabel];
    [middleLabel release];
    
  
    UIScrollView *scroller=[[UIScrollView alloc]initWithFrame:CGRectMake(0, NAVIHEIGHT + (ios7 ? 20 : 0), self.view.frame.size.width, (iphone5 ? 548 : 460) - NAVIHEIGHT)];
    scroller.backgroundColor=[UIColor clearColor];
    [self.view addSubview:scroller];
    [scroller release];
    
    
    UIImageView *picImageView=[[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2.0-536/4.0, 10, 536/2.0, 235/2.0)];
    picImageView.image=[UIImage imageNamed:@"health_bg_pic.png"];
    [scroller addSubview:picImageView];
    [picImageView release];
    
    
    NSString *str=NSLocalizedString(@"health_bg_content", @"");
    
    CGSize size=[str sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(self.view.frame.size.width-20, 1000) lineBreakMode:NSLineBreakByWordWrapping];
    
    UILabel *contentlabel=[[UILabel alloc]initWithFrame:CGRectMake(10, picImageView.frame.size.height+picImageView.frame.origin.y+5, self.view.frame.size.width-20, size.height)];
    contentlabel.numberOfLines=0;;
    contentlabel.backgroundColor=[UIColor clearColor];
    contentlabel.text=str;
    contentlabel.font=[UIFont systemFontOfSize:15];
    [scroller addSubview:contentlabel];
    [contentlabel release];

    count=1;
    float y=contentlabel.frame.size.height+contentlabel.frame.origin.y+20;
    NSArray *arr=[NSArray arrayWithObjects:@"价格",@"数量",@"总价", nil];
    for (int i=0; i<3; i++) {
        
        UILabel * temp=[[UILabel alloc]initWithFrame:CGRectMake(20, y+(20 +20)*i, 50, 20)];
        temp.backgroundColor=[UIColor clearColor];
        temp.text=[arr objectAtIndex:i];
        temp.font=[UIFont systemFontOfSize:15];
        [scroller addSubview:temp];
        [temp release];
        
        UIImageView *imageLine1=[[UIImageView alloc]initWithFrame:CGRectMake(0,y+30+(40)*i, self.view.frame.size.width, 1)];
        imageLine1.image=[UIImage imageNamed:@"cellline.png"];
        [scroller addSubview:imageLine1];
        [imageLine1 release];

    }
    
    
    
//    
    UIImageView *imageLine=[[UIImageView alloc]initWithFrame:CGRectMake(0,y-5, self.view.frame.size.width, 1)];
    imageLine.image=[UIImage imageNamed:@"cellline.png"];
    [scroller addSubview:imageLine];
    [imageLine release];
    
    
    
    UILabel * priceLabel=[[UILabel alloc]initWithFrame:CGRectMake(225, y, 50, 20)];
    priceLabel.backgroundColor=[UIColor clearColor];
    priceLabel.text=@"8元/月";
    priceLabel.font=[UIFont systemFontOfSize:15];
    [scroller addSubview:priceLabel];
    [priceLabel release];
    
    
    UIButton *jianBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    jianBtn.frame=CGRectMake(140, y+30+10, 33, 20);
    [jianBtn setBackgroundImage:[UIImage imageNamed:@"health_minux_normal.png"] forState:UIControlStateNormal];
    [jianBtn setBackgroundImage:[UIImage imageNamed:@"health_minux_select.png"] forState:UIControlStateHighlighted];
    jianBtn.tag=100;
    [jianBtn addTarget:self action:@selector(countClcik:) forControlEvents:UIControlEventTouchUpInside];
    [scroller addSubview:jianBtn];
    
    
    textfiled=[[UITextField alloc]initWithFrame:CGRectMake(180, y+30+10, 50, 20)];
    textfiled.borderStyle=UITextBorderStyleRoundedRect;
    [textfiled setEnabled:NO];
    textfiled.text=@"1";
    textfiled.font=[UIFont systemFontOfSize:15];
    textfiled.textAlignment=NSTextAlignmentCenter;
    [scroller addSubview:textfiled];
    
    UIButton *plusBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    plusBtn.frame=CGRectMake(240, y+30+10, 33, 20);
//    [plusBtn setBackgroundImage:[UIImage imageNamed:@"health_plus_mormal.png"] forState:UIControlStateNormal];
    [plusBtn setBackgroundImage:[UIImage imageNamed:@"health_plus_select.png"] forState:UIControlStateNormal];
    plusBtn.tag=101;
    [plusBtn addTarget:self action:@selector(countClcik:) forControlEvents:UIControlEventTouchUpInside];
    [scroller addSubview:plusBtn];

    
    sumLabel=[[UILabel alloc]initWithFrame:CGRectMake(225, y+30+30+20, 50, 20)];
    sumLabel.backgroundColor=[UIColor clearColor];
    sumLabel.text=@"8元";
    sumLabel.textColor=[UIColor orangeColor];
    sumLabel.font=[UIFont systemFontOfSize:15];
    [scroller addSubview:sumLabel];
    [sumLabel release];
  
//    "AlipayPay"="支付宝客户端支付";
//    "AlipayApp"="推荐已安装支付宝客户端的用户使用";
    //UIButton *buttonBuy=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    BuyButton *btn=[[BuyButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2.0-611/4.0, sumLabel.frame.size.height + sumLabel.frame.origin.y+20,611/2.0, 45) title1:NSLocalizedString(@"AlipayPay", @"") title2:NSLocalizedString(@"AlipayApp", @"") image:[UIImage imageNamed:@"health_buy_btn_icon.png"]];

//    buttonBuy.backgroundColor=[UIColor redColor];
  //  [btn addTarget:self action:@selector(buyClick:) forControlEvents:UIControlEventTouchDown];
    
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(buyClick:)];
    tap.numberOfTapsRequired=1;
    [btn addGestureRecognizer:tap];
    [tap release];
    [scroller addSubview:btn];
    [btn release];
    
    scroller.contentSize=CGSizeMake(self.view.frame.size.width, btn.frame.size.height+btn.frame.origin.y+10);


}
-(void)countClcik:(UIButton *)btn
{
    
    
    if(btn.tag==100)
    {
        if(count==1)
        {
            count=1;
        }
        else
        {
            count--;
        }

    }
    else if (btn.tag==101)
    {
        if(count==12)
            return;
        count++;
    }
    
    sumLabel.text=[NSString stringWithFormat:@"%d 元",count * 8];
    textfiled.text=[NSString stringWithFormat:@"%d",count];
}
-(void)buyClick:(UITapGestureRecognizer *)tap
{
    if(tap.state==UIGestureRecognizerStateEnded)
    {
        ETCommonClass *com = [[[ETCommonClass alloc] init] autorelease];
        [com requestLoginWithComplete:^(NSError *err){
            NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:self.count],@"count", nil];
            [[EKRequest Instance] EKHTTPRequest:order parameters:dic requestMethod:GET forDelegate:self];
        }];
    }

    
}
-(void)getErrorInfo:(NSError *)error forMethod:(RequestFunction)method
{
    
}
-(void)getEKResponse:(id)response forMethod:(RequestFunction)method resultCode:(int)code withParam:(NSDictionary *)param
{
    if(code==1 && method==order)
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
- (void)leftButtonClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
