
#import "ETFoodDetailView.h"

@implementation ETFoodDetailView

@synthesize food1,food2,food3,fWeight1,fWeight2,fWeight3,foodImage;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        CGFloat foodImgHeight = 0;
        CGFloat food1OriginY = 0;
        CGFloat food2OriginY = 0;
        CGFloat food3OriginY = 0;
        
        if(iphone5)
        {
            foodImgHeight = 95;
            food1OriginY = 10;
            food2OriginY = 36;
            food3OriginY = 62;
        }
        else
        {
            foodImgHeight = 78;
            food1OriginY = 5;
            food2OriginY = 20;//27
            food3OriginY = 50;
        }
        UILabel * f1 = [[UILabel alloc] initWithFrame:CGRectMake(5, food1OriginY, 120, 21)];
        f1.backgroundColor = [UIColor clearColor];
        f1.font = [UIFont systemFontOfSize:14];
        //f1.text = @"草莓布丁:";
        self.food1 = f1;
        [self addSubview:f1];
        [f1 release];
        
        UILabel * f2 = [[UILabel alloc] initWithFrame:CGRectMake(5, food2OriginY, 116, 42)];
        f2.backgroundColor = [UIColor clearColor];
        f2.font = [UIFont systemFontOfSize:14];
        f2.numberOfLines = 2;
        f2.lineBreakMode = NSLineBreakByWordWrapping;
        //f2.text = @"草莓布丁:";
        self.food2 = f2;
        [self addSubview:f2];
        [f2 release];
        
        UILabel * f3 = [[UILabel alloc] initWithFrame:CGRectMake(5, food3OriginY, 120, 21)];
        f3.backgroundColor = [UIColor clearColor];
        f3.font = [UIFont systemFontOfSize:14];
        //f3.text = @"草莓布丁:";
        self.food3 = f3;
        [self addSubview:f3];
        [f3 release];
        
        UILabel * fw1 = [[UILabel alloc] initWithFrame:CGRectMake(68, food1OriginY, 50, 21)];
        fw1.backgroundColor = [UIColor clearColor];
        fw1.font = [UIFont systemFontOfSize:14];
        //fw1.text = @"50克";
        self.fWeight1 = fw1;
        [self addSubview:fw1];
        [fw1 release];
        
        UILabel * fw2 = [[UILabel alloc] initWithFrame:CGRectMake(68, food2OriginY, 50, 21)];
        fw2.backgroundColor = [UIColor clearColor];
        fw2.font = [UIFont systemFontOfSize:14];
        //fw2.text = @"50克";
        self.fWeight2 = fw2;
        [self addSubview:fw2];
        [fw2 release];
        
        UILabel * fw3 = [[UILabel alloc] initWithFrame:CGRectMake(68, food3OriginY, 50, 21)];
        fw3.backgroundColor = [UIColor clearColor];
        fw3.font = [UIFont systemFontOfSize:14];
        //fw3.text = @"50克";
        self.fWeight3 = fw3;
        [self addSubview:fw3];
        [fw3 release];
        
        UIActivityImageView * imgView = [[UIActivityImageView alloc] initWithFrame:CGRectMake(120, 0, 120, foodImgHeight)];
        imgView.userInteractionEnabled = YES;
        imgView.backgroundColor = [UIColor lightGrayColor];
        self.foodImage = imgView;
        [self addSubview:imgView];
        [imgView release];
        
        //self.backgroundColor = [UIColor blueColor];
    }
    return self;
}
-(void) dealloc
{
    self.food1 = nil;
    self.food2 = nil;
    self.food3 = nil;
    self.fWeight1 = nil;
    self.fWeight2 = nil;
    self.fWeight3 = nil;
    self.foodImage = nil;
    
    [super dealloc];
}
@end
