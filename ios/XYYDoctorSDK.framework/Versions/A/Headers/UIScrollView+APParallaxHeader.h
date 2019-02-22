//
//  UIScrollView+APParallaxHeader.h
//
//  Created by Mathias Amnell on 2013-04-12.
//  Copyright (c) 2013 Apping AB. All rights reserved.
//

#import <UIKit/UIKit.h>

@class APParallaxView;

@interface UIScrollView (APParallaxHeader)

- (void)addParallaxWithView:(UIView*)view andHeight:(CGFloat)height andSep:(CGFloat)sep;

@property (nonatomic, strong, readonly) APParallaxView *parallaxView;
@property (nonatomic, assign) BOOL showsParallax;

@end


typedef NSUInteger APParallaxTrackingState;

@interface APParallaxView : UIView

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIView *currentSubView;
@property (nonatomic, assign) CGFloat sep;
@property (nonatomic, assign) CGFloat height;

@end

