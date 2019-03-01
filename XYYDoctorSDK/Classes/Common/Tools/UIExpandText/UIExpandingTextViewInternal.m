/*
 *  UIExpandingTextViewInternal.m
 *
 *  Created by Brandon Hamilton on 2011/05/03.
 *  Copyright 2011 Brandon Hamilton.
 *
 *  Permission is hereby granted, free of charge, to any person obtaining a copy
 *  of this software and associated documentation files (the "Software"), to deal
 *  in the Software without restriction, including without limitation the rights
 *  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 *  copies of the Software, and to permit persons to whom the Software is
 *  furnished to do so, subject to the following conditions:
 *
 *  The above copyright notice and this permission notice shall be included in
 *  all copies or substantial portions of the Software.
 *
 *  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 *  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 *  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 *  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 *  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 *  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 *  THE SOFTWARE.
 */

#import "UIExpandingTextViewInternal.h"
#import "UIExpandingTextView.h"

#define kTopContentInset -4
#define lBottonContentInset 12

@implementation UIExpandingTextViewInternal

-(void)setContentOffset:(CGPoint)s
{
    if (s.y==0) {
        return;
    }
    /* Check if user scrolled */
	if(self.tracking || self.decelerating)
    {
		self.contentInset = UIEdgeInsetsMake(kTopContentInset, 0, 0, 0);
	}
    else
    {
		float bottomContentOffset = (self.contentSize.height - self.frame.size.height + self.contentInset.bottom);
		if(s.y < bottomContentOffset && self.scrollEnabled)
        {
            if([[[[UIDevice currentDevice].systemVersion componentsSeparatedByString:@"."] objectAtIndex:0] intValue] < 7)
                self.contentInset = UIEdgeInsetsMake(kTopContentInset, 0, lBottonContentInset, 0);
            else
                self.contentInset = UIEdgeInsetsMake(kTopContentInset, 0, 4, 0);
		}
	}
	[super setContentOffset:s];
}

-(void)setContentInset:(UIEdgeInsets)s
{
	UIEdgeInsets edgeInsets = s;
	edgeInsets.top = kTopContentInset;
	if(s.bottom > 12)
    {
        edgeInsets.bottom = 4;
    }
	[super setContentInset:edgeInsets];
}

- (void)awakeFromNib {
    UILongPressGestureRecognizer* gr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longClick:)];
    [self addGestureRecognizer:gr];
}

- (void)longClick:(UILongPressGestureRecognizer*)gesture {
    if (gesture.state == UIGestureRecognizerStateBegan) {
        [self becomeFirstResponder];
        
        NSMutableArray *items = [[NSMutableArray alloc] init];
        [items addObject:[[UIMenuItem alloc] initWithTitle:@"黏贴" action:@selector(pasteText:)]];
        UIMenuController *menu = [UIMenuController sharedMenuController];
        [menu setMenuItems:items];
        [menu setTargetRect:self.frame inView:[[self superview] superview]];
        [menu setMenuVisible:YES animated:YES];
    }
}

-(BOOL)canBecomeFirstResponder{
    return YES;
}

-(BOOL)canPerformAction:(SEL)action withSender:(id)sender{
    if(action == @selector(paste:)) {
        return NO;
    }
    else if(action == @selector(pasteText:)) {
        return YES;
    }
    return NO;
}

- (void)pasteText:(id)sender {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    NSMutableString *faceString = nil;
    if(self.text == nil || self.text.length == 0) {
        faceString = [[NSMutableString alloc]initWithString:@""];
    }
    else {
        faceString = [[NSMutableString alloc]initWithString:self.text];
    }
    if(pasteboard.string == nil || pasteboard.string.length == 0) {
        return;
    }
    [faceString appendString:pasteboard.string];
    self.text = faceString;
    
    UIExpandingTextView* view = (UIExpandingTextView*)[self superview];
    if([view respondsToSelector:@selector(pasteText:)]) {
        [view performSelector:@selector(pasteText:) withObject:sender];
    }
}

@end
