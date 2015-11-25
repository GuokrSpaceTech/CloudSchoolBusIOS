//
//  URLLinkView.m
//  CloudBusParent
//
//  Created by macbook on 15/11/25.
//  Copyright © 2015年 BeiJingYinChuang. All rights reserved.
//

#import "URLLinkView.h"
#import "CBWebViewController.h"

@interface URLLinkView()
{
    NSString *urlString;
}
@end


@implementation URLLinkView
-(void)setMessage:(Message *)message
{
    _title.text = message.title;
    _desc.text = message.desc;
    
    if([message.apptype compare:@"Report"])
    {
        _iconImage.image = [UIImage imageNamed:@"Report"];
    }
    
    NSDictionary *bodyDict = [_message bodyObject];
    urlString = bodyDict[@"PList"];
    
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
