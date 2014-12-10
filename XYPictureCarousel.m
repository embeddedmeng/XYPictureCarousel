//
//  XYPictureCarousel.m
//  轮播
//
//  Created by MengXY on 14-12-10.
//  Copyright (c) 2014年 MengXY. All rights reserved.
//

#import "XYPictureCarousel.h"

// 宏定义设备尺寸
#define ScreenWH [UIScreen mainScreen].bounds.size
// 可向前滚动的轮播区域的个数(这个值最好不要超过 10000 )
#define kNumberOfcarouselView 1000
@interface XYPictureCarousel() <UIScrollViewDelegate>
/**
 *  图片轮询显示区
 */
@property (strong, nonatomic) UIScrollView *carouselView;
/**
 *  轮询区的尺寸
 */
@property (assign, nonatomic) CGSize carouselViewSize;
/**
 *  轮询显示图片的两个视图
 */
@property (strong, nonatomic) UIImageView *imageOne;
@property (strong, nonatomic) UIImageView *imageTwo;

/**
 *  所有图片名称(必须/pictures)
 */
@property (strong, nonatomic) NSArray *pictures;
/**
 *  所有图片url名称(必须/pictures)
 */
@property (strong, nonatomic) NSArray *picturesUrl;
/**
 *  轮播间隔时间，定时器
 */
@property (weak, nonatomic) NSTimer *timer;
/**
 *  记录定时时间
 */
@property (assign, nonatomic) CGFloat interval;
/**
 *  directionType
 */
@property (assign, nonatomic) CarouselDirectionType directionType;

/**
 *  保存当前显示编号
 */
@property (assign, nonatomic) int currImageViewNumber;

@end

@implementation XYPictureCarousel

#pragma mark - 初始化方法
+ (instancetype)carousel {
    return [[self alloc] init];
}


- (instancetype)init {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    // 放处理pictures代码
    // 1.创建一个轮播view
    UIScrollView *carouselView = [[UIScrollView alloc] init];
    // 设置carouselView 的滚动区为无限大
    carouselView.backgroundColor = [UIColor redColor];
    carouselView.pagingEnabled = YES;
//    carouselView.delegate = self;
    self.carouselView = carouselView;
    
    // 初始化两个用来显示的实例
    self.imageOne = [[UIImageView alloc] init];
    [self.carouselView addSubview:self.imageOne];
    self.imageTwo = [[UIImageView alloc] init];
    [self.carouselView addSubview:self.imageTwo];
    
    return self;
}
/**
 *  加载图片初始化
 */
- (instancetype)initWithPictrues:(NSArray *)pictures {
    self = [self init];

    if (pictures) {
        self.pictures = pictures;
        
        [self carouselWithPictures:pictures];
    } else {
        return self;
    }

    return self;
}

/**
 *  URL加载图片初始化
 */
- (instancetype)initWithPictruesUrl:(NSArray *)picturesUrl {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    // 放处理picturesUrl代码
    // 1.创建一个轮播view
    UIScrollView *carouselView = [[UIScrollView alloc] init];
    
    self.carouselView = carouselView;
    
    return self;
}

#pragma mark - 轮播显示
// 最后要将创建好的添加到指定控件上
- (void)showOnView:(UIView *)view {

    // 将设置好的轮播view添加到指定view上
    self.carouselView.delegate = self;
    [view addSubview:self.carouselView];
}


#pragma mark - scrollView的代理方法
// 实现scrollView的代理方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // 设置图片显示

    [self setImageShow];
}

// 当开始拖拽关闭定时器
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self stopTimer];
    
}
// 当停止拖拽启动定时器
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self startTimer:self.interval];
}


#pragma mark - 设置图片显示
/**
 *  设置图片显示
 */
- (void)setImageShow {
    
    CGFloat imageW = _carouselViewSize.width;
    CGFloat imageH = _carouselViewSize.height;
    CGFloat imageX;
    CGFloat imageY;
    CGFloat imageXPro;
    CGFloat imageYPro;
    
    // 当前图片编号
    int currImageViewNumber;
    if (self.directionType == CarouselDirectionHorizontal) {
        currImageViewNumber = self.carouselView.contentOffset.x / _carouselViewSize.width;
        imageX = currImageViewNumber * imageW;
        imageXPro = imageX + imageW;
        imageY = 0;
        imageYPro = 0;
    } else {
        currImageViewNumber = self.carouselView.contentOffset.y / _carouselViewSize.height;
        imageX = 0;
        imageXPro = 0;
        imageY = currImageViewNumber * imageH;
        imageYPro = imageY + imageH;
    }
    
    // 保存当前显示编号
    self.currImageViewNumber = currImageViewNumber;
    
    int index = currImageViewNumber % 2;
    
    // 添加UIImageView
    
    int imageCount = self.pictures.count;
    if (index) { // 为1时用imageTwo显示
        [self.imageTwo setFrame:CGRectMake(imageX, imageY, imageW, imageH)];
        [self.imageTwo setImage:[UIImage imageNamed:self.pictures[currImageViewNumber % imageCount]]];
        
        [self.imageOne setFrame:CGRectMake(imageXPro, imageYPro, imageW, imageH)];
        [self.imageOne setImage:[UIImage imageNamed:self.pictures[(currImageViewNumber + 1) % imageCount]]];
    } else { // 为0时用imageOne显示
        [self.imageOne setFrame:CGRectMake(imageX, imageY, imageW, imageH)];
        [self.imageOne setImage:[UIImage imageNamed:self.pictures[currImageViewNumber % imageCount]]];
        
        [self.imageTwo setFrame:CGRectMake(imageXPro, imageYPro, imageW, imageH)];
        [self.imageTwo setImage:[UIImage imageNamed:self.pictures[(currImageViewNumber + 1) % imageCount]]];
    }
}

#pragma mark 跳至下一张显示
- (void)stepNextImage {
    self.currImageViewNumber ++;
    CGFloat offsetX;
    CGFloat offsetY;
    CGPoint offset;
    if (self.directionType == CarouselDirectionHorizontal) {
        offsetX = self.currImageViewNumber * self.carouselViewSize.width;
        offsetY = 0;
    } else {
        offsetX = 0;
        offsetY = self.currImageViewNumber * self.carouselViewSize.height;
    }
    offset = CGPointMake(offsetX, offsetY);
    [self.carouselView setContentOffset:offset animated:YES];
}

#pragma mark - 传入各项参数的实例方法
- (void)carouselWithPictures:(NSArray *)pictures {
    [self carouselWithPictures:pictures frame:CGRectZero];
}

- (void)carouselWithPictures:(NSArray *)pictures frame:(CGRect)carouselFrame {
    [self carouselWithPictures:pictures frame:carouselFrame interval:0];
}

- (void)carouselWithPictures:(NSArray *)pictures frame:(CGRect)carouselFrame interval:(CGFloat)interval {
    [self carouselWithPictures:pictures frame:carouselFrame interval:0 direction:CarouselDirectionHorizontal];
}

- (void)carouselWithPictures:(NSArray *)pictures frame:(CGRect)carouselFrame interval:(CGFloat)interval direction:(CarouselDirectionType)directionType {
    if (!pictures) {
        NSLog(@"without pictures");
        return;
    }
    
    self.pictures = pictures;
    
    self.carouselView.frame = carouselFrame;
    
// 1.轮播区尺寸相关：当无frame设定时设置图片大小为轮播区尺寸
    
    if ([NSStringFromCGRect(carouselFrame) isEqualToString:NSStringFromCGRect(CGRectZero)]) {
        // 取得第一张图片
        UIImage *image = [UIImage imageNamed:pictures[0]];
        // 如果图片的尺寸小于屏幕，用图片尺寸作为轮播视图的尺寸
        if (image.size.width < ScreenWH.width && image.size.height < ScreenWH.height) {
            self.carouselView.frame = CGRectMake(0, 0, image.size.width, image.size.height);
        } else { // 首先，能进入这里表示图片一定有一个方向的尺寸超过了设备尺寸
            // 1.计算缩放比例
            CGFloat scale;
            // 1.1确定超出比例最多的一侧
            // 设备宽高比
            CGFloat scaleScreen = ScreenWH.width / ScreenWH.height;
            // 图片宽高比
            CGFloat scaleImage = image.size.width / image.size.height;
            if (scaleScreen > scaleImage) { // 图片高度超出比例多
                scale = image.size.height / ScreenWH.height;
            } else { // 图片宽度超出比例多
                scale = image.size.width / ScreenWH.width;
            }
            // 2.设置轮播区位置及尺寸
            self.carouselView.frame = CGRectMake(0, 0, image.size.width / scale, image.size.height / scale);
        }
    }
    
// 2.轮播定时相关：默认不定时轮播
    
    if (interval) { //如果interval有值，设置响应定时
        self.interval = interval;
        [self startTimer:interval];
    }
    
// 3.轮播方向相关：默认横向
    
    self.directionType = directionType;
    
    if (directionType == CarouselDirectionHorizontal) {
        // 设定轮播区范围
        self.carouselView.contentSize = CGSizeMake(MAXFLOAT, 0);
        // 默认为横向
        self.carouselViewSize = self.carouselView.frame.size;
        // 设置轮播区的偏移
        self.carouselView.contentOffset = CGPointMake(kNumberOfcarouselView * _carouselViewSize.width, 0);
        
    } else { // 如果为纵向
        // 重新设定轮播区范围
        self.carouselView.contentSize = CGSizeMake(0, MAXFLOAT);
        // 设置轮播尺寸
        self.carouselViewSize = self.carouselView.frame.size;
        // 设置轮播区的偏移
        self.carouselView.contentOffset = CGPointMake(0, kNumberOfcarouselView * _carouselViewSize.height);

    }
    [self setImageShow];
}

#pragma mark 传入各项参数的实例方法（url）未实现
- (void)carouselWithPicturesUrl:(NSArray *)picturesUrl interval:(CGFloat)interval {
    
}

#pragma mark - 定时器相关
- (void)startTimer:(CGFloat)interval {
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:interval target:self selector:@selector(stepNextImage) userInfo:nil repeats:YES];
    // 消息机制
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}

- (void)stopTimer {
    [_timer invalidate];
    _timer = nil;
}

@end
