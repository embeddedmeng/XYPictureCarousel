//
//  XYPictureCarousel.h
//  轮播
//
//  Created by MengXY on 14-12-10.
//  Copyright (c) 2014年 MengXY. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    CarouselDirectionHorizontal, // 横向
    CarouselDirectionVertical    // 纵向
}CarouselDirectionType;

@interface XYPictureCarousel : NSObject
/**
 轮播时间间隔,为0时不自动滚动，默认为0
 滚动方向,为0（默认）横向，为1纵向
 滚动区尺寸，默认为第一张图片尺寸（横向最大不能超过设备宽度，如果超过则按比例缩放，并设置宽度为屏幕宽度）
 */
#pragma mark - 初始化方法
+ (instancetype)carousel;

- (instancetype)initWithPictrues:(NSArray *)pictures;

- (instancetype)initWithPictruesUrl:(NSArray *)picturesUrl;

#pragma mark - 设置参数的类方法
- (void)carouselWithPictures:(NSArray *)pictures;

- (void)carouselWithPictures:(NSArray *)pictures frame:(CGRect)carouselFrame;

- (void)carouselWithPictures:(NSArray *)pictures frame:(CGRect)carouselFrame interval:(CGFloat)interval;

- (void)carouselWithPictures:(NSArray *)pictures frame:(CGRect)carouselFrame interval:(CGFloat)interval direction:(CarouselDirectionType)directionType;

#pragma mark - 最终显示
- (void)showOnView:(UIView *)view;

@end
