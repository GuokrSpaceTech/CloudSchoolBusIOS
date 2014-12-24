//
//  ETPhotoCell.h
//  SchoolBusParents
//
//  Created by wen peifang on 13-7-31.
//  Copyright (c) 2013年 wen peifang. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol photoCellDelegate;
/**
 *	自定义相册 的cell  显示 照片，一行4张
 */
@interface ETPhotoCell : UITableViewCell

{
    UIImageView *imageView1;
    UIImageView *imageView2;
    UIImageView *imageView3;
    UIImageView *imageView4;
    
    
    BOOL isSelect1;
    BOOL isSelect2;
    BOOL isSelect3;
    BOOL isSelect4;
    
    UIImageView *imageView11;
    UIImageView *imageView21;
    UIImageView *imageView31;
    UIImageView *imageView41;
    
}
/**
 *	代理方法
 */
@property (nonatomic,assign)id<photoCellDelegate>delegate;

/**
 *	第一张图片
 */
@property (nonatomic,retain)UIImageView *imageView1;

/**
 *	第二张图片
 */
@property (nonatomic,retain)UIImageView *imageView2;

/**
 *	第三张图片
 */
@property (nonatomic,retain)UIImageView *imageView3;
/**

 *	第四张图片

 */


@property (nonatomic,retain)UIImageView *imageView4;


/**
 *	第一张选中状态
 */
@property (nonatomic,assign)  BOOL isSelect1;

/**
 *	第二张选中状态
 */
@property  (nonatomic,assign) BOOL isSelect2;

/**
 *	第三张选中状态
 */
@property  (nonatomic,assign)BOOL isSelect3;

/**
 *	第四张选中状态
 */
@property  (nonatomic,assign)BOOL isSelect4;

@end


/**
 *	相册cell 的代理方法
 */
@protocol photoCellDelegate <NSObject>


/**
 *	点击的图片是否选中
 *
 *	@param 	tag 	图片tag
 *	@param 	an 	选中状态
 */
-(void)selectPhoto:(NSInteger)tag select:(BOOL)an;

@end