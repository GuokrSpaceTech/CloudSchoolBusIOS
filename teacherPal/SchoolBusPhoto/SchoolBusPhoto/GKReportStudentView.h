//
//  GKReportStudentView.h
//  SchoolBusPhoto
//
//  Created by wen peifang on 14-8-1.
//  Copyright (c) 2014年 mactop. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GKStudentView.h"
@protocol ReportStudentViewdelegate;
@interface GKReportStudentView : UIView<studentViewDelegate>
{
    GKStudentView* studentView;
}
@property (nonatomic,retain)NSMutableArray *stuArr;
@property (nonatomic,retain)NSString *studentName;
@property (nonatomic,assign)id<ReportStudentViewdelegate>delegate;
-(void)animationstart;

-(void)setStudentViewSelect:(NSArray *)uidArr;
@end



@protocol ReportStudentViewdelegate <NSObject>


-(void)studentView:(GKReportStudentView *)_stuView studentIdList:(NSMutableArray*)stuIdList studentName:(NSString *)oneName;

-(void)studentViewHidden:(GKReportStudentView *)_stuView;

@end