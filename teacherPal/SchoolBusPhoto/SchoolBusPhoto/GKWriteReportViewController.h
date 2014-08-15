//
//  GKWriteReportViewController.h
//  SchoolBusPhoto
//
//  Created by wen peifang on 14-7-30.
//  Copyright (c) 2014年 mactop. All rights reserved.
//

#import "GKBaseViewController.h"
#import "GKReportModel.h"
#import "MTCustomActionSheet.h"
#import "GKQuestionView.h"
#import "GKReportStudentView.h"
#import "EKRequest.h"
#import "MBProgressHUD.h"
@interface GKWriteReportViewController : GKBaseViewController<QuestionViewDelegate,MTCustomActionSheetDelegate,ReportStudentViewdelegate,EKProtocol>
{
    UIScrollView *scroller;
    UIButton *dateButton;
    UIButton *stuButton;
    MBProgressHUD *HUD;
}
@property (nonatomic,retain)NSMutableArray *stuidArr;
@property (nonatomic,retain)NSString *dateStr;
@property (nonatomic,retain)NSString *studentselectStr;
@property (nonatomic,retain)GKReportModel *model;
@property (nonatomic,retain)NSMutableArray *jsonArr;
//
//@property (nonatomic,retain)NSString *titleStr;

@end
