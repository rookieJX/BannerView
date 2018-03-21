//
//  ZQCHomeBannerCell.m
//  Financial
//
//  Created by ss on 2018/3/20.
//  Copyright © 2018年 ZQC. All rights reserved.
//

#import "ZQCHomeBannerCell.h"

@interface ZQCHomeBannerCell ()

@property (nonatomic,weak) UIImageView *imageView;

@end

@implementation ZQCHomeBannerCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

#pragma mark - PrivateMeth
- (void)setupUI {
    // 创建图片
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = [UIImage imageNamed:@"base_view_placehold"];
    [self.contentView addSubview:imageView];
    self.imageView = imageView;
}

#pragma mark - Layout
- (void)layoutSubviews {
    [super layoutSubviews];
    [self.imageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(self.contentView);
    }];
}

- (void)setBannerImage:(NSString *)imageName {
    self.imageView.image = [UIImage imageNamed:imageName];
}
@end
