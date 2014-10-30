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
#import "UserLogin.h"
#import "OpenGLView20.h"
#import "TBXML.h"
//const int Header = 101;
//const int Data = 102;
@interface GKVideoViewController ()
{
    AVFrame *frame;
    AVPicture picture;
    AVCodec *codec;
    AVCodecContext *codecCtx;

    struct SwsContext *img_convert_ctx;
    
    NSMutableData *keyFrame;
    
    int outputWidth;
    int outputHeight;
    
    Byte * frameData;
    int total;
    
    // 音频
    AVCodecContext *codecaudioCtx;
    AVCodec *audiocodec;


}
@end

@implementation GKVideoViewController
//@synthesize device_name;
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
   // self.device=nil;
    
    free(frameData);
    [super dealloc];
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [UIApplication sharedApplication].idleTimerDisabled=NO;
}
- (void)leftButtonClick:(id)sender
{
    UserLogin *user=[UserLogin currentLogin];
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        [[UIDevice currentDevice] performSelector:@selector(setOrientation:)
                                       withObject:(id)UIInterfaceOrientationPortrait];
    }
    NSString *ddns=user.ddns;
    NSString *prot=user.port;
    [[GKSocket instanceddns:ddns port:prot] cleanUpStream];
    [UIApplication sharedApplication].idleTimerDisabled=NO;
   // [[GKSocket instance] cleanUpStream];
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor blackColor];
    [UIApplication sharedApplication].idleTimerDisabled=YES;
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
    
    
    navigationBackView=[[UIImageView alloc]initWithFrame:CGRectMake(0, (ios7 ? 20 : 0), 320, NAVIHEIGHT)];
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
    
    middleLabel=[[UILabel alloc]initWithFrame:CGRectMake(160-100, 13 + (ios7 ? 20 : 0), 200, 20)];
    middleLabel.textAlignment=UITextAlignmentCenter;
    middleLabel.textColor=[UIColor whiteColor];
    middleLabel.text =  @"视频直播";
    middleLabel.backgroundColor=[UIColor clearColor];
    [self.view addSubview:middleLabel];
    [middleLabel release];
    
    glView = [[OpenGLView20 alloc] initWithFrame:CGRectMake(0, NAVIHEIGHT + (ios7 ? 20 : 0), self.view.frame.size.width, self.view.frame.size.height-( NAVIHEIGHT + (ios7 ? 20 : 0)))];
    //设置视频原始尺寸
    [glView setVideoSize:352 height:288];
    //渲染yuv
    [self.view addSubview:glView];
    
    avcodec_register_all();
    frame = av_frame_alloc();
    codec = avcodec_find_decoder(AV_CODEC_ID_H264);
    codecCtx = avcodec_alloc_context3(codec);
    int ret = avcodec_open2(codecCtx, codec, nil);
    if (ret != 0){
        NSLog(@"open codec failed :%d",ret);
    }
    outputWidth = 320;
    outputHeight = 240;
    frameData=(Byte *)malloc(512*1024*sizeof(Byte));
//    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
//        [[UIDevice currentDevice] performSelector:@selector(setOrientation:)
//                                       withObject:(id)UIInterfaceOrientationLandscapeRight];
//    }
    [self loadVideo];
}
//-(void)setOrientation:(UIInterfaceOrientation)orientation
//{
//    CGSize size=[UIScreen mainScreen].bounds.size;
//    navigationBackView.frame=CGRectMake(0, (ios7 ? 20 : 0), size.width, NAVIHEIGHT);
//    
//    glView.frame=CGRectMake(0, (ios7 ? 20 : 0)+NAVIHEIGHT, size.width, size.height-NAVIHEIGHT-(ios7 ? 20 : 0));
//    middleLabel.frame=CGRectMake(50, 13+(ios7 ? 20 : 0), size.width-100,20);
//}
-(void)loadVideo
{
    
    if(HUD==nil)
    {
        HUD=[[MBProgressHUD alloc]initWithView:self.view];
        HUD.mode=MBProgressHUDModeText;
        HUD.labelText=@"正在加载...";
        [self.view addSubview:HUD];
        [HUD release];
        [HUD show:YES];
    }
    UserLogin *user=[UserLogin currentLogin];
    
    NSString *ddns=user.ddns;
    NSString *prot=user.port;
    GKSocket *socket=[GKSocket instanceddns:ddns port:prot];
    //<TYPE>CheckUser</TYPE><User>%s</User><Pwd>%s</Pwd>","super","super
    // NSString *response  =@"<TYPE>GetDeviceList</TYPE>";
    //NSString *response =@"<TYPE>CheckUser</TYPE><User>super</User><Pwd>super</Pwd>";
    NSString *response=[NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"GB2312\" standalone=\"yes\"?> <TYPE>StartStream</TYPE>\
                        <DVRName>%@</DVRName>\
                        <ChnNo>0</ChnNo> <StreamType>1</StreamType>",user.camera_name];
    NSStringEncoding encoding =CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSData *data = [[[NSData alloc] initWithData:[response dataUsingEncoding:encoding]] autorelease];

    [socket sendData:(char *)[data bytes] length:[data length] type:12 block:^(BOOL success, NSString *result) {
//        <LinkReturn>SUCCESS</LinkReturn><DVRType>PCH264</DVRType><Width>352</Width><Height>288</Height><Interval>100</Interval><AudioCodeID>86017</AudioCodeID><HZ>44100</HZ><SampleWidth>16</SampleWidth><AudioChns>1</AudioChns><BitRate>8000</BitRate>
        
        NSString * xml=[NSString stringWithFormat:@"<root>%@</root>",result];
        TBXML * tbxml = [TBXML newTBXMLWithXMLString:xml error:nil];
        TBXMLElement *root = tbxml.rootXMLElement;
        
        TBXMLElement *linkReturn=[TBXML childElementNamed:@"LinkReturn" parentElement:root];
        if(linkReturn)
        {
            NSString *isSuccess=[TBXML textForElement:linkReturn];
            TBXMLElement * HZ=[TBXML childElementNamed:@"AudioCodeID" parentElement:root];
            if(HZ)
            {
               // NSString *hz=[TBXML textForElement:HZ];
            }
            
            TBXMLElement * SampleWidth=[TBXML childElementNamed:@"AudioCodeID" parentElement:root];
            if(SampleWidth)
            {
               // NSString *samplewidth=[TBXML textForElement:SampleWidth];
            }
            if([isSuccess isEqualToString:@"SUCCESS"])
            {
                TBXMLElement * AudioCodeID=[TBXML childElementNamed:@"AudioCodeID" parentElement:root];
                if(AudioCodeID)
                {
                    NSString * codeid=[TBXML textForElement:AudioCodeID];
                    //audiocodec = avcodec_find_decoder();
                    audiocodec=avcodec_find_decoder([codeid intValue]);
                    
                    if (!audiocodec)
                    {
                        
                    }
                    
                    codecaudioCtx=avcodec_alloc_context3(audiocodec);
                    int ret=avcodec_open2(codecaudioCtx, audiocodec, NULL);
                    if(ret!=0)
                    {
                        
                    }
                    TBXMLElement * BitRate=[TBXML childElementNamed:@"AudioCodeID" parentElement:root];
                    if(BitRate)
                    {
                        NSString *bitrate=[TBXML textForElement:BitRate];
                        codecaudioCtx->bit_rate=[bitrate intValue];
                    }

                    TBXMLElement * AudioChns=[TBXML childElementNamed:@"AudioCodeID" parentElement:root];
                    if(AudioChns)
                    {
                        NSString *chns=[TBXML textForElement:AudioChns];
                        codecaudioCtx->channels=[chns intValue];
                    }
                    
                    
                }
                
                NSString *respon=@"<TYPE>ImOK</TYPE>";
                NSData *data = [[NSData alloc] initWithData:[respon dataUsingEncoding:NSASCIIStringEncoding]];
                [socket sendData:(char *)[data bytes] length:[data length] type:12 block:^(BOOL success, NSString *result) {
                    
                    NSLog(@"%@",result);
                    
                } streamBlock:^(NSData *data, int length,NSError *error) {
                    
        
                    
                    if(HUD)
                    {
                        [HUD removeFromSuperview];
                        HUD=nil;
                    }
                    
                    if(error!=nil)
                    {
                        [self.navigationController popViewControllerAnimated:YES];
                        return ;
                    }
                 
                        AVPacket packet;
                        av_init_packet(&packet);
                        packet.data=[data bytes];
                        
                        packet.size=length;
                        packet.flags=AV_PKT_FLAG_KEY;
                        int got_picture,ret;
                        ret = avcodec_decode_video2(codecCtx, frame, &got_picture, &packet);
                        if (ret < 0) {
                            NSLog(@"decode error");
                            return;
                        }
                        if (!got_picture) {
                            NSLog(@"didn't get picture");
                            return;
                        }
                        if(got_picture)//成功解码
                        {
                            
                            outputWidth = codecCtx->width;
                            outputHeight = codecCtx->height;
                            static int sws_flags =  SWS_FAST_BILINEAR;
                            if (!img_convert_ctx)
                                img_convert_ctx = sws_getContext(codecCtx->width,
                                                                 codecCtx->height,
                                                                 codecCtx->pix_fmt,
                                                                 outputWidth,
                                                                 outputHeight,
                                                                 PIX_FMT_YUV420P,
                                                                 sws_flags, NULL, NULL, NULL);
                            
                            avpicture_alloc(&picture, PIX_FMT_YUV420P, outputWidth, outputHeight);
                            if (!frame->data[0])
                            {
                                NSLog(@"empty");
                            }
                            
                            sws_scale(img_convert_ctx, (const uint8_t* const*)frame->data, frame->linesize, 0, frame->height, picture.data, picture.linesize);
                            
                            int picSize = codecCtx->height * codecCtx->width;
                            int newSize = picSize * 1.5;
                            
                            unsigned char * buf=malloc(newSize * sizeof(unsigned char));
                            int height =codecCtx->height;
                            int width = codecCtx->width;
                            //写入数据
                            int a=0,i;
                            for (i=0; i<height; i++)
                            {
                                memcpy(buf+a,picture.data[0] + i * picture.linesize[0], width);
                                a+=width;
                            }
                            for (i=0; i<height/2; i++)
                            {
                                memcpy(buf+a,picture.data[1] + i * picture.linesize[1], width/2);
                                a+=width/2;
                            }
                            for (i=0; i<height/2; i++)
                            {
                                memcpy(buf+a,picture.data[2] + i * picture.linesize[2], width/2);
                                a+=width/2;
                            }
                            [glView displayYUV420pData:buf width:outputWidth height:outputHeight];
                           // [NSThread sleepForTimeInterval:40/1000.0f];
                            free(buf);
                            avpicture_free(&picture);
                            av_free_packet(&packet);
                        }

                }];
            }
        }

    } streamBlock:^(NSData *data, int length,NSError *error) {
        
    }];

}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval) duration {
    
    CGSize size=[UIScreen mainScreen].bounds.size;
    if (UIInterfaceOrientationIsPortrait(toInterfaceOrientation)) {
        NSLog(@"ss");
        
       // glView = [[OpenGLView20 alloc] initWithFrame:CGRectMake(0, NAVIHEIGHT + (ios7 ? 20 : 0), self.view.frame.size.width, self.view.frame.size.height-( NAVIHEIGHT + (ios7 ? 20 : 0)))];
        
        navigationBackView.frame=CGRectMake(0, (ios7 ? 20 : 0), size.width, NAVIHEIGHT);
       
          glView.frame=CGRectMake(0, (ios7 ? 20 : 0)+NAVIHEIGHT, size.width, size.height-NAVIHEIGHT-(ios7 ? 20 : 0));
        //设置视频原始尺寸
    } else {
        NSLog(@"dd");
       // glView = [[OpenGLView20 alloc] initWithFrame:CGRectMake(0, NAVIHEIGHT + (ios7 ? 20 : 0), self.view.frame.size.width, self.view.frame.size.height-( NAVIHEIGHT + (ios7 ? 20 : 0)))];
        //设置视频原始尺寸
        navigationBackView.frame=CGRectZero;
        glView.frame=CGRectMake(0,0, size.width, size.height);
    }
      //  middleLabel=[[UILabel alloc]initWithFrame:CGRectMake(160-100, 13 + (ios7 ? 20 : 0), 200, 20)];
   // middleLabel.frame=CGRectMake(50, 13+(ios7 ? 20 : 0), size.width-100,20);
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
