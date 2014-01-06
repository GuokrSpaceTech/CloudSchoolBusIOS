
#import <UIKit/UIKit.h>
#import "ETKids.h"
#import "UIActivityImageView.h"

@interface ETFoodDetailView : UIView
{
    UILabel * food1;
    UILabel * food2;
    UILabel * food3;
    UILabel * fWeight1;
    UILabel * fWeight2;
    UILabel * fWeight3;
    UIActivityImageView * foodImage;
}

@property(nonatomic,retain) UILabel * food1;
@property(nonatomic,retain) UILabel * food2;
@property(nonatomic,retain) UILabel * food3;
@property(nonatomic,retain) UILabel * fWeight1;
@property(nonatomic,retain) UILabel * fWeight2;
@property(nonatomic,retain) UILabel * fWeight3;
@property(nonatomic,retain) UIActivityImageView * foodImage;

@end
