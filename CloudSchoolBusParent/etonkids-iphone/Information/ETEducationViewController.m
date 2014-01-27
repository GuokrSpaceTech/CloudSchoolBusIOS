//
//  ETEducationViewController.m
//  etonkids-iphone
//
//  Created by CaiJingPeng on 13-9-25.
//  Copyright (c) 2013年 wpf. All rights reserved.
//

#import "ETEducationViewController.h"
#import "UserLogin.h"
#import "UIImageView+WebCache.h"


@interface ETEducationViewController ()

@end

@implementation ETEducationViewController
@synthesize blockArr;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    [self._slimeView removeFromSuperview];
    
    self.blockArr = [NSMutableArray array];
    
    NSArray *arr = [NSArray arrayWithObjects:@"myCollect.png",@"myCollect.png",@"myCollect.png",@"myCollect.png",@"order.png", nil];
    for (int i = 0; i < arr.count; i++) {
        OrderBlock *ob = [[OrderBlock alloc] initWithFrame:CGRectMake(0, 0, ORDER_BLOCK_WIDTH, ORDER_BLOCK_HEIGHT)
                                                  AndImage:[UIImage imageNamed:[arr objectAtIndex:i]]];
        
        [self.blockArr addObject:ob];
    }
    
    
    [self loadData];
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doTap:)];
    [self.view addGestureRecognizer:tap];
    [tap release];
    
    
//    self._tableView.frame = CGRectMake(0, 0, 320, self.view.frame.size.height -57 - 46 - (ios7 ? 20 : 0));
//    NSLog(@"%f",self.view.frame.size.height);
    // Do any additional setup after loading the view from its nib.
}

- (void)doTap:(UITapGestureRecognizer *)sender
{
    [self setAllBlockNormal];
}


- (void)loadData
{
    UserLogin *user = [UserLogin currentLogin];
    
    if(user.loginStatus == LOGIN_SERVER)
    {
        _topView.nameLabel.text = user.nickname;
        _topView.ageLabel.text = [NSString stringWithFormat:@"%@ %@", user.age, LOCAL(@"ageformat", @"")];
        _topView.classLabel.text = user.className;
        [_topView.photoImageView setImageWithURL:[NSURL URLWithString:user.avatar] placeholderImage:[UIImage imageNamed:@"headplaceholder_big.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
            _topView.photoImageView.image = image;
        }];
        
        
        
    }
    else
    {
        // 如果没有登录并没出现登录页面  说明含有自动登录，当出现登录页面时，但是此页面依然存在，所以没有自动登录的值.
        
        
        NSUserDefaults *defaultUser=[NSUserDefaults standardUserDefaults];
        
        if ([defaultUser objectForKey:AUTOLOGIN])
        {
            // 如果是自动登录  首先加载本地缓存（学生信息，数据等等）.
            _topView.nameLabel.text = user.nickname;
            _topView.ageLabel.text = [NSString stringWithFormat:@"%@ %@", user.age, LOCAL(@"ageformat", @"")];
            _topView.classLabel.text = user.className;
            [_topView.photoImageView setImageWithURL:[NSURL URLWithString:user.avatar] placeholderImage:[UIImage imageNamed:@"headplaceholder_big.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                _topView.photoImageView.image = image;
            }];
            
//            NSArray *arr = [ETCoreDataManager searchAllNotices];
            
//            if (arr == nil || arr.count == 0) {
//                
//            }
//            else
//            {
//                [self setNoticeData:arr];
//            }
            
            
            //NSLog(@"111");
            
        }
        else
        {
            // 应不做处理 当登录成功是再做处理.
        }
        
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"classCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    cell.contentView.backgroundColor = CELLCOLOR;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    for (int i = 0; i < self.blockArr.count; i++) {
        
        OrderBlock *ob = (OrderBlock *)[self.blockArr objectAtIndex:i];
        ob.frame = CGRectMake((LEFT_MARGIN + i%2 * (ORDER_BLOCK_WIDTH + LEFT_MARGIN + 1)),
                              LEFT_MARGIN + i%6/2 * (ORDER_BLOCK_HEIGHT + LEFT_MARGIN),
                              ORDER_BLOCK_WIDTH,
                              ORDER_BLOCK_HEIGHT);
        ob.delegate = self;
        
        if (i == 0) {
            ob.obType = MyCollection;
        }else if (i == self.blockArr.count - 1){
            ob.obType = AddOrder;
        }else{
            ob.obType = NormalOrder;
        }
        
        [cell addSubview:ob];
        [ob release];
        
        
        
    }
    
    return cell;
    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"enddddddddddddddddd");
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return LEFT_MARGIN + (ORDER_BLOCK_HEIGHT + LEFT_MARGIN)*((blockArr.count-1)/2 + 1);
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)didLongPressBlock:(OrderBlock *)block
{
    NSLog(@"order block  long press");
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CLOSEGESTURE" object:nil];
    
    for (int i = 1; i<self.blockArr.count - 1; i++) {
        OrderBlock *ob = (OrderBlock *)[self.blockArr objectAtIndex:i];
        [ob setDeleteStatus];
    }
    
}
- (void)didTapPressBlock:(OrderBlock *)block
{
    
    if (block.obType == AddOrder) {
        // 推入 订阅列表 页面
    }
    
    NSLog(@"order block  tap");
}
- (void)didClickDeleteButton:(OrderBlock *)block
{
    NSLog(@"order block  click delete");
    
    if (block.obType == NormalOrder) {
        // 删除 订阅.
    }
    
}
- (void)moveBlock:(OrderBlock *)block Position:(CGPoint)pos touchPos:(CGPoint)tPos
{
    _tableView.scrollEnabled = NO;
    [_tableView bringSubviewToFront:block];
    
    int originIndex = [self.blockArr indexOfObject:block];
    
    for (int i = 0; i < self.blockArr.count - 1; i++) {
        CGPoint targetPos = CGPointMake((LEFT_MARGIN + i%2 * (ORDER_BLOCK_WIDTH + LEFT_MARGIN + 1) + block.frame.size.width/2),
                                       LEFT_MARGIN + i%6/2 * (ORDER_BLOCK_HEIGHT + LEFT_MARGIN) + block.frame.size.height/2);
        /*CGPointMake((25 + i%2 * (120 + 30)) + i/6 * 320 + block.frame.size.width/2,
                                        25 + i%6/2 * (120 + 25) + block.frame.size.height/2);*/
        
        //        NSLog(@"target : %f,%f   origin : %f,%f", targetPos.x,targetPos.y,pos.x,pos.y);
        
        if (i != 0 && i!= self.blockArr.count-1 && i != originIndex && [self isNearPosition:pos otherPosition:targetPos]) {
            
            for (int j = originIndex;
                 i > originIndex ? j < i : j > i ;
                 i > originIndex ? j++ : j--) {
                
                int index = i > originIndex ? j + 1 : j - 1;
                
                OrderBlock *moveBlock = [self.blockArr objectAtIndex:index];
                
                [UIView animateWithDuration:0.5f delay:0.1*j options:0 animations:^{
                    
                    moveBlock.frame = CGRectMake((LEFT_MARGIN + j%2 * (ORDER_BLOCK_WIDTH + LEFT_MARGIN + 1)),
                                                 LEFT_MARGIN + j%6/2 * (ORDER_BLOCK_HEIGHT + LEFT_MARGIN),
                                                 ORDER_BLOCK_WIDTH,
                                                 ORDER_BLOCK_HEIGHT);
                    
                    
                    
                } completion:^(BOOL finished) {
                    
                }];
                
                [self.blockArr exchangeObjectAtIndex:j withObjectAtIndex:index];
                
            }
            
            
        }
        
    }
}
- (void)endMoveBlock:(OrderBlock *)block
{
    _tableView.scrollEnabled = YES;
    
    int index = [self.blockArr indexOfObject:block];
    
    [UIView animateWithDuration:0.5f animations:^{
        block.frame = CGRectMake((LEFT_MARGIN + index%2 * (ORDER_BLOCK_WIDTH + LEFT_MARGIN + 1)),
                                 LEFT_MARGIN + index%6/2 * (ORDER_BLOCK_HEIGHT + LEFT_MARGIN),
                                 ORDER_BLOCK_WIDTH,
                                 ORDER_BLOCK_HEIGHT);
    }];
}

- (BOOL)isNearPosition:(CGPoint)pos1 otherPosition:(CGPoint)pos2
{
    if (ABS(pos1.x - pos2.x) < 50 && ABS(pos1.y - pos2.y) < 50) {
        return YES;
    }
    return NO;
}

- (void)setAllBlockNormal
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"OPENGESTURE" object:nil];
    for (OrderBlock *ob in self.blockArr) {
        [ob resetNormalStatus];
    }
}

//- (void)addOrder:(OrderBlock *)ob
//{
//    
//    [self setAllBlockNormal];
//    
//    
//    int pos = self.blockArr.count - 1;
//    
//    OrderBlock *b = [[OrderBlock alloc] initWithFrame:CGRectMake((25 + pos%2 * (120 + 30)) + pos/6 * 320,
//                                                                 25 + pos%6/2 * (120 + 25),
//                                                                 120,
//                                                                 120)];
//    b.alpha = 0.0f;
//    b.backgroundColor = [UIColor redColor];
//    b.delegate = self;
//    [mainSV addSubview:b];
//    [b release];
//    
//    [UIView animateWithDuration:1.0f animations:^{
//        b.alpha = 1.0f;
//    }];
//    
//    
//    [blocks insertObject:b atIndex:pos];
//    
//    pos = blocks.count - 1;
//    
//    [UIView animateWithDuration:0.5f animations:^{
//        
//        sender.frame = CGRectMake((25 + pos%2 * (120 + 30)) + pos/6 * 320,
//                                  25 + pos%6/2 * (120 + 25),
//                                  120,
//                                  120);
//        
//        mainSV.contentSize = CGSizeMake(320 * (pos/6 + 1), 460);
//        
//    } completion:^(BOOL finished) {
//        
//    }];
//    
//    //    NSLog(@"%@",self.blocks);
//    
//}






- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
