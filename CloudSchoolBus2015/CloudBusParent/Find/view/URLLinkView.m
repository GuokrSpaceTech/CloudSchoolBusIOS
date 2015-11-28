//
//  URLLinkView.m
//  CloudBusParent
//
//  Created by macbook on 15/11/25.
//  Copyright © 2015年 BeiJingYinChuang. All rights reserved.
//

#import "URLLinkView.h"
#import "CBWebViewController.h"
#import "CBLoginInfo.h"

@interface URLLinkView()
{
    NSString *urlString;
}
@end


@implementation URLLinkView
-(void)setMessage:(Message *)message
{
    _message = message;
    _title.text = message.title;
    _desc.text = message.desc;
    
    if([_message.apptype isEqualToString:@"Report"])
        _iconImage.image = [UIImage imageNamed:@"report"];
    
    NSDictionary *bodyDict = [_message bodyObject];
 
    urlString = bodyDict[@"PList"];
    
    NSString *sid = [[CBLoginInfo shareInstance] sid];
    urlString = [[NSString alloc] initWithFormat: @"%@?sid=%@", urlString, sid];
    
    if(bodyDict[@"reportType"] != nil)
        _desc.text = bodyDict[@"reportType"];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    
    tapGesture.numberOfTapsRequired = 1;
    
    [_containerView addGestureRecognizer:tapGesture];
}

-(void)handleSingleTap: (id)sender
{
    if(_delegate)
    {
        [_delegate userTapHandles:_title.text withURL:urlString];
    }
}
@end
