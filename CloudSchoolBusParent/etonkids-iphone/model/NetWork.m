//
//  NetWork.m
//  etonkids-iphone
//
//  Created by WenPeiFang on 2/21/13.
//  Copyright (c) 2013 wpf. All rights reserved.
//

#import "NetWork.h"
#import <sys/socket.h>
#import <netinet/in.h>
#import <arpa/inet.h>
#import <SystemConfiguration/SystemConfiguration.h>
@implementation NetWork
+(BOOL)connectedToNetWork
{
 
    struct sockaddr_in zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sin_len=sizeof(zeroAddress);
    zeroAddress.sin_family=AF_INET;
    
    
    SCNetworkReachabilityRef defaultRouteReachabiltiy=SCNetworkReachabilityCreateWithAddress(NULL,  (struct sockaddr *)&zeroAddress);
    
    SCNetworkReachabilityFlags flags;
    BOOL didRetriveFlags=SCNetworkReachabilityGetFlags(defaultRouteReachabiltiy, &flags);
    if(!didRetriveFlags)
    {
        return NO;
    }
    BOOL isReachable=flags&kSCNetworkFlagsReachable;
    
    BOOL needsConnect=flags &kSCNetworkFlagsConnectionRequired;
    return (isReachable&&!needsConnect)?YES:NO;
    
}
@end
