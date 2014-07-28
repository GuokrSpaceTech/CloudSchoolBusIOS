//
//  GKSaySomethingView.m
//  SchoolBusPhoto
//
//  Created by wen peifang on 14-1-22.
//  Copyright (c) 2014年 mactop. All rights reserved.
//

#import "GKSaySomethingView.h"
#import "GKUserLogin.h"
@implementation GKSaySomethingView
@synthesize delegate;
//@synthesize tagStr;
@synthesize tagidArr;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
       // self.backgroundColor=[UIColor re];
        
//        UIView *inputView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
//        inputView.backgroundColor = [UIColor clearColor];
//        UIButton *inputBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [inputBtn setTitle:@"图" forState:UIControlStateNormal];
//        [inputBtn setBackgroundImage:[UIImage imageNamed:@"applyAll.png"] forState:UIControlStateNormal];
//        [inputBtn setFrame:CGRectMake(320 - 50, 0, 50, 40)];
//        [inputBtn addTarget:self action:@selector(endEdit:) forControlEvents:UIControlEventTouchUpInside];
//        [inputView addSubview:inputBtn];
        
//        
//        UIImageView *ImageView=[[UIImageView alloc]initWithFrame:CGRectMake(10, 10, self.frame.size.width-20, 150)];
//        UIImage *image=[[UIImage imageNamed:@"corners.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 20, 20, 20)];
//        ImageView.image=image;
//        [self addSubview:ImageView];
//        [ImageView release];
        

        _contextView=[[UITextView alloc]initWithFrame:CGRectMake(10, 10, self.frame.size.width-20, 150)];
        _contextView.backgroundColor = [UIColor whiteColor];
        //_contextView.backgroundColor = [UIColor colorWithRed:240/255.0f green:238/255.0f blue:227/255.0f alpha:1.0f];
        _contextView.text = @"";
        _contextView.font=[UIFont systemFontOfSize:16];
        //_contextView.layer.cornerRadius=5;
        _contextView.delegate = self;
        _contextView.returnKeyType = UIReturnKeyDone;
//        _contextView.inputAccessoryView = inputView;
//        [inputView release];
        
        [self addSubview:_contextView];
        
        //增加字数限制
        labelNum=[[UILabel alloc]initWithFrame:CGRectMake(10, _contextView.frame.size.height+_contextView.frame.origin.y+5, 50, 20)];
        labelNum.backgroundColor=[UIColor clearColor];
        labelNum.text=@"0/280";
        labelNum.font=[UIFont systemFontOfSize:12];
        [self addSubview:labelNum];
        [labelNum release];
        
        
      
        
        
        UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
        
        //apply
        [button setTitle:NSLocalizedString(@"apply", @"") forState:UIControlStateNormal];
        button.frame=CGRectMake(224, _contextView.frame.origin.y+_contextView.frame.size.height+5, 80, 40);
        
//        UIImage *iamge=[[UIImage imageNamed:@"loginBtn"] resizableImageWithCapInsets:UIEdgeInsetsMake(15, 20, 15, 20)];
        button.tag = 333;
        [button setBackgroundImage:[[UIImage imageNamed:@"navbar-button-blue"] stretchableImageWithLeftCapWidth:3 topCapHeight:15] forState:UIControlStateNormal];
        [button setBackgroundImage:[[UIImage imageNamed:@"navbar-button-blue-active"] stretchableImageWithLeftCapWidth:3 topCapHeight:15] forState:UIControlStateHighlighted];
        [button setBackgroundImage:[[UIImage imageNamed:@"navbar-button-blue-active"] stretchableImageWithLeftCapWidth:3 topCapHeight:15] forState:UIControlStateSelected];
        button.titleLabel.font=[UIFont systemFontOfSize:16];
        [button addTarget:self action:@selector(applyAll:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];

        
        _tagScrollerView = [[GKPhotoTagScrollView alloc] initWithFrame:CGRectMake(5,  _contextView.frame.origin.y+_contextView.frame.size.height+5+40, 310, frame.size.height-labelNum.frame.origin.y-labelNum.frame.size.height)];
        _tagScrollerView.backgroundColor = [UIColor clearColor];
        _tagScrollerView.tagDelegate = self;
        [self addSubview:_tagScrollerView];

        
        
        GKUserLogin *user=[GKUserLogin currentLogin];
        
         [_tagScrollerView setPhotoTags:user.photoTagArray];
        
//        NSString* strLanguage = [[[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"] objectAtIndex:0];
////        NSLog(@"%@",strLanguage);
//        if ([strLanguage isEqualToString:@"zh-Hans"])
//        {
//            if (nil != [user.photoTagArray objectAtIndex:0] && [[user.photoTagArray objectAtIndex:0] isKindOfClass:[NSArray class]])
//            {
//                [_tagScrollerView setPhotoTags:[user.photoTagArray objectAtIndex:0]];
//            }
//        }
//        else
//        {
//            if (nil != [user.photoTagArray objectAtIndex:1] && [[user.photoTagArray objectAtIndex:1] isKindOfClass:[NSArray class]])
//            {
//                [_tagScrollerView setPhotoTags:[user.photoTagArray objectAtIndex:1]];
//            }
//            
//        }
        
        
        
    }
    return self;
}

- (void)endEdit:(id)sender
{
    [self endEditing:YES];
}

-(void)applyAll:(UIButton *)btn
{
    if([_contextView.text isEqualToString:@""])
    {
        return;
    }
    
    if([self textLength:_contextView.text] > 280)
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"alert", @"") message:@"字数过长" delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        return;
    }
    
    

    
    
    [btn setBackgroundImage:[[UIImage imageNamed:@"navbar-button-blue-active"] stretchableImageWithLeftCapWidth:3 topCapHeight:15] forState:UIControlStateNormal];
        
    if (delegate && [delegate respondsToSelector:@selector(applyAll:)])
    {
        [delegate applyAll:_contextView.text];
    }
    
    

    
    
    

}
//-(void)setTagStr:(NSString *)_tagStr
//{
//    [tagStr release];
//    tagStr=[_tagStr retain];
//    
//    //[_tagScrollerView setSelectTag:_tagStr];
//}
-(void)setTagidArr:(NSMutableArray *)_tagidArr
{
    [tagidArr release];
    tagidArr=[_tagidArr retain];
    
    
    [_tagScrollerView setAlreadyTag:_tagidArr];
}


- (int)textLength:(NSString *)text//计算字符串长度
{
    float number = 0.0;
    for (int index = 0; index < [text length]; index++)
    {
        
        NSString *character = [text substringWithRange:NSMakeRange(index, 1)];
        
        //        NSLog(@"%d",[character lengthOfBytesUsingEncoding:NSUTF8StringEncoding]);
        
        if ([character lengthOfBytesUsingEncoding:NSUTF8StringEncoding] == 3)
        {
            number+=2;
        }
        else
        {
            number++;
        }
    }
    return number;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text; {
    
    if ([@"\n" isEqualToString:text] == YES) {
        [self endEditing:YES];
        return NO;
    }
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView
{
    
    UIButton *button = (UIButton *)[self viewWithTag:333];
    [button setBackgroundImage:[[UIImage imageNamed:@"navbar-button-blue"] stretchableImageWithLeftCapWidth:3 topCapHeight:15] forState:UIControlStateNormal];
    
    int a= [self textLength:_contextView.text];
    
    NSLog(@"%d",a);
    
    
    labelNum.text=[NSString stringWithFormat:@"%d/280",a];
    
    if(a>280)
    {
        
        labelNum.textColor=[UIColor redColor];;
        
    }
    else
    {
        labelNum.textColor=[UIColor blackColor];
        //self.preStr=picTxtView.text;
        
    }
}
-(void)textViewDidBeginEditing:(UITextView *)textView
{
    
    if(!textView.window.isKeyWindow)
    {
        [textView.window makeKeyAndVisible];
    }

}
- (void)didSelectPhotoTag:(int )tag tagstr:(NSString *)_tagstr
{
    UIButton *button = (UIButton *)[self viewWithTag:333];
    [button setBackgroundImage:[[UIImage imageNamed:@"navbar-button-blue"] stretchableImageWithLeftCapWidth:3 topCapHeight:15] forState:UIControlStateNormal];
    [delegate tag:_tagstr tagid:tag];
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self endEditing:YES];
}
-(void)dealloc
{
    self.contextView=nil;
    self.tagScrollerView=nil;
   // self.tagStr=nil;
    self.tagidArr=nil;
    [super dealloc];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
