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
#define PICWIDTH 75
#define PADDING 10
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

    //Food
    if([messsage.apptype isEqualToString:@"Food"])
    {
        _topView.typeLabel.text = @"食谱";
        UIButton * bottomBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        bottomBtn.backgroundColor = [UIColor grayColor];
        [bottomBtn setTitle:messsage.desc forState:UIControlStateNormal];
        bottomBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:bottomBtn];

        [bottomBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_topView.mas_bottom).offset(10);
            make.left.equalTo(self.contentView.mas_left).offset(40);
            make.right.equalTo(self.contentView.mas_right).offset(-10);;
            make.height.mas_equalTo(@(40));
            make.bottom.equalTo(self.contentView.mas_bottom).offset(-10);
        }];

    }
    else if([messsage.apptype isEqualToString:@"Report"])    {
        
        _topView.typeLabel.text = @"班级报告";
        //NSString * body = messsage.bo
        NSDictionary * dic = [messsage bodyObject];
        NSString * title = messsage.title;
        if([[dic allKeys] containsObject:@"reportType"])
        {
            title = dic[@"reportType"];
        }
        UIButton * bottomBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        bottomBtn.backgroundColor = [UIColor grayColor];
        bottomBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [bottomBtn setTitle:title forState:UIControlStateNormal];
        [self.contentView addSubview:bottomBtn];
        
        [bottomBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_topView.mas_bottom).offset(10);
            make.left.equalTo(self.contentView.mas_left).offset(40);
            make.right.equalTo(self.contentView.mas_right).offset(-10);;
            make.height.mas_equalTo(@(40));
            make.bottom.equalTo(self.contentView.mas_bottom).offset(-10);
        }];
    }
    else if([messsage.apptype isEqualToString:@"Article"])
    {

        _topView.typeLabel.text = @"照片";
        NSDictionary * dic = [messsage bodyObject];
        NSArray * picArr = dic[@"PList"];
        if(![picArr isKindOfClass:[NSArray class]])
        {
            return;
        }
#if 1
        AriticleView *articleView = [[AriticleView alloc] init];
        [articleView setMessage:messsage];
        [self.contentView addSubview:articleView];
        
        [articleView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_topView.mas_bottom).offset(20);
            make.left.equalTo(self.contentView.mas_left).offset(30);
            make.height.equalTo([articleView height]);
            make.width.equalTo([articleView width]);
            make.right.equalTo(self.contentView.mas_right).offset(-10);
            make.bottom.equalTo(self.contentView.mas_bottom).offset(-10);
        }];
#else
 
        if(picArr.count == 1)
        {
            UIImageView * imageView = [[UIImageView alloc]init];
            NSMutableString *thumbUrlStr =  [[NSMutableString alloc] initWithString:picArr[0]];
            [thumbUrlStr appendString:@".tiny.jpg"];
            imageView.contentMode = UIViewContentModeScaleAspectFit;
            imageView.clipsToBounds = YES;
            
            [imageView sd_setImageWithURL:[NSURL URLWithString:thumbUrlStr]
                         placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {}];
            
            [self.contentView addSubview:imageView];
            
            UILabel * descLabel = [[UILabel alloc]init];
            descLabel.numberOfLines = 0;
            descLabel.text = messsage.desc;
            descLabel.preferredMaxLayoutWidth = [UIScreen mainScreen].bounds.size.width - 100;
            [self.contentView addSubview:descLabel];
            
            [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.contentView).offset(20);
                make.top.equalTo(_topView.mas_bottom).offset(20);
                make.height.mas_equalTo(@(120));
                make.bottom.equalTo(descLabel.mas_top).offset(-10);
                
            }];
            [descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.contentView).offset(50);
                make.right.equalTo(self.contentView).offset(-50);
                make.bottom.equalTo(self.contentView.mas_bottom).offset(-10);
            }];
        } else if (picArr.count == 2) {
            
        } else if(picArr.count > 1){
            for (int i = 0; i < picArr.count; i++) {
                
                UIImageView *imageView = [[UIImageView alloc]init];
                NSMutableString *thumbUrlStr =  [[NSMutableString alloc] initWithString:picArr[i]];
                [thumbUrlStr appendString:@".tiny.jpg"];
                [imageView sd_setImageWithURL:[NSURL URLWithString:thumbUrlStr] placeholderImage:nil];
                [self.contentView addSubview:imageView];
                currentImageView = imageView;
                imageView.contentMode = UIViewContentModeCenter;
                imageView.clipsToBounds = YES;
                //每张图片大小为70*70
                
                float width = (([UIScreen mainScreen].bounds.size.width - 80) - PADDING * 2) / 3.0;
                [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                    if(i == 0)
                    {
                        make.left.equalTo(self.contentView.mas_left).offset(50);
                        make.top.equalTo(_topView.mas_bottom).offset(10);
                        make.width.mas_equalTo(@(width));
                        make.height.mas_equalTo(@(width));
                    }
                    else
                    {
                        int col = i%3;
                        int row = i/3;
                    
                        float left = 50 + (width + PADDING)*col;
                        float top = (width+PADDING)*row;
                        make.left.equalTo(self.contentView.mas_left).offset(left);
                        make.top.equalTo(_topView.mas_bottom).offset(10 + top);;
                        make.width.mas_equalTo(@(width));
                        make.height.mas_equalTo(@(width));
                    }
                }];
                
            }
            UILabel * descLabel = [[UILabel alloc]init];
            descLabel.numberOfLines = 0;
            descLabel.text = messsage.desc;
            descLabel.preferredMaxLayoutWidth = [UIScreen mainScreen].bounds.size.width - 100;
            [self.contentView addSubview:descLabel];
            
            [descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.contentView).offset(50);
                make.right.equalTo(self.contentView).offset(-50);
                make.top.equalTo(currentImageView.mas_bottom).offset(10);
                make.bottom.equalTo(self.contentView.mas_bottom).offset(-10);
            }];

        }
#endif
    }
    else if([messsage.apptype isEqualToString:@"Notice"])
    {
         _topView.typeLabel.text = @"通知";
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
