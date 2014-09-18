//
//  GKVideoViewController.m
//  etonkids-iphone
//
//  Created by wen peifang on 14-9-17.
//  Copyright (c) 2014年 wpf. All rights reserved.
//

#import "GKVideoViewController.h"
#import "ETKids.h"
#import "GKSocket.h"
#import "GKDevice.h"
#import "libavcodec/avcodec.h" 
#import "libswscale/swscale.h" 
#import "libavformat/avformat.h"
const int Header = 101;
const int Data = 102;
@interface GKVideoViewController ()
{
    AVFormatContext *pFormatCtx;
	AVCodecContext *pCodecCtx;
    AVFrame *pFrame;
	AVPicture picture;
	int videoStream;
	struct SwsContext *img_convert_ctx;
	int sourceWidth, sourceHeight;
	int outputWidth, outputHeight;
	UIImage *currentImage;
	double duration;


}
@end

@implementation GKVideoViewController
@synthesize device;
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
-(void)dealloc
{
    self.device=nil;
    [super dealloc];
}
- (void)leftButtonClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
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
    middleLabel.text =  NSLocalizedString(@"doctor_con", @"医生咨询");
    middleLabel.backgroundColor=[UIColor clearColor];
    [self.view addSubview:middleLabel];
    [middleLabel release];
    
    
avcodec_register_all();
   
   // pFrame = av_frame_alloc();
   
//    m_pCodec = avcodec_find_decoder(AV_CODEC_ID_H264);
//    m_pCodecContext = avcodec_alloc_context3(m_pCodec);
//    int ret = avcodec_open2(m_pCodecContext, m_pCodec, nil);
//
//    m_pCodecContext->width = 1280;//视频宽
//    m_pCodecContext->height = 720;//视频高
//    avcodec_open2(m_pCodecContext, m_pCodec, NULL);
//    if (ret != 0){
//       
//        NSLog(@"open codec failed :%d",ret);
//    }
//
//    if(avcodec_open2(m_pCodecContext, m_pCodec, NULL)>=0)
//    {
//        pFrame=av_frame_alloc();
//    }
//    else
//    {
//         NSLog(@"open 111 failed :%d",ret);
//    }

    
    [self loadVideo];
}
- (int)typeOfNalu:(NSData *)data
{
    char first = *(char *)[data bytes];
    return first & 0x1f;
}
-(void)loadVideo
{
    GKSocket *socket=[GKSocket instance];
    //<TYPE>CheckUser</TYPE><User>%s</User><Pwd>%s</Pwd>","super","super
    // NSString *response  =@"<TYPE>GetDeviceList</TYPE>";
    //NSString *response =@"<TYPE>CheckUser</TYPE><User>super</User><Pwd>super</Pwd>";
     NSString *response =@"<?xml version=\"1.0\" encoding=\"GB2312\" standalone=\"yes\"?> <TYPE>StartStream</TYPE>\
        <DVRName>hb</DVRName>\
        <ChnNo>0</ChnNo> <StreamType>1</StreamType>";
    
    NSData *data = [[NSData alloc] initWithData:[response dataUsingEncoding:NSASCIIStringEncoding]];

    [socket sendData:(char *)[data bytes] length:[data length] type:12 block:^(BOOL success, NSString *result) {
        
        NSString *respon=@"<TYPE>ImOK</TYPE>";
        NSData *data = [[NSData alloc] initWithData:[respon dataUsingEncoding:NSASCIIStringEncoding]];
        [socket sendData:(char *)[data bytes] length:[data length] type:12 block:^(BOOL success, NSString *result) {
            
        } streamBlock:^(BOOL header, char * result) {
            NSLog(@"%s",result);
            
          if(header==NO)
          {
              //[self date:result size:strlen(result)];
              
             
          }

            
        }];

    } streamBlock:^(BOOL header, char * result) {
        
    }];

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
