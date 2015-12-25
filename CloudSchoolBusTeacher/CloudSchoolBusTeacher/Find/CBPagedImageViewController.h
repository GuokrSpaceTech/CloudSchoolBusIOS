//
//  CBPagedImageViewController.h
//  CloudBusParent
//
//  Created by mactop on 11/22/15.
//  Copyright © 2015 BeiJingYinChuang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CBPagedImageViewController : UIViewController <UIScrollViewDelegate>
@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) IBOutlet UIPageControl *pageControl;
@property (strong, nonatomic) NSString *comments;
@property (nonatomic, strong) NSArray *pageImages;
@property (nonatomic, strong) NSNumber *startIndex;
@end
