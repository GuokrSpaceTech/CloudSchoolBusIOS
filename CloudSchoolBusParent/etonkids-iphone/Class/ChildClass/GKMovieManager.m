//
//  GKMovieManager.m
//  etonkids-iphone
//
//  Created by CaiJingPeng on 14-1-17.
//  Copyright (c) 2014年 wpf. All rights reserved.
//

#import "GKMovieManager.h"

@implementation GKMovieManager

static GKMovieManager *mm ;
+ (id)shareManager
{
    if (mm == nil) {
        mm = [[GKMovieManager alloc] init];
    }
    return mm;
}

- (void)toggleMoviePlayingWithCell:(GKMovieCell *)cell
{
    
    
    
//    if ([cell isEqual:self.playingCell]) {
//        return;
//    }
//    NSLog(@"+++++++++++++++++ %@",cell);
//    NSLog(@"----------------- %@",self.playingCell);
    
    if (self.playingCell) {
        [self.playingCell.mPlayer pause];
    }
    
//    [cell.mPlayer prepareToPlay];
    
    
    [cell.mPlayer play];
    self.playingCell = cell;
    
}



@end
