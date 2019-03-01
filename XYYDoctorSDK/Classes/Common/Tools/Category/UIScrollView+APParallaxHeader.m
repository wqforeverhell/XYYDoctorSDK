//
//  UIScrollView+APParallaxHeader.m
//
//  Created by Mathias Amnell on 2013-04-12.
//  Copyright (c) 2013 Apping AB. All rights reserved.
//

#import "UIScrollView+APParallaxHeader.h"

#import <QuartzCore/QuartzCore.h>

@interface APParallaxView ()

@property (nonatomic, readwrite) APParallaxTrackingState state;

@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, readwrite) CGFloat originalTopInset;
@property (nonatomic) CGFloat parallaxHeight;

@property(nonatomic, assign) BOOL isObserving;

@end



#pragma mark - UIScrollView (APParallaxHeader)
#import <objc/runtime.h>

static char UIScrollViewParallaxView;

@implementation UIScrollView (APParallaxHeader)

- (void)addParallaxWithView:(UIView*)view andHeight:(CGFloat)height andSep:(CGFloat)sep {
    if(!self.parallaxView) {
        self.contentOffset = CGPointZero;
        UIEdgeInsets newInset = self.contentInset;
        newInset.top = height;
        self.contentInset = newInset;
        
        APParallaxView *parallaxView = [[APParallaxView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, height+sep)];
        parallaxView.sep = sep;
        parallaxView.height = sep+height;
        parallaxView.backgroundColor = [UIColor clearColor];
        [parallaxView setClipsToBounds:NO];
        [view setAutoresizingMask:UIViewAutoresizingNone];
        [parallaxView addSubview:view];
        
        parallaxView.scrollView = self;
        [self addSubview:parallaxView];
        [self sendSubviewToBack:parallaxView];
        
        parallaxView.originalTopInset = self.contentInset.top;
        
        self.parallaxView = parallaxView;
        self.showsParallax = YES;
    }
}

- (void)setParallaxView:(APParallaxView *)parallaxView {
    objc_setAssociatedObject(self, &UIScrollViewParallaxView,
                             parallaxView,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (APParallaxView *)parallaxView {
    return objc_getAssociatedObject(self, &UIScrollViewParallaxView);
}

- (void)setShowsParallax:(BOOL)showsParallax {
    self.parallaxView.hidden = !showsParallax;
    
    if(!showsParallax) {
        if (self.parallaxView.isObserving) {
            [self removeObserver:self.parallaxView forKeyPath:@"contentOffset"];
            [self removeObserver:self.parallaxView forKeyPath:@"frame"];
            self.parallaxView.isObserving = NO;
        }
    }
    else {
        if (!self.parallaxView.isObserving) {
            [self addObserver:self.parallaxView forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
            [self addObserver:self.parallaxView forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:nil];
            self.parallaxView.isObserving = YES;
        }
    }
}

- (BOOL)showsParallax {
    return !self.parallaxView.hidden;
}

@end

#pragma mark - APParallaxView

@implementation APParallaxView

- (id)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]) {
        
        // default styling values
        [self setAutoresizingMask:UIViewAutoresizingNone];
        [self setAutoresizesSubviews:YES];
    }
    
    return self;
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    if (self.superview && newSuperview == nil) {
        UIScrollView *scrollView = (UIScrollView *)self.superview;
        if (scrollView.showsParallax) {
            if (self.isObserving) {
                //If enter this branch, it is the moment just before "APParallaxView's dealloc", so remove observer here
                [scrollView removeObserver:self forKeyPath:@"contentOffset"];
                [scrollView removeObserver:self forKeyPath:@"frame"];
                self.isObserving = NO;
            }
        }
    }
}

- (void)addSubview:(UIView *)view
{
    [super addSubview:view];
    self.currentSubView = view;
}

#pragma mark - Observing

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if([keyPath isEqualToString:@"contentOffset"])
        [self scrollViewDidScroll:[[change valueForKey:NSKeyValueChangeNewKey] CGPointValue]];
    else if([keyPath isEqualToString:@"frame"])
        [self layoutSubviews];
}

- (void)scrollViewDidScroll:(CGPoint)contentOffset {
    CGRect frame = self.frame;
    CGFloat topMove = _sep;
    CGFloat height = _height - topMove;
    CGFloat d = 1.0f;
    
    UIScrollView *scrollView = (UIScrollView *)self.superview;
    CGFloat heightMove = topMove;
    CGFloat maxOffset = -topMove - _height;
    if (contentOffset.y < maxOffset) {
        scrollView.contentOffset = CGPointMake(contentOffset.x, maxOffset);
    }
    
    CGFloat currentMove = -height - contentOffset.y;
    if (currentMove > topMove+heightMove) {
        currentMove = topMove+heightMove;
    }
    frame.size.height = height + (heightMove/(topMove+heightMove))*currentMove*d;
    frame.origin.y = -height - (heightMove/(topMove+heightMove))*currentMove*d;
    if (frame.origin.y < -_height) {
        frame.origin.y = -_height;
    }
    self.frame = frame;
}


@end
