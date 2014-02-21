//
//  myProgressView.h
//  ListenBooks
//
//  Created by wpf on 5/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DACircularProgressView.h"
@interface myProgressView : UIView
{
    UILabel *processLabel;
    CGFloat progress_;
   
    
    DACircularProgressView *processView;
}
@property(nonatomic,retain)UILabel *processLabel;
@property(nonatomic,assign,readwrite) CGFloat progress;

@end
