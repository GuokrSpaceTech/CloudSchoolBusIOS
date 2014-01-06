
#import "ControllerTopView.h"
#import "UserLogin.h"
#import "keyedArchiver.h"
#import "UIImageView+WebCache.h"
#import "ETKids.h"
#import "Modify.h"
@implementation ControllerTopView
@synthesize nameLabel,englishNameLabel,ageLabel,classLabel,photoImageView;
@synthesize schoolLabel,topImageView;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(photo:) name:@"UPDATEPHOTO" object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateChildInfo:) name:@"CHILDINFO" object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateChild:) name:@"refresh" object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(CHANGE:) name:@"CHANGEiMAGE"  object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(backgroundImage:) name:@"background" object:nil];

        UserLogin *user=(UserLogin *)[keyedArchiver getArchiver:@"LOGIN" forKey:@"LOGIN"];
        topImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0,320,145)];
        NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
        NSData * headerimage = [userDefault objectForKey:@"HEADERBACKGROUND"];
        if(headerimage != nil)
        {
            UIImage * headerImg = [UIImage imageWithData:headerimage];
            topImageView.image=headerImg;
        }
        else
        {
            topImageView.image=[UIImage imageNamed:@"006.png"];
            
        }

        [self addSubview:topImageView];
        [topImageView release];
        
        UIImageView  *kuang=[[UIImageView alloc]initWithFrame:CGRectMake(24, 66, 68, 68)];
        kuang.image=[UIImage imageNamed:@"kuang.png"];
        [self addSubview:kuang];
        [kuang release];
        
        photoImageView=[[UIImageView alloc]initWithFrame:CGRectMake(25, 67, 66, 66)];
        photoImageView.backgroundColor=[UIColor clearColor];
        photoImageView.userInteractionEnabled = YES;
       // NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
        NSData * headerData = [userDefault objectForKey:@"HEADERPHOTO"];
        if(headerData != nil)
        {
            UIImage * headerImg = [UIImage imageWithData:headerData];
            [photoImageView setImage:headerImg];
        }
        else
        {
            
            UserLogin * user = [keyedArchiver getArchiver:@"LOGIN" forKey:@"LOGIN"];
            if(user.avatar != nil)
            {
                [photoImageView setImageWithURL:[NSURL URLWithString:user.avatar] placeholderImage:nil];
            }
        }
        [self addSubview:photoImageView];
        
        nameLabel=[[UILabel alloc]init];
        NSString *thetext=user.nickname;
        CGSize theStringSize = [thetext sizeWithFont:[UIFont systemFontOfSize:14]
                                   constrainedToSize:CGSizeMake(MAXFLOAT, 20)];         
        nameLabel.frame = CGRectMake(110,64,theStringSize.width+10, 20);
        nameLabel.text=thetext;
        nameLabel.textColor=[UIColor whiteColor];
        nameLabel.font=[UIFont systemFontOfSize:14];
        nameLabel.backgroundColor=[UIColor clearColor];
        [self addSubview:nameLabel];
        
        ageLabel=[[UILabel alloc]initWithFrame:CGRectMake(110+theStringSize.width+20, 64,30, 20)];
        ageLabel.text = [NSString stringWithFormat:@"%@ %@",user.age,LOCAL(@"ageformat", @"")];
        ageLabel.font=[UIFont systemFontOfSize:14];
        ageLabel.textColor=[UIColor whiteColor];
        ageLabel.backgroundColor=[UIColor clearColor];
        [self addSubview:ageLabel];
        
        schoolLabel=[[UILabel alloc]initWithFrame:CGRectMake(110, 80, 200, 40)];
        schoolLabel.backgroundColor=[UIColor clearColor];
        schoolLabel.font=[UIFont systemFontOfSize:14];
        schoolLabel.textColor=[UIColor whiteColor];
        schoolLabel.lineBreakMode=NSLineBreakByCharWrapping;
         [schoolLabel setNumberOfLines:0];
        schoolLabel.textAlignment=UITextAlignmentLeft;
        //schoolLabel.text = [NSString stringWithFormat:@"%@",user.schoolname];
        schoolLabel.text=ModifyData.Schoolname;
        [self addSubview:schoolLabel];
        
        classLabel=[[UILabel alloc]initWithFrame:CGRectMake(110, 120, 200, 20)];
        classLabel.text=user.className;
        classLabel.font=[UIFont systemFontOfSize:14];
        classLabel.textColor=[UIColor whiteColor];
        classLabel.backgroundColor=[UIColor clearColor];
        classLabel.textAlignment=UITextAlignmentRight;
        [self addSubview:classLabel];
        
    }
    
    return self;
}


/// 接收更新学生昵称消息.
-(void)updateChildInfo:(NSNotification *) notification
{
    UserLogin * user = [keyedArchiver getArchiver:@"LOGIN" forKey:@"LOGIN"];
    nameLabel.text = user.nickname;
     
    NSString *thetext=user.nickname;
    CGSize theStringSize = [thetext sizeWithFont:[UIFont systemFontOfSize:14]
                               constrainedToSize:CGSizeMake(MAXFLOAT, 20)];
    nameLabel.frame = CGRectMake(110,64,theStringSize.width+10, 20);
    nameLabel.text=thetext;
    ageLabel.frame=CGRectMake(110+theStringSize.width+20, 64,30, 20);
    
}

/// 接收更新学生年龄消息.
-(void)updateChild:(NSNotification*)notification
{
    UserLogin * user = [keyedArchiver getArchiver:@"LOGIN" forKey:@"LOGIN"];
    ageLabel.text = [NSString stringWithFormat:@"%@ %@",user.age,LOCAL(@"ageformat", @"")];
   
}

/// 接收更新学生头像消息.
-(void)photo:(NSNotification *)no
{
    NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
    NSData * headerData = [userDefault objectForKey:@"HEADERPHOTO"];
    if(headerData != nil)
    {
        UIImage * headerImg = [UIImage imageWithData:headerData];
        [photoImageView setImage:headerImg];
    }
}

/// 接收更换背景消息.
-(void)CHANGE:(NSNotification*)no
{
    NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
    NSData * headerimage = [userDefault objectForKey:@"HEADERBACKGROUND"];
    if(headerimage != nil)
    {
        UIImage * headerImg = [UIImage imageWithData:headerimage];
        topImageView.image=headerImg;
    }
    
}
-(void)backgroundImage:(NSNotification*)notification
{
    NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
    NSData * headerimage = [userDefault objectForKey:@"HEADERBACKGROUND"];
    if(headerimage != nil)
    {
        UIImage * headerImg = [UIImage imageWithData:headerimage];
        topImageView.image=headerImg;
    }
    
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"UPDATAPHOTO" object:nil];
    
    self.nameLabel=nil;
    self.englishNameLabel=nil;
    self.ageLabel=nil;
    self.classLabel=nil;
    self.photoImageView=nil;
    self.schoolLabel=nil;
    [super dealloc];
}


@end
