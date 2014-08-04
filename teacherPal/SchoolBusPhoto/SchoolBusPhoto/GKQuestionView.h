//
//  GKQuestionView.h
//  SchoolBusPhoto
//
//  Created by wen peifang on 14-7-31.
//  Copyright (c) 2014年 ;. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GKReportQuestion.h"
@protocol QuestionViewDelegate;
@interface GKQuestionView : UIView<UITextFieldDelegate>
{
    //UIImageView *filedBgView;
}
@property (nonatomic,retain)GKReportQuestion *question;
@property (nonatomic,assign)int index;
@property (nonatomic,retain)UILabel *titleLabel;

@property (nonatomic,retain)UIButton *op1Button;
@property (nonatomic,retain)UIButton *op2Button;
@property (nonatomic,retain)UIButton *op3Button;
@property (nonatomic,retain)UITextField *contentField;
@property (nonatomic,assign)id<QuestionViewDelegate>delegate;
- (id)initWithFrame:(CGRect)frame index:(int)count;
@end


@protocol QuestionViewDelegate <NSObject>

-(void)questionView:(GKQuestionView *)_questView questionTitle:(NSString *)questiontitle answer:(NSString *)_answer;
-(void)questionKeyBoard;
-(void)questionFielddbeginEdit:(int)_index;
@end