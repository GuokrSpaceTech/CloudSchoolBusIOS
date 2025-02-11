//
//  ETShowBigImageView.m
//  etonkids-iphone
//
//  Created by CaiJingPeng on 13-7-17.
//  Copyright (c) 2013年 wpf. All rights reserved.
//

#import "ETShowBigImageView.h"
#import "ETKids.h"
#import "ShareContent.h"
#import <CoreMotion/CoreMotion.h>

#import "ETShowBigImageViewController.h"

#define IMAGEVIEWHEIGHT [UIScreen mainScreen].applicationFrame.size.height
@implementation ETShowBigImageView
@synthesize imgSV,imgUrlArr,imgVArr;
@synthesize content;
@synthesize rightButton,leftButton,delegate;

- (id)initWithFrame:(CGRect)frame AndShowImageNum:(NSInteger)num dataArr:(NSArray *)array content:(NSString *)_content
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        originShowNum = num;
        
        self.backgroundColor = [UIColor blackColor];
        
        self.imgUrlArr = array;
        self.content=_content;
        self.imgVArr = [NSMutableArray array];
        self.backgroundColor = [UIColor blackColor];
                
        navigationBackView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, NAVIHEIGHT)];
        navigationBackView.image=[UIImage imageNamed:@"navigationNoText.png"];
        navigationBackView.userInteractionEnabled = YES;
        
        
        leftButton =[UIButton buttonWithType:UIButtonTypeCustom];
        [leftButton setFrame:CGRectMake(0, 0, 50, 35)];
        [leftButton setCenter:CGPointMake(10 + 34/2, navigationBackView.frame.size.height/2)];
        [leftButton setImage:[UIImage imageNamed:@"backBtnDefault_3.0.png"] forState:UIControlStateNormal];
        [leftButton setImage:[UIImage imageNamed:@"backBtnSel_3.0.png"] forState:UIControlStateHighlighted];
        [leftButton addTarget:self action:@selector(leftButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [navigationBackView addSubview:leftButton];
        
        rightButton =[UIButton buttonWithType:UIButtonTypeCustom];
        [rightButton setFrame:CGRectMake(0, 0, 50, 35)];
        [rightButton addTarget:self action:@selector(rightButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [rightButton setCenter:CGPointMake(320 - 10 - 50/2, navigationBackView.frame.size.height/2)];
        [rightButton setImage:[UIImage imageNamed:@"shareBtn3.0.png"] forState:UIControlStateNormal];
        [rightButton setImage:[UIImage imageNamed:@"shareBtnSel3.0.png"] forState:UIControlStateHighlighted];
        [navigationBackView addSubview:rightButton];


        
        item=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 40)];
        item.center = CGPointMake(160, NAVIHEIGHT/2);
        item.textColor = [UIColor whiteColor];
        item.backgroundColor = [UIColor clearColor];
        item.textAlignment = NSTextAlignmentCenter;
        item.font = [UIFont boldSystemFontOfSize:20];
        item.text = [NSString stringWithFormat:@"%ld / %lu",originShowNum + 1,(unsigned long)self.imgUrlArr.count];
        [navigationBackView addSubview:item];
        [item release];
        
        
        
        width=320;
        
        
        
        scrollV = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, frame.size.height)];
        scrollV.contentSize = CGSizeMake(width * self.imgUrlArr.count, scrollV.frame.size.height);
        scrollV.backgroundColor = [UIColor blackColor];
        scrollV.delegate = self;
        scrollV.pagingEnabled = YES;
        scrollV.contentOffset = CGPointMake(width * originShowNum, 0);
        [self addSubview:scrollV];
        [scrollV release];
        
        self.imgSV = scrollV;
        
        
        [self createZoomView];
//        for (int i = 0; i < array.count; i++) {
//            ETZoomScrollView *imgV = [[ETZoomScrollView alloc] initWithFrame:CGRectMake(width*i, 0, width, scrollV.frame.size.height)];
//            imgV.backgroundColor = [UIColor blackColor];
////            imgV.contentMode = UIViewContentModeScaleAspectFit;
//            imgV.tag = 777 + i;
//            imgV.tDelegate = self;
//            
//            [scrollV addSubview:imgV];
//            [imgV release];
//            
//            [self.imgVArr addObject:imgV];
//        }
//        
//        
//        [self downloadBigImage];
        
        
        [self addSubview:navigationBackView];
        [navigationBackView release];
        
        
    }
    return self;
}

- (void)createZoomView
{
    
    for (int i = 0; i < self.imgUrlArr.count; i++) {
        ETZoomScrollView *imgV = [[ETZoomScrollView alloc] initWithFrame:CGRectMake(width*i, 0, scrollV.frame.size.width, scrollV.frame.size.height)];
        imgV.backgroundColor = [UIColor blackColor];
        //            imgV.contentMode = UIViewContentModeScaleAspectFit;
        imgV.tag = 777 + i;
        imgV.tDelegate = self;
        
        [scrollV addSubview:imgV];
        [imgV release];
        
        [self.imgVArr addObject:imgV];
    }
    
    
    [self downloadBigImage];
}
- (void)signInOnViewController:(UIViewController *)viewController
{}
- (void)reloadFrame:(UIInterfaceOrientation)orientation
{
  //  NSLog(@"%ld",(long)originShowNum);
    
    NSInteger temp = originShowNum;
        navigationBackView.frame = CGRectMake(0, 0, 320, NAVIHEIGHT);
        item.center = CGPointMake(320/2, NAVIHEIGHT/2);
        rightButton.frame=CGRectMake(320 - 10 - 40, (NAVIHEIGHT - 35)/2.0f,50, 35);
        scrollV.frame = CGRectMake(0, 0, width, IMAGEVIEWHEIGHT);
        scrollV.contentOffset = CGPointMake(width *originShowNum, 0);
        scrollV.contentSize = CGSizeMake(width * self.imgUrlArr.count, scrollV.frame.size.height);
        
        
        for (id obj in scrollV.subviews) {
            
            if ([obj isKindOfClass:[ETZoomScrollView class]]) {
                ETZoomScrollView *imgV = (ETZoomScrollView *)obj;
                if (imgV.tag >= 777) {
                    imgV.frame = CGRectMake(width*(imgV.tag % 777), 0, width, scrollV.frame.size.height);
                    imgV.zoomScale = 1;
                    imgV.imageView.frame = CGRectMake(0, 0, width, scrollV.frame.size.height);
                    
                }
            }
            
        }
        
        
        //NSLog(@"%d",originShowNum);
        
    //}

    originShowNum = temp;
    
    if ([self viewWithTag:555])
    {
        MTCustomActionSheet *action = (MTCustomActionSheet *)[self viewWithTag:555];
        [action reloadFrame:orientation];
    }
    
    
}


- (void)handleSingleTap
{
    
    CABasicAnimation *opacity=[CABasicAnimation animationWithKeyPath:@"opacity"];
    
    opacity.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    opacity.duration =0.5f;
    
    if (navigationBackView.alpha == 0)
    {
        opacity.fromValue = [NSNumber numberWithFloat:0];
        opacity.toValue = [NSNumber numberWithFloat:1];
    }
    else
    {
        opacity.fromValue = [NSNumber numberWithFloat:1];
        opacity.toValue = [NSNumber numberWithFloat:0];
    }
    opacity.removedOnCompletion=NO;
    opacity.fillMode=kCAFillModeForwards;
    
    
    [navigationBackView.layer addAnimation:opacity forKey:@"111"];
    
//    [self performSelector:@selector(hideNav) withObject:nil afterDelay:0.7f];

    
    navigationBackView.alpha = (int)(navigationBackView.alpha + 1) % 2;
    
    
}





-(void)leftButtonClick:(UIButton*)sender
{
    if (delegate && [delegate respondsToSelector:@selector(didClickBackButton)]) {
        [delegate didClickBackButton];
    }
}

-(void)rightButtonClick:(UIButton*)sender
{
    ETShowBigImageViewController *vc = (ETShowBigImageViewController *)self.delegate;
    
    NSArray *imgArr = [NSArray arrayWithObjects:@"保存.png",@"logo_sinaweibo.png",@"腾讯微博.png",@"logo_wechat.png",@"logo_wechatmoments(1).png",@"email.png", nil];
    NSArray *nameArr = [NSArray arrayWithObjects:LOCAL(@"savePhoto", @""),LOCAL(@"sina", @""),LOCAL(@"tencent", @""),LOCAL(@"wechat", @""),LOCAL(@"friend", @"分享到微信朋友圈"),LOCAL(@"mail",@""), nil];
    
    
    
    MTCustomActionSheet *actionSheet = [[MTCustomActionSheet alloc] initWithFrame:CGRectZero andImageArr:imgArr nameArray:nameArr orientation:UIDeviceOrientationPortrait];
    actionSheet.delegate = self;
    actionSheet.tag = 555;
    [actionSheet showInView:vc.view];
    [actionSheet release];
    
  
}


/**
 *	@brief  MTCustomActionSheet 按钮点击回调事件.
 *
 *	@param 	actionSheet   当前实例.
 *	@param 	index 	点击的按钮编号.
 */
- (void)actionSheet:(MTCustomActionSheet *)actionSheet didClickButtonByIndex:(int)index
{
    
    if(index==0)
    {
        if(saveHUD==nil)
        {
            saveHUD=[[MBProgressHUD alloc]initWithView:self];
            
            [self addSubview:saveHUD];
            [saveHUD show:YES];
            [saveHUD release];
        }
        
        ETZoomScrollView *zoomImgV = [self.imgVArr objectAtIndex:originShowNum];
        UIImageWriteToSavedPhotosAlbum(zoomImgV.imageView.image, self, @selector(imageSavedToPhotosAlbum: didFinishSavingWithError: contextInfo:), nil);
        
    }
//    else if (index == 5)
//    {
//        
//        
//        
//        MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
//        mc.mailComposeDelegate = self;
//        [mc setSubject:@"Hello, World!"];
//    }
    else if (index == 6)
    {
        
    }
    else
    {
        ETZoomScrollView *zoomImgV = [self.imgVArr objectAtIndex:originShowNum];
        if (delegate && [delegate respondsToSelector:@selector(didSelectedShareImage:shareType:content:)]) {
            [delegate didSelectedShareImage:zoomImgV.imageView.image shareType:index content:self.content];
        }
    }
    
}


- (void)request:(WeiboRequest *)request didFailWithError:(NSError *)error {

    ETCustomAlertView *alert=[[ETCustomAlertView alloc]initWithTitle:LOCAL(@"alert", @"提示") message:LOCAL(@"fail",  @"发送失败") delegate:nil cancelButtonTitle:LOCAL(@"ok", @"确定") otherButtonTitles:nil, nil];
    [alert show];
    
    [request release];
    
}
- (void)request:(WeiboRequest *)request didLoad:(id)result {
    
    ETCustomAlertView *alert=[[ETCustomAlertView alloc]initWithTitle:LOCAL(@"alert", @"提示") message:LOCAL(@"success", @"发送成功") delegate:nil cancelButtonTitle:LOCAL(@"ok", @"确定") otherButtonTitles:nil, nil];
    [alert show];
    
    [request release];
}


/// 下载大图.
- (void)downloadBigImage
{
    ETZoomScrollView *zoomView = [self.imgVArr objectAtIndex:originShowNum];
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:zoomView];
    hud.center = CGPointMake(scrollV.frame.size.width/2 + originShowNum*scrollV.frame.size.width, scrollV.frame.size.height/2.0f);
    hud.mode = MBProgressHUDModeAnnularDeterminate;
    //hud.tag = HUDTAG + i;
    [self.imgSV addSubview:hud];
    [hud release];
    [hud show:YES];
    
    NSDictionary * dic = [self.imgUrlArr objectAtIndex:originShowNum];
    NSString * path = [dic objectForKey:@"source"];
    NSURL *url = [NSURL URLWithString:path];
    [zoomView.imageView setImageWithURL:url placeholderImage:nil options:SDWebImageRetryFailed progress:^(NSUInteger receivedSize, long long expectedSize) {
        
        hud.progress = receivedSize/(float)expectedSize;
        
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
        zoomView.imageView.image = image;
        [hud removeFromSuperview];
    }];
}


- (void)imageSavedToPhotosAlbum:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *) contextInfo {
    NSString *message;
   // NSString *title;
    
    if(saveHUD)
    {
        [saveHUD removeFromSuperview];
        saveHUD=nil;
        
    }
    if (!error) {
        //title = LOCAL(@"alert", @"提示");
        message = LOCAL(@"success", @"保存成功");
    } else {
       // title =LOCAL(@"fail",  @"失败");
       // message = [error description];
        
       // message=@"没有相册访问权限，请在\"设置\"--\"隐私\"--\"照片\"--\"云中校车\"中设置";
        message=NSLocalizedString(@"privacy", @"");
    }
    ETCustomAlertView *alert = [[ETCustomAlertView alloc] initWithTitle:nil message:message delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
    [alert show];
    
}



// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{            
    if (scrollView == scrollV) {
        int offset = (int)scrollV.contentOffset.x/scrollV.frame.size.width;
//        NSLog(@"offset  %f,%f , %d",scrollV.contentOffset.x,scrollV.frame.size.width,offset);
        
        if ((int)scrollView.contentOffset.x % (int)scrollV.frame.size.width == 0) {
            
            if (offset != originShowNum) {
                originShowNum = offset;
                item.text = [NSString stringWithFormat:@"%ld / %lu",originShowNum + 1,(unsigned long)self.imgUrlArr.count];
                
                [self downloadBigImage];
                
                
                for (id obj in scrollV.subviews) {
                    
                    if ([obj isKindOfClass:[ETZoomScrollView class]]) {
                        ETZoomScrollView *imgV = (ETZoomScrollView *)obj;
                        if (imgV.tag >= 777) {
                            imgV.zoomScale = 1;
                            imgV.imageView.center = CGPointMake(imgV.frame.size.width/2,imgV.frame.size.height/2);
                            
                        }
                    }
                    
                }
                
            }
        }
    }
}

- (BOOL)shouldAutorotate
{
    return NO;
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    
    return toInterfaceOrientation==UIInterfaceOrientationPortrait;
    
}
- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationPortrait;
}


- (void)dealloc
{
    self.imgSV = nil;
    self.imgUrlArr = nil;
    self.imgVArr = nil;
    self.content=nil;
    [super dealloc];
}



@end
