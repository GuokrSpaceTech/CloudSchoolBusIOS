//
//  GKMovieManager.h
//  etonkids-iphone
//
//  Created by CaiJingPeng on 14-1-17.
//  Copyright (c) 2014年 wpf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GKMovieCell.h"

@interface GKMovieManager : NSObject

@property (nonatomic, retain)GKMovieCell *playingCell;
//@property (nonatomic, retain)UITableViewCell *playingCell;



+ (id)shareManager;

- (void)toggleMoviePlayingWithCell:(GKMovieCell *)cell;


@end
