//
//  GKShowViewController.h
//  SchoolBusPhoto
//
//  Created by wen peifang on 13-10-23.
//  Copyright (c) 2013年 mactop. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GKStudentView.h"
#import "GKBaseViewController.h"
#import "EKRequest.h"
#import "ETNicknameViewController.h"
#import "GKDisapperView.h"
@protocol showViewController;
@interface GKShowViewController : GKBaseViewController<UIScrollViewDelegate,studentViewDelegate,UINavigationControllerDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,EKProtocol,ETNicknameViewControllerDelegate,UITextViewDelegate,UIAlertViewDelegate>
{
    UIScrollView *_scroller;
    
    NSMutableArray *assetArr;
    UIView *_imageView;
    
    
    UILabel *numbeLabel;
    
    GKStudentView *studentView;

    int  currentpage;
    
    int prePage;
    
    
    int type;
    
    UIView *changeView;
    UITextView *picTxtView;
    UIImageView *numView;
    UIButton *photobutton;
    
    GKDisapperView *disappearView;
    UIView *textView;
    
    
    
    
   // NSMutableArray *alreadyArr;
    
  //  NSDictionary * stuList;
}
@property int type;
@property (nonatomic,assign)id<showViewController>delegate;
@property (nonatomic,copy)NSMutableArray *assetArr;
//@property (nonatomic,retain)NSMutableArray *alreadyArr;
@property (nonatomic,retain)NSMutableArray * stuList;
@property (nonatomic, retain)NSMutableArray *picTextArr;

@property (nonatomic,retain)Student * tempStu; // 修改头像时 的 临时变量
@end

@protocol showViewController <NSObject>

-(void)refreashPickViewController:(NSArray *)arr;



@end