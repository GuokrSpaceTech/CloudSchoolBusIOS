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

#import "OpenGLView20.h"
const int Header = 101;
const int Data = 102;
@interface GKVideoViewController ()
{
    AVFrame *frame;
    AVPicture picture;
    AVCodec *codec;
    AVCodecContext *codecCtx;
    AVPacket packet;
    struct SwsContext *img_convert_ctx;
    
    NSMutableData *keyFrame;
    
    int outputWidth;
    int outputHeight;


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
    
    //./0, , 320, (iphone5 ? 548 : 460) - NAVIHEIGHT
    glView = [[OpenGLView20 alloc] initWithFrame:CGRectMake(0, NAVIHEIGHT + (ios7 ? 20 : 0), self.view.frame.size.width, self.view.frame.size.height-( NAVIHEIGHT + (ios7 ? 20 : 0)))];
    //设置视频原始尺寸
    [glView setVideoSize:352 height:288];
    //渲染yuv
    [self.view addSubview:glView];
    
    //iamgeView=[[UIImageView alloc]initWithFrame:CGRectMake(10, 100,290,400)];
//    iamgeView.backgroundColor=[UIColor clearColor];
//    [self.view addSubview:iamgeView];
  //  [glView setTransform:CGAffineTransformMakeRotation(M_PI/2)];

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
            
        } streamBlock:^(BOOL header, char * result, int length) {
            NSLog(@"%s",result);
            
          if(header==NO)
          {
              
           //   [keyFrame appendBytes:[data bytes] length:[data length]
             
//              [keyFrame appendBytes:result length:length];
//              
//              int nalLen = (int)[keyFrame length];
//              av_new_packet(&packet, nalLen);
//              memcpy(packet.data, [keyFrame bytes], nalLen);
              

             // av_init_packet(&packet);
              packet.data=result;
              packet.size=length-28;
              
              int ret, got_picture;
              ret = avcodec_decode_video2(codecCtx, frame, &got_picture, &packet);
              //NSLog(@"decode finish");
              if (ret < 0) {
                  NSLog(@"decode error");
                  return;
              }
              if (!got_picture) {
                  NSLog(@"didn't get picture");
                  return;
              }
              if(ret==1)
                  return;
              if(got_picture)//成功解码
              {
                  
                  NSLog(@"成功解码");
                  
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
                  
                  ret = sws_scale(img_convert_ctx, (const uint8_t* const*)frame->data, frame->linesize, 0, frame->height, picture.data, picture.linesize);
                  
                  
                  
                  int picSize = codecCtx->height * codecCtx->width;
                  int newSize = picSize * 1.5;
                  
                  //申请内存
                 // unsigned char *buf = new unsigned char[newSize];
                  
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
                  
                  //[self display];
                                   NSLog(@"show frame finish");
                  avpicture_free(&picture);
                  av_free_packet(&packet);
                  

              }
             
          }

            
        }];

    } streamBlock:^(BOOL header, char * result, int length) {
        
    }];

}
-(void)display
{
    UIImage *iamge=[self imageFromAVPicture:picture width:outputWidth height:outputHeight];
    iamgeView.frame=CGRectMake(10, 100, outputWidth, outputHeight);
    iamgeView.image=iamge;

}
-(void)uploadUI:(UIImage *)image
{
    iamgeView.image=image;
}
//- (UIImage *) asImage
//{
//    UIImage *image = nil;
//    CFDataRef data=(CFDataRef)picture;
//    CGDataProviderRef provider = CGDataProviderCreateWithCFData(data);
//    if (provider) {
//        
//        CGImageRef imageRef = CGImageCreateWithJPEGDataProvider(provider,
//                                                                NULL,
//                                                                YES,
//                                                                kCGRenderingIntentDefault);
//        if (imageRef) {
//            
//            image = [UIImage imageWithCGImage:imageRef];
//            CGImageRelease(imageRef);
//        }
//        CGDataProviderRelease(provider);
//    }
//    
//    return image;
//    
//}
-(UIImage *)imageFromAVPicture:(AVPicture)pict width:(int)width height:(int)height {
	CGBitmapInfo bitmapInfo =kCGBitmapByteOrderDefault;
    CFDataRef data =CFDataCreateWithBytesNoCopy(kCFAllocatorDefault, pict.data[0], pict.linesize[0]*height,kCFAllocatorNull);
    CGDataProviderRef provider =CGDataProviderCreateWithCFData(data);
    CGColorSpaceRef colorSpace =CGColorSpaceCreateDeviceRGB();
    int bitsPerComponent = 8;              // 8位存储一个Component
    int bitsPerPixel = 3 * bitsPerComponent;         // RGB存储，只用三个字节，而不是像RGBA要用4个字节，所以这里一个像素点要3个8位来存储
    // 这里3个字节是来自于 PIX_FMT_RGB24的定义中说明的， 是一个24位的数据，其中RGB各占8位
   // 这里// PIX_FMT_RGB24,    ///< packed RGB 8:8:8, 24bpp, RGBRGB...
    
    int bytesPerRow =3 * width;           // 每行有width个象素点，每个点用3个字节，另外注意：pict.linesize[0]=bytesPerRow=1056
    CGImageRef cgImage =CGImageCreate(width,
                                      height,
                                      bitsPerComponent,
                                      bitsPerPixel,
                                      bytesPerRow,//pict.linesize[0],等效
                                      colorSpace,
                                      bitmapInfo,
                                      provider, 
                                      NULL, 
                                      NO, 
                                      kCGRenderingIntentDefault);
    CGColorSpaceRelease(colorSpace);
    UIImage *image = [UIImage imageWithCGImage:cgImage];
    CGImageRelease(cgImage);
    CGDataProviderRelease(provider);
    CFRelease(data);
    return image;
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
