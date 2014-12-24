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

-(void)dealloc
{
   // self.device=nil;
    
    free(frameData);
    [super dealloc];
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [UIApplication sharedApplication].statusBarHidden=NO;;
    [UIApplication sharedApplication].idleTimerDisabled=NO;
}
- (void)leftButtonClick:(id)sender
{
    UserLogin *user=[UserLogin currentLogin];
    NSString *ddns=user.ddns;
    NSString *prot=user.port;
    [[GKSocket instanceddns:ddns port:prot] cleanUpStream];
    [UIApplication sharedApplication].idleTimerDisabled=NO;
    [UIApplication sharedApplication].statusBarHidden=NO;;
   // [[GKSocket instance] cleanUpStream];
    [self.navigationController popViewControllerAnimated:YES];
}
-(BOOL)prefersStatusBarHidden
{
    return YES;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor blackColor];



    [UIApplication sharedApplication].idleTimerDisabled=YES;
 
    [UIApplication sharedApplication].statusBarHidden=YES;;

    
    
    glView = [[OpenGLView20 alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.height, self.view.frame.size.width)];
    //设置视频原始尺寸
    [glView setVideoSize:352 height:288];
    //渲染yuv
    [self.view addSubview:glView];
    
    self.view.transform= CGAffineTransformMakeRotation(M_PI/2);;
    
    UIButton *leftButton =[UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setFrame:CGRectMake(300, 10, 50, 35)];
    [leftButton setCenter:CGPointMake(10 + 34/2, navigationBackView.frame.size.height/2+ (ios7 ? 20 : 0))];
    [leftButton setImage:[UIImage imageNamed:@"backBtnDefault_3.0.png"] forState:UIControlStateNormal];
    [leftButton setImage:[UIImage imageNamed:@"backBtnSel_3.0.png"] forState:UIControlStateHighlighted];
    [leftButton addTarget:self action:@selector(leftButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:leftButton];
    
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

    [self loadVideo];
}


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
    GKSocket *socket=[GKSocket instanceddns:@"54.223.156.59" port:prot];

    NSString *response=[NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"GB2312\" standalone=\"yes\"?> <TYPE>StartStream</TYPE>\
                        <DVRName>%@</DVRName>\
                        <ChnNo>0</ChnNo> <StreamType>1/StreamType>",@"dvr"];
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
//                TBXMLElement * AudioCodeID=[TBXML childElementNamed:@"AudioCodeID" parentElement:root];
//                if(AudioCodeID)
//                {
//                    NSString * codeid=[TBXML textForElement:AudioCodeID];
//                    //audiocodec = avcodec_find_decoder();
//                    audiocodec=avcodec_find_decoder([codeid intValue]);
//                    
//                    if (!audiocodec)
//                    {
//                        
//                    }
//                    
//                    codecaudioCtx=avcodec_alloc_context3(audiocodec);
//                    int ret=avcodec_open2(codecaudioCtx, audiocodec, NULL);
//                    if(ret!=0)
//                    {
//                        
//                    }
//                    TBXMLElement * BitRate=[TBXML childElementNamed:@"AudioCodeID" parentElement:root];
//                    if(BitRate)
//                    {
//                        NSString *bitrate=[TBXML textForElement:BitRate];
//                        codecaudioCtx->bit_rate=[bitrate intValue];
//                    }
//
//                    TBXMLElement * AudioChns=[TBXML childElementNamed:@"AudioCodeID" parentElement:root];
//                    if(AudioChns)
//                    {
//                        NSString *chns=[TBXML textForElement:AudioChns];
//                        codecaudioCtx->channels=[chns intValue];
//                    }
//                    
//                    
//                }
                
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
                        packet.data=(uint8_t*)[data bytes];
                        
                        packet.size=length;
                        packet.flags=AV_PKT_FLAG_KEY;
                        int got_picture,ret;
                        ret = avcodec_decode_video2(codecCtx, frame, &got_picture, &packet);
//                        if (ret < 0) {
//                            NSLog(@"decode error");
//                            return;
//                        }
//                        if (!got_picture) {
//                            NSLog(@"didn't get picture");
//                            return;
//                        }
                        if(got_picture)//成功解码
                        {
                            
                            outputWidth = codecCtx->width;
                            outputHeight = codecCtx->height;
//                            static int sws_flags =  SWS_FAST_BILINEAR;
//                            if (!img_convert_ctx)
//                                img_convert_ctx = sws_getContext(codecCtx->width,
//                                                                 codecCtx->height,
//                                                                 codecCtx->pix_fmt,
//                                                                 outputWidth,
//                                                                 outputHeight,
//                                                                 PIX_FMT_YUV420P,
//                                                                 sws_flags, NULL, NULL, NULL);
//                            
//                            avpicture_alloc(&picture, PIX_FMT_YUV420P, outputWidth, outputHeight);
//                            if (!frame->data[0])
//                            {
//                                NSLog(@"empty");
//                            }
//                            
//                            sws_scale(img_convert_ctx, (const uint8_t* const*)frame->data, frame->linesize, 0, frame->height, picture.data, picture.linesize);
                            
                            int picSize = codecCtx->height * codecCtx->width;
                            int newSize = picSize * 1.5;
                            
                            unsigned char * buf=malloc(newSize * sizeof(unsigned char));
                            int height =codecCtx->height;
                            int width = codecCtx->width;
                            //写入数据
                            int a=0,i;
                            for (i=0; i<height; i++)
                            {
                                memcpy(buf+a,frame->data[0] + i * frame->linesize[0], width);
                                a+=width;
                            }
                            for (i=0; i<height/2; i++)
                            {
                                memcpy(buf+a,frame->data[1] + i * frame->linesize[1], width/2);
                                a+=width/2;
                            }
                            for (i=0; i<height/2; i++)
                            {
                                memcpy(buf+a,frame->data[2] + i *frame->linesize[2], width/2);
                                a+=width/2;
                            }
                            [glView displayYUV420pData:buf width:outputWidth height:outputHeight];
                      
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

- (void)deviceOrientationDidChange

{
    [[UIApplication sharedApplication] setStatusBarOrientation:UIDeviceOrientationLandscapeLeft animated:YES];
    UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    
   // CGFloat startRotation = [[self valueForKeyPath:@"layer.transform.rotation.z"] floatValue];
    
    CGAffineTransform rotation;
    
    switch (interfaceOrientation) {
            
        case UIInterfaceOrientationLandscapeLeft:
            
            rotation = CGAffineTransformMakeRotation(M_PI*1.5);;
            
            break;

            
        default:
            
            rotation =CGAffineTransformIdentity;
            
            break;
            
    }
    
    self.view.transform = rotation;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
