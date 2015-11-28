//
//  FindNoticeTableViewCell.m
//  CloudBusParent
//
//  Created by HELLO  on 15/11/11.
//  Copyright (c) 2015年 BeiJingYinChuang. All rights reserved.
//

#import "FindNoticeTableViewCell.h"
#import "Masonry.h"
#import "Calculate.h"
#import "UIImageView+WebCache.h"
#import "UIColor+RCColor.h"
#import "AriticleView.h"
#import "NoticeView.h"
#import "URLLinkView.h"

#define PICWIDTH 75
#define PADDING 10
#define TOPVIEW_HEIGHT 80

@interface FindNoticeTableViewCell()
{
    double contentViewHeight;
}
@end


@implementation FindNoticeTableViewCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        _topView = [[FindCellTopView alloc] init];
        _topView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:_topView];
        [_topView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left);
            make.right.equalTo(self.contentView.mas_right);
            make.top.equalTo(self.contentView.mas_top);
            make.height.mas_equalTo(@(80));
        }];
        
    }
    return self;
}
-(void)setMesssage:(Message *)messsage
{
    _messsage = messsage;
    
    for (UIView * view in self.contentView.subviews) {
        if(![view isKindOfClass:[FindCellTopView class]])
        {
            [view removeConstraints:view.constraints];
            [view removeFromSuperview];
        }
    }
    
    //TopView
        
        [_topView.avatarImageView sd_setImageWithURL:[NSURL URLWithString:_messsage.sender.avatar] placeholderImage:nil];
        _topView.nameLabel.text = _messsage.sender.name;
        _topView.classNamelabel.text = _messsage.sender.classname;
        _topView.timeLabel.text = [Calculate dateFromTimeStamp:[_messsage.sendtime intValue]];
        
        if([messsage.apptype isEqualToString:@"Article"])
        {
            _topView.typeLabel.text = @"照片";
            NSDictionary * dic = [messsage bodyObject];
            NSArray * picArr = dic[@"PList"];
            if(![picArr isKindOfClass:[NSArray class]])
            {
                return;
            }
            _articleView = [[AriticleView alloc] init];
            [_articleView setMessage:messsage];
            [self.contentView addSubview:_articleView];
            
            [_articleView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(_topView.mas_bottom).offset(20);
                make.left.equalTo(self.contentView.mas_left).offset(30);
                make.height.equalTo([_articleView height]);
//                make.width.equalTo([_articleView width]);
                make.right.equalTo(self.contentView.mas_right).offset(-10);
                make.bottom.equalTo(self.contentView.mas_bottom).offset(-10);
            }];
        }
        else if([messsage.apptype isEqualToString:@"Notice"]) {
            _topView.typeLabel.text = @"通知";
            
            NSArray *bundle = [[NSBundle mainBundle] loadNibNamed:@"NoticeView" owner:self options:nil];
            
            NoticeView *noticeView = [bundle objectAtIndex:0];
            
            [self.contentView addSubview:noticeView];
            
            [noticeView setMessage:messsage];

            [noticeView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(_topView.mas_bottom).offset(10);
                make.left.equalTo(self.contentView.mas_left).offset(40);
                make.right.equalTo(self.contentView.mas_right).offset(-10);;
                make.height.mas_equalTo(noticeView.height);
                make.bottom.equalTo(self.contentView.mas_bottom).offset(-10);
                //            [noticeView  setContentCompressionResistancePriority: UILayoutPriorityDefaultHigh forAxis: UILayoutConstraintAxisVertical];
            }];
            
            contentViewHeight = [noticeView.height doubleValue];
            
        }
        else if ([messsage.apptype isEqualToString:@"Report"]
               ||[messsage.apptype isEqualToString:@"Course"]
               ||[messsage.apptype isEqualToString:@"Food"]) {
            _topView.typeLabel.text = @"报告";
            NSArray *bundle = [[NSBundle mainBundle] loadNibNamed:@"URLLinkView"
                                                        owner:self options:nil];
            _linkView = [bundle objectAtIndex:0];
            
            [_linkView setMessage:messsage];
            [self.contentView addSubview:_linkView];
            
            [_linkView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(_topView.mas_bottom).offset(10);
                make.left.equalTo(self.contentView.mas_left).offset(40);
                make.right.equalTo(self.contentView.mas_right).offset(-10);;
                make.height.mas_equalTo(@90);
                make.bottom.equalTo(self.contentView.mas_bottom).offset(-10);
            }];
        }
        else if ([messsage.apptype isEqualToString:@"Punch"])
        {
            _topView.typeLabel.text = @"考勤";
            NSArray *bundle = [[NSBundle mainBundle] loadNibNamed:@"AttendanceView"
                                                            owner:self options:nil];
            _attendanceView = [bundle objectAtIndex:0];

            [self.contentView addSubview:_attendanceView];

            [_attendanceView setMessage:messsage];
            
            [_attendanceView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(_topView.mas_bottom).offset(10);
                make.left.equalTo(self.contentView.mas_left).offset(40);
                make.right.equalTo(self.contentView.mas_right).offset(-10);;
                make.height.mas_equalTo(_attendanceView.height);
                make.bottom.equalTo(self.contentView.mas_bottom).offset(-10);
            }];
        }
    
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
@end
