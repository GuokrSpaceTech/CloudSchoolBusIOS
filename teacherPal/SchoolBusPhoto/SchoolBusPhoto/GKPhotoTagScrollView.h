//
//  GKPhotoTagScrollView.h
//  SchoolBusPhoto
//
//  Created by CaiJingPeng on 14-1-8.
//  Copyright (c) 2014年 mactop. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GKPhotoTagScrollViewDelegate <NSObject>

- (void)didSelectPhotoTag:(NSString *)tag;

@end

@interface GKPhotoTagScrollView : UIScrollView
{
    int selectedTag;
}
@property (nonatomic, assign)id<GKPhotoTagScrollViewDelegate> tagDelegate;
@property (nonatomic, retain) NSArray *photoTags;
-(void)setSelectTag:(NSString *) tagstr;
- (void)setPhotoTags:(NSArray *)tags;

@end
