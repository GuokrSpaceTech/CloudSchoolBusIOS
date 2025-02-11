//
//  VRGCalendarView.h
//  Vurig
//
//  Created by in 't Veen Tjeerd on 5/8/12.
//  Copyright (c) 2012 Vurig Media. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "UIColor+expanded.h"
#import "ETKids.h"
#define kVRGCalendarViewTopBarHeight 46
#define kVRGCalendarViewWidth 320

#define kVRGCalendarViewDayWidth  40
#define kVRGCalendarViewDayHeight 40




@protocol VRGCalendarViewDelegate;
@interface VRGCalendarView : UIView {
    id <VRGCalendarViewDelegate> delegate;
   
    NSDate *currentMonth;
    
    UILabel *labelCurrentMonth;
   
    BOOL isAnimating;
    BOOL prepAnimationPreviousMonth;
    BOOL prepAnimationNextMonth;
    
    UIImageView *animationView_A;
    UIImageView *animationView_B;
    
    NSArray *markedDates;
    NSArray *markedColors;
    
    
    
}

@property (nonatomic, retain) id <VRGCalendarViewDelegate> delegate;
@property (nonatomic, retain) NSDate *currentMonth;
@property (nonatomic, retain) UILabel *labelCurrentMonth;
@property (nonatomic, retain) UIImageView *animationView_A;
@property (nonatomic, retain) UIImageView *animationView_B;
@property (nonatomic, retain) NSArray *markedDates;
@property (nonatomic, retain) NSArray *markedqueqinDates;
@property (nonatomic, retain) NSArray *markedColors;
@property (nonatomic, getter = calendarHeight) float calendarHeight;
@property (nonatomic, retain, getter = selectedDate) NSDate *selectedDate;
@property (nonatomic, retain) NSArray *markedSchoolDates;
@property (nonatomic, retain) NSArray *markedSummerDates;
@property (nonatomic, retain) NSArray *markedBudengDates;

-(void)selectDate:(NSInteger)date;
-(void)reset;
-(void)markqueqinDates:(NSArray *)dates ;
- (void)markedBuDengDates:(NSArray *)dates;
-(void)markDates:(NSArray *)dates;
-(void)markDates:(NSArray *)dates withColors:(NSArray *)colors;

- (void)markSchoolDates:(NSArray *)dates;

-(void)showNextMonth;
-(void)showPreviousMonth;

-(int)numRows;
-(void)updateSize;
-(UIImage *)drawCurrentState;

@end

@protocol VRGCalendarViewDelegate <NSObject>
@optional
-(void)calendarView:(VRGCalendarView *)calendarView switchedToYear:(NSInteger)year switchedToMonth:(NSInteger)month targetHeight:(float)targetHeight animated:(BOOL)animated;
-(void)calendarView:(VRGCalendarView *)calendarView dateSelected:(NSDate *)date;
@end
