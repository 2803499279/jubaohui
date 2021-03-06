//
//  YZCancelInvCell.m
//  JBHProject
//
//  Created by zyz on 2017/11/7.
//  Copyright © 2017年 聚宝汇. All rights reserved.
//

#import "YZCancelInvCell.h"

@interface YZCancelInvCell (){
    UILabel *typeLabel;
    UIImageView *levelImgView;
    UIView *backView;
}
@end


@implementation YZCancelInvCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        typeLabel = [[UILabel alloc] init];
        typeLabel.frame = CGRectMake(50*YZAdapter, 0, 300*YZAdapter, 45*YZAdapter);
        typeLabel.backgroundColor = [UIColor clearColor];
        typeLabel.font = FONT(13);
        typeLabel.textColor = MainFont_Color;
        [self.contentView addSubview:typeLabel];
        
        _favBtn = [[UIImageView alloc] init];
        _favBtn.frame = CGRectMake(25*YZAdapter, 15*YZAdapter, 15*YZAdapter, 15*YZAdapter);
        _favBtn.backgroundColor = [UIColor clearColor];
        _favBtn.image = [UIImage imageNamed:@"noagree"];
//        [_favBtn setImage:[UIImage imageNamed:@"noagree"] forState:UIControlStateNormal];
//        [_favBtn setImage:[UIImage imageNamed:@"agree"] forState:UIControlStateSelected];
        [self.contentView addSubview:_favBtn];
        _favBtn.userInteractionEnabled = YES;
        backView = [[UIView alloc] initWithFrame:CGRectMake(0, 44*YZAdapter, Screen_W, 1*YZAdapter)];
        backView.backgroundColor = BackGround_Color;
        [self.contentView addSubview:backView];
    }
    return self;
}


- (void)updateDataWith:(NSDictionary *)lastItem{
//    UIViewSetFrameY(_favBtn, 0);
//    NSString *sel = [self.dict  objectForKey:@"isCollect"];
//    _favBtn.selected = sel.intValue;
    _favBtn.userInteractionEnabled = YES;
    typeLabel.text = lastItem[@"title"];
}










- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
