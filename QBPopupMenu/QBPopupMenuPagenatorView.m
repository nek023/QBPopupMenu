//
//  QBPopupMenuPagenatorView.m
//  QBPopupMenu
//
//  Created by Tanaka Katsuma on 2013/11/23.
//  Copyright (c) 2013年 Katsuma Tanaka. All rights reserved.
//

#import "QBPopupMenuPagenatorView.h"

@implementation QBPopupMenuPagenatorView

+ (CGFloat)pagenatorWidth
{
    return 10 + 10 * 2;
}

+ (instancetype)leftPagenatorViewWithTarget:(id)target action:(SEL)action
{
    return [[self alloc] initWithArrowDirection:QBPopupMenuPagenatorDirectionLeft target:target action:action];
}

+ (instancetype)rightPagenatorViewWithTarget:(id)target action:(SEL)action
{
    return [[self alloc] initWithArrowDirection:QBPopupMenuPagenatorDirectionRight target:target action:action];
}

- (instancetype)initWithArrowDirection:(QBPopupMenuPagenatorDirection)arrowDirection target:(id)target action:(SEL)action
{
    self = [super initWithItem:nil];
    
    if (self) {
        // Property settings
        self.target = target;
        self.action = action;
        
        // Set arrow image
        UIImage *arrowImage = [self arrowImageWithSize:CGSizeMake(10, 10)
                                             direction:arrowDirection
                                           highlighted:NO];
        [self.button setImage:arrowImage forState:UIControlStateNormal];
        
        UIImage *highlightedArrowImage = [self arrowImageWithSize:CGSizeMake(10, 10)
                                                        direction:arrowDirection
                                                      highlighted:YES];
        [self.button setImage:highlightedArrowImage forState:UIControlStateHighlighted];
    }
    
    return self;
}


#pragma mark - Actions

- (void)performAction
{
    if (self.target && self.action) {
        [self.target performSelector:self.action withObject:nil afterDelay:0];
    }
}


#pragma mark - Updating the View

- (CGSize)sizeThatFits:(CGSize)size
{
    CGSize buttonSize = [self.button sizeThatFits:CGSizeZero];
    buttonSize.width = [[self class] pagenatorWidth];
    
    return buttonSize;
}

- (UIImage *)arrowImageWithSize:(CGSize)size direction:(QBPopupMenuPagenatorDirection)direction highlighted:(BOOL)highlighted
{
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    
    // Draw arrow
    [self drawArrowInRect:CGRectMake(0, 0, size.width, size.height) direction:direction highlighted:highlighted];
    
    // Create image from buffer
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}


#pragma mark - Creating Paths

- (CGMutablePathRef)arrowPathInRect:(CGRect)rect direction:(QBPopupMenuPagenatorDirection)direction
{
    CGMutablePathRef path = CGPathCreateMutable();
    
    switch (direction) {
        case QBPopupMenuPagenatorDirectionLeft:
        {
            CGPathMoveToPoint(path, NULL, rect.origin.x + rect.size.width, rect.origin.y);
            CGPathAddLineToPoint(path, NULL, rect.origin.x + rect.size.width, rect.origin.y + rect.size.height);
            CGPathAddLineToPoint(path, NULL, rect.origin.x, rect.origin.y + rect.size.height / 2.0);
            CGPathCloseSubpath(path);
        }
            break;
            
        case QBPopupMenuPagenatorDirectionRight:
        {
            CGPathMoveToPoint(path, NULL, rect.origin.x, rect.origin.y);
            CGPathAddLineToPoint(path, NULL, rect.origin.x, rect.origin.y + rect.size.height);
            CGPathAddLineToPoint(path, NULL, rect.origin.x + rect.size.width, rect.origin.y + rect.size.height / 2.0);
            CGPathCloseSubpath(path);
        }
            break;
            
        default:
            break;
    }
    
    return path;
}


#pragma mark - Drawing

- (void)drawArrowInRect:(CGRect)rect direction:(QBPopupMenuPagenatorDirection)direction highlighted:(BOOL)highlighted
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    
    CGMutablePathRef path = [self arrowPathInRect:rect direction:direction];
    CGContextAddPath(context, path);
    
    CGContextSetFillColorWithColor(context, [[UIColor whiteColor] CGColor]);
    CGContextFillPath(context);
    
    CGPathRelease(path);
    
    CGContextRestoreGState(context);
}

@end
