XYPictureCarousel
=================

create a carousel view to show pictures
simple create for excemple:
###
    @property (strong, nonatomic) XYPictureCarousel *carousel;

###
    NSArray *pictures = @[@"img_01.png",@"img_02.png",@"img_03.png",@"img_04.png",@"img_05.png"];
    self.carousel = [[XYPictureCarousel alloc] init];
    
    [self.carousel carouselWithPictures:pictures frame:CGRectMake(100, 100, 200, 100) interval:2 direction:CarouselDirectionVertical];
    
    [self.carousel showOnView:self.view];
