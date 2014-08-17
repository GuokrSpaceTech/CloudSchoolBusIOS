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
@interface GKBuyViewController ()

@end

@implementation GKBuyViewController

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
    
  
    
    
    UIButton *buttonBuy=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    buttonBuy.frame=CGRectMake(10, 200, 100, 30);
    buttonBuy.backgroundColor=[UIColor redColor];
    [buttonBuy addTarget:self action:@selector(buyClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buttonBuy];
    [buttonBuy release];

}
-(void)buyClick:(UIButton *)btn
{
    ETCommonClass *com = [[[ETCommonClass alloc] init] autorelease];
    [com requestLoginWithComplete:^(NSError *err){
         NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:@"2",@"count", nil];
        [[EKRequest Instance] EKHTTPRequest:order parameters:dic requestMethod:GET forDelegate:self];
    }];
    
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
        // order.amount = [NSString stringWithFormat:@"%@",[dic objectForKey:@"price"]]; //商品价格
        order.amount = [NSString stringWithFormat:@"%.2f",0.01]; //商品价格
        order.notifyURL =   [dic objectForKey:@"notifyURL"]; //回调URL
        
        
        
        NSString *appScheme = @"yunxiaocheparent";
        NSString* orderInfo = order.description;
        NSString* signedStr = [self doRsa:orderInfo];
        
        NSLog(@"%@",signedStr);
        
        NSString *orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                                 orderInfo, signedStr, @"RSA"];
        
        // [AlixLibService exitFullScreen];
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
