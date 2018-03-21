//
//  ZQCHomePageControl.m
//  Financial
//
//  Created by ss on 2018/3/20.
//  Copyright © 2018年 ZQC. All rights reserved.
//

#import "ZQCHomePageControl.h"

@interface ZQCHomePageControl ()
{
    UIImage* activeImage;
    UIImage* inactiveImage;
}
@end

@implementation ZQCHomePageControl

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        activeImage = [UIImage imageWithColor:RGBACOLOR(0, 0, 0, 0.3)];
        inactiveImage = [UIImage imageWithColor:RGBACOLOR(255, 255, 255, 1)];
    }
    return self;
}


-(void)updateDots
{
    for (int i =0; i < [self.subviews count]; i++) {
        
        UIView * dot = [self.subviews objectAtIndex:i];
        dot.backgroundColor = [UIColor clearColor];
        UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0,0, 9, 3)];
        
        if (i == self.currentPage) {
            imageView.image = inactiveImage;
        } else {
            imageView.image = activeImage;
        }
        
        for (UIView * subViews in dot.subviews ) {
            [subViews removeFromSuperview];
        }
        
        [dot addSubview:imageView];
        
    }
    
}

//重写current方法
-(void)setCurrentPage:(NSInteger)page {
    
    [super setCurrentPage:page];
    
    [self updateDots];
    
}

- (void)setNumberOfPages:(NSInteger)numberOfPages {
    
    [super setNumberOfPages:numberOfPages];
    
    [self updateDots];
    
}

@end
