//
//  QBPlasticPopupMenu.m
//  QBPopupMenu
//
//  Created by Tanaka Katsuma on 2013/11/25.
//  Copyright (c) 2013年 Katsuma Tanaka. All rights reserved.
//

#import "QBPlasticPopupMenu.h"

@implementation QBPlasticPopupMenu

#pragma mark - Creating Paths

- (CGMutablePathRef)upperHeadPathInRect:(CGRect)rect cornerRadius:(CGFloat)cornerRadius
{
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, rect.origin.x, rect.origin.y + cornerRadius);
    CGPathAddArcToPoint(path, NULL, rect.origin.x, rect.origin.y, rect.origin.x + cornerRadius, rect.origin.y, cornerRadius);
    CGPathAddLineToPoint(path, NULL, rect.origin.x + rect.size.width, rect.origin.y);
    CGPathAddLineToPoint(path, NULL, rect.origin.x + rect.size.width, rect.origin.y + rect.size.height);
    CGPathAddLineToPoint(path, NULL, rect.origin.x, rect.origin.y + rect.size.height);
    CGPathCloseSubpath(path);
    
    return path;
}

- (CGMutablePathRef)lowerHeadPathInRect:(CGRect)rect cornerRadius:(CGFloat)cornerRadius
{
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, rect.origin.x, rect.origin.y);
    CGPathAddLineToPoint(path, NULL, rect.origin.x + rect.size.width, rect.origin.y);
    CGPathAddLineToPoint(path, NULL, rect.origin.x + rect.size.width, rect.origin.y + rect.size.height);
    CGPathAddLineToPoint(path, NULL, rect.origin.x + cornerRadius, rect.origin.y + rect.size.height);
    CGPathAddArcToPoint(path, NULL, rect.origin.x, rect.origin.y + rect.size.height, rect.origin.x, rect.origin.y + rect.size.height - cornerRadius, cornerRadius);
    CGPathCloseSubpath(path);
    
    return path;
}

- (CGMutablePathRef)upperTailPathInRect:(CGRect)rect cornerRadius:(CGFloat)cornerRadius
{
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, rect.origin.x, rect.origin.y);
    CGPathMoveToPoint(path, NULL, rect.origin.x + rect.size.width - cornerRadius, rect.origin.y);
    CGPathAddArcToPoint(path, NULL, rect.origin.x + rect.size.width, rect.origin.y, rect.origin.x + rect.size.width, rect.origin.y + cornerRadius, cornerRadius);
    CGPathAddLineToPoint(path, NULL, rect.origin.x + rect.size.width, rect.origin.y + rect.size.height);
    CGPathAddLineToPoint(path, NULL, rect.origin.x, rect.origin.y + rect.size.height);
    CGPathCloseSubpath(path);
    
    return path;
}

- (CGMutablePathRef)lowerTailPathInRect:(CGRect)rect cornerRadius:(CGFloat)cornerRadius
{
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, rect.origin.x, rect.origin.y);
    CGPathAddLineToPoint(path, NULL, rect.origin.x + rect.size.width, rect.origin.y);
    CGPathAddLineToPoint(path, NULL, rect.origin.x + rect.size.width, rect.origin.y + rect.size.height - cornerRadius);
    CGPathAddArcToPoint(path, NULL, rect.origin.x + rect.size.width, rect.origin.y + rect.size.height, rect.origin.x + rect.size.width - cornerRadius, rect.origin.y + rect.size.height, cornerRadius);
    CGPathAddLineToPoint(path, NULL, rect.origin.x, rect.origin.y + rect.size.height);
    CGPathCloseSubpath(path);
    
    return path;
}


#pragma mark - Drawing Popup Menu Image

- (void)drawArrowInRect:(CGRect)rect direction:(QBPopupMenuArrowDirection)direction highlighted:(BOOL)highlighted
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // Border
    CGContextSaveGState(context); {
        CGRect arrowRect = CGRectZero;
        switch (direction) {
            case QBPopupMenuArrowDirectionDown:
                arrowRect = CGRectMake(rect.origin.x, rect.origin.y - 0.6, rect.size.width, rect.size.height);
                break;
                
            case QBPopupMenuArrowDirectionUp:
                arrowRect = CGRectMake(rect.origin.x, rect.origin.y + 0.6, rect.size.width, rect.size.height);
                break;
                
            case QBPopupMenuArrowDirectionLeft:
                arrowRect = CGRectMake(rect.origin.x + 0.6, rect.origin.y - 0.5, rect.size.width, rect.size.height);
                break;
                
            case QBPopupMenuArrowDirectionRight:
                arrowRect = CGRectMake(rect.origin.x - 0.6, rect.origin.y - 0.5, rect.size.width, rect.size.height);
                break;
                
            default:
                break;
        }
        
        CGMutablePathRef path = [self arrowPathInRect:arrowRect direction:direction];
        CGContextAddPath(context, path);
        
        CGContextSetRGBFillColor(context, 0, 0, 0, 1.0);
        CGContextFillPath(context);
        
        CGPathRelease(path);
    } CGContextRestoreGState(context);
    
    // Highlight
    CGContextSaveGState(context); {
        CGRect arrowRect = CGRectZero;
        switch (direction) {
            case QBPopupMenuArrowDirectionUp:
                arrowRect = CGRectMake(rect.origin.x, rect.origin.y + 2, rect.size.width, rect.size.height);
                break;
                
            case QBPopupMenuArrowDirectionLeft:
                arrowRect = CGRectMake(rect.origin.x + 2, rect.origin.y - 0.5 + 1, rect.size.width - 1, rect.size.height - 2);
                break;
                
            case QBPopupMenuArrowDirectionRight:
                arrowRect = CGRectMake(rect.origin.x - 1, rect.origin.y - 0.5 + 1, rect.size.width - 1, rect.size.height - 2);
                break;
                
            default:
                break;
        }
        
        CGMutablePathRef path = [self arrowPathInRect:arrowRect direction:direction];
        CGContextAddPath(context, path);
        
        if (highlighted) {
            CGContextSetRGBFillColor(context, 0.384, 0.608, 0.906, 1.0);
        } else {
            CGContextSetRGBFillColor(context, 0.471, 0.471, 0.471, 1.0);
        }
        CGContextFillPath(context);
        
        CGPathRelease(path);
    } CGContextRestoreGState(context);
    
    // Body
    CGContextSaveGState(context); {
        switch (direction) {
            case QBPopupMenuArrowDirectionDown:
            {
                if (highlighted) {
                    CGMutablePathRef path = [self arrowPathInRect:CGRectMake(rect.origin.x, rect.origin.y - 2, rect.size.width, rect.size.height) direction:direction];
                    CGContextAddPath(context, path);
                    CGContextClip(context);
                    
                    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
                    
                    CGFloat components[8];
                    components[0] = 0.027; components[1] = 0.169; components[2] = 0.733; components[3] = 1;
                    components[4] = 0.020; components[5] = 0.114; components[6] = 0.675; components[7] = 1;
                    
                    CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace, components, NULL, 2);
                    
                    CGPoint startPoint = CGPointMake(rect.origin.x, rect.origin.y - 2);
                    CGPoint endPoint = CGPointMake(rect.origin.x, rect.origin.y + rect.size.height);
                    
                    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, kCGGradientDrawsAfterEndLocation);
                    
                    CGGradientRelease(gradient);
                    CGColorSpaceRelease(colorSpace);
                    CGPathRelease(path);
                }
            }
                break;
                
            case QBPopupMenuArrowDirectionUp:
            {
                CGMutablePathRef path = [self arrowPathInRect:CGRectMake(rect.origin.x + 1.4, rect.origin.y + 2 + 1.4, rect.size.width - 2.8, rect.size.height - 1.4) direction:direction];
                CGContextAddPath(context, path);
                CGContextClip(context);
                
                CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
                
                CGFloat components[8];
                if (highlighted) {
                    components[0] = 0.290; components[1] = 0.580; components[2] = 1.000; components[3] = 1;
                    components[4] = 0.216; components[5] = 0.471; components[6] = 0.871; components[7] = 1;
                } else {
                    components[0] = 0.401; components[1] = 0.401; components[2] = 0.401; components[3] = 1;
                    components[4] = 0.314; components[5] = 0.314; components[6] = 0.314; components[7] = 1;
                }
                
                CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace, components, NULL, 2);
                
                CGPoint startPoint = CGPointMake(rect.origin.x, rect.origin.y + 2);
                CGPoint endPoint = CGPointMake(rect.origin.x, rect.origin.y + rect.size.height);
                
                CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, kCGGradientDrawsAfterEndLocation);
                
                CGGradientRelease(gradient);
                CGColorSpaceRelease(colorSpace);
                CGPathRelease(path);
            }
                break;
                
            case QBPopupMenuArrowDirectionLeft:
            {
                CGMutablePathRef path = [self arrowPathInRect:CGRectMake(rect.origin.x + 2, rect.origin.y - 0.5 + 2, rect.size.width - 1, rect.size.height - 2) direction:direction];
                CGContextAddPath(context, path);
                CGContextClip(context);
                
                CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
                
                CGFloat components[16];
                if (highlighted) {
                    components[0]  = 0.082; components[1]  = 0.376; components[2]  = 0.859; components[3]  = 1;
                    components[4]  = 0.004; components[5]  = 0.333; components[6]  = 0.851; components[7]  = 1;
                    components[8]  = 0.000; components[9]  = 0.282; components[10] = 0.839; components[11] = 1;
                    components[12] = 0.000; components[13] = 0.216; components[14] = 0.796; components[15] = 1;
                } else {
                    components[0]  = 0.216; components[1]  = 0.216; components[2]  = 0.216; components[3]  = 1;
                    components[4]  = 0.165; components[5]  = 0.165; components[6]  = 0.165; components[7]  = 1;
                    components[8]  = 0.102; components[9]  = 0.102; components[10] = 0.102; components[11] = 1;
                    components[12] = 0.051; components[13] = 0.051; components[14] = 0.051; components[15] = 1;
                }
                
                CGFloat locations[4] = { 0.0, 0.5, 0.5, 1.0 };
                CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace, components, locations, 4);
                
                CGPoint startPoint = CGPointMake(rect.origin.x, rect.origin.y - 1);
                CGPoint endPoint = CGPointMake(rect.origin.x, rect.origin.y + rect.size.height);
                
                CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, kCGGradientDrawsAfterEndLocation);
                
                CGGradientRelease(gradient);
                CGColorSpaceRelease(colorSpace);
                CGPathRelease(path);
            }
                break;
                
            case QBPopupMenuArrowDirectionRight:
            {
                CGMutablePathRef path = [self arrowPathInRect:CGRectMake(rect.origin.x - 1, rect.origin.y - 0.5 + 2, rect.size.width - 1, rect.size.height - 2) direction:direction];
                CGContextAddPath(context, path);
                CGContextClip(context);
                
                CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
                
                CGFloat components[16];
                if (highlighted) {
                    components[0]  = 0.082; components[1]  = 0.376; components[2]  = 0.859; components[3]  = 1;
                    components[4]  = 0.004; components[5]  = 0.333; components[6]  = 0.851; components[7]  = 1;
                    components[8]  = 0.000; components[9]  = 0.282; components[10] = 0.839; components[11] = 1;
                    components[12] = 0.000; components[13] = 0.216; components[14] = 0.796; components[15] = 1;
                } else {
                    components[0]  = 0.216; components[1]  = 0.216; components[2]  = 0.216; components[3]  = 1;
                    components[4]  = 0.165; components[5]  = 0.165; components[6]  = 0.165; components[7]  = 1;
                    components[8]  = 0.102; components[9]  = 0.102; components[10] = 0.102; components[11] = 1;
                    components[12] = 0.051; components[13] = 0.051; components[14] = 0.051; components[15] = 1;
                }
                
                CGFloat locations[4] = { 0.0, 0.5, 0.5, 1.0 };
                CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace, components, locations, 4);
                
                CGPoint startPoint = CGPointMake(rect.origin.x, rect.origin.y - 1);
                CGPoint endPoint = CGPointMake(rect.origin.x, rect.origin.y + rect.size.height);
                
                CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, kCGGradientDrawsAfterEndLocation);
                
                CGGradientRelease(gradient);
                CGColorSpaceRelease(colorSpace);
                CGPathRelease(path);
            }
                break;
                
            default:
                break;
        }
    } CGContextRestoreGState(context);
}

- (void)drawHeadInRect:(CGRect)rect cornerRadius:(CGFloat)cornerRadius highlighted:(BOOL)highlighted
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // Border
    CGContextSaveGState(context); {
        CGMutablePathRef path = [self headPathInRect:rect cornerRadius:cornerRadius];
        CGContextAddPath(context, path);
        
        CGContextSetRGBFillColor(context, 0, 0, 0, 1.0);
        CGContextFillPath(context);
        
        CGPathRelease(path);
    } CGContextRestoreGState(context);
    
    // Highlight
    CGContextSaveGState(context); {
        CGMutablePathRef path = [self headPathInRect:CGRectMake(rect.origin.x + 1, rect.origin.y + 1, rect.size.width - 1, rect.size.height - 2)
cornerRadius:cornerRadius - 1];
        CGContextAddPath(context, path);
        
        if (highlighted) {
            CGContextSetRGBFillColor(context, 0.384, 0.608, 0.906, 1.0);
        } else {
            CGContextSetRGBFillColor(context, 0.471, 0.471, 0.471, 1.0);
        }
        CGContextFillPath(context);
        
        CGPathRelease(path);
    } CGContextRestoreGState(context);
    
    // Upper head
    CGContextSaveGState(context); {
        CGMutablePathRef path = [self upperHeadPathInRect:CGRectMake(rect.origin.x + 1, rect.origin.y + 2, rect.size.width - 1, rect.size.height / 2 - 2) cornerRadius:cornerRadius - 1];
        CGContextAddPath(context, path);
        CGContextClip(context);
        
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        CGFloat components[8];
        if (highlighted) {
            components[0] = 0.216; components[1] = 0.471; components[2] = 0.871; components[3] = 1;
            components[4] = 0.059; components[5] = 0.353; components[6] = 0.839; components[7] = 1;
        } else {
            components[0] = 0.314; components[1] = 0.314; components[2] = 0.314; components[3] = 1;
            components[4] = 0.165; components[5] = 0.165; components[6] = 0.165; components[7] = 1;
        }
        CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace, components, NULL, 2);
        
        CGPoint startPoint = CGPointMake(rect.origin.x, rect.origin.y + 2);
        CGPoint endPoint = CGPointMake(rect.origin.x, rect.origin.y + rect.size.height / 2 - 2);
        
        CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, kCGGradientDrawsAfterEndLocation);
        
        CGGradientRelease(gradient);
        CGColorSpaceRelease(colorSpace);
        CGPathRelease(path);
    } CGContextRestoreGState(context);
    
    // Lower head
    CGContextSaveGState(context); {
        CGMutablePathRef path = [self lowerHeadPathInRect:CGRectMake(rect.origin.x + 1, rect.origin.y + rect.size.height / 2, rect.size.width - 1, rect.size.height / 2 - 1) cornerRadius:cornerRadius - 1];
        CGContextAddPath(context, path);
        CGContextClip(context);
        
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        CGFloat components[8];
        if (highlighted) {
            components[0] = 0.047; components[1] = 0.306; components[2] = 0.827; components[3] = 1;
            components[4] = 0.027; components[5] = 0.176; components[6] = 0.737; components[7] = 1;
        } else {
            components[0] = 0.102; components[1] = 0.102; components[2] = 0.102; components[3] = 1;
            components[4] = 0;     components[5] = 0;     components[6] = 0;     components[7] = 1;
        }
        CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace, components, NULL, 2);
        
        CGPoint startPoint = CGPointMake(rect.origin.x, rect.origin.y + rect.size.height / 2);
        CGPoint endPoint = CGPointMake(rect.origin.x, rect.origin.y + rect.size.height - 1);
        
        CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, kCGGradientDrawsAfterEndLocation);
        
        CGGradientRelease(gradient);
        CGColorSpaceRelease(colorSpace);
        CGPathRelease(path);
    } CGContextRestoreGState(context);
}

- (void)drawTailInRect:(CGRect)rect cornerRadius:(CGFloat)cornerRadius highlighted:(BOOL)highlighted
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // Border
    CGContextSaveGState(context); {
        CGMutablePathRef path = [self tailPathInRect:rect cornerRadius:cornerRadius];
        CGContextAddPath(context, path);
        
        CGContextSetRGBFillColor(context, 0, 0, 0, 1.0);
        CGContextFillPath(context);
        
        CGPathRelease(path);
    } CGContextRestoreGState(context);
    
    // Highlight
    CGContextSaveGState(context); {
        CGMutablePathRef path = [self tailPathInRect:CGRectMake(rect.origin.x, rect.origin.y + 1, rect.size.width - 1, rect.size.height - 2) cornerRadius:cornerRadius - 1];
        CGContextAddPath(context, path);
        
        if (highlighted) {
            CGContextSetRGBFillColor(context, 0.384, 0.608, 0.906, 1.0);
        } else {
            CGContextSetRGBFillColor(context, 0.471, 0.471, 0.471, 1.0);
        }
        CGContextFillPath(context);
        
        CGPathRelease(path);
    } CGContextRestoreGState(context);
    
    // Upper body
    CGContextSaveGState(context); {
        CGMutablePathRef path = [self upperTailPathInRect:CGRectMake(rect.origin.x, rect.origin.y + 2, rect.size.width - 1, rect.size.height / 2 - 2) cornerRadius:cornerRadius - 1];
        CGContextAddPath(context, path);
        CGContextClip(context);
        
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        CGFloat components[8];
        if (highlighted) {
            components[0] = 0.216; components[1] = 0.471; components[2] = 0.871; components[3] = 1;
            components[4] = 0.059; components[5] = 0.353; components[6] = 0.839; components[7] = 1;
        } else {
            components[0] = 0.314; components[1] = 0.314; components[2] = 0.314; components[3] = 1;
            components[4] = 0.165; components[5] = 0.165; components[6] = 0.165; components[7] = 1;
        }
        CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace, components, NULL, 2);
        
        CGPoint startPoint = CGPointMake(rect.origin.x, rect.origin.y + 2);
        CGPoint endPoint = CGPointMake(rect.origin.x, rect.origin.y + rect.size.height / 2 - 2);
        
        CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, kCGGradientDrawsAfterEndLocation);
        
        CGGradientRelease(gradient);
        CGColorSpaceRelease(colorSpace);
        CGPathRelease(path);
    } CGContextRestoreGState(context);
    
    // Lower body
    CGContextSaveGState(context); {
        CGMutablePathRef path = [self lowerTailPathInRect:CGRectMake(rect.origin.x, rect.origin.y + rect.size.height / 2, rect.size.width - 1, rect.size.height / 2 - 1) cornerRadius:cornerRadius - 1];
        CGContextAddPath(context, path);
        CGContextClip(context);
        
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        CGFloat components[8];
        if (highlighted) {
            components[0] = 0.047; components[1] = 0.306; components[2] = 0.827; components[3] = 1;
            components[4] = 0.027; components[5] = 0.176; components[6] = 0.737; components[7] = 1;
        } else {
            components[0] = 0.102; components[1] = 0.102; components[2] = 0.102; components[3] = 1;
            components[4] = 0;     components[5] = 0;     components[6] = 0;     components[7] = 1;
        }
        CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace, components, NULL, 2);
        
        CGPoint startPoint = CGPointMake(rect.origin.x, rect.origin.y + rect.size.height / 2);
        CGPoint endPoint = CGPointMake(rect.origin.x, rect.origin.y + rect.size.height - 1);
        
        CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, kCGGradientDrawsAfterEndLocation);
        
        CGGradientRelease(gradient);
        CGColorSpaceRelease(colorSpace);
        CGPathRelease(path);
    } CGContextRestoreGState(context);
}

- (void)drawBodyInRect:(CGRect)rect firstItem:(BOOL)firstItem lastItem:(BOOL)lastItem highlighted:(BOOL)highlighted
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // Border
    CGContextSaveGState(context); {
        CGMutablePathRef path = [self bodyPathInRect:rect];
        CGContextAddPath(context, path);
        
        CGContextSetRGBFillColor(context, 0, 0, 0, 1.0);
        CGContextFillPath(context);
        
        CGPathRelease(path);
    } CGContextRestoreGState(context);
    
    // Highlight
    CGContextSaveGState(context); {
        CGMutablePathRef path = [self bodyPathInRect:CGRectMake(rect.origin.x, rect.origin.y + 1, rect.size.width, rect.size.height - 2)];
        CGContextAddPath(context, path);
        
        if (highlighted) {
            CGContextSetRGBFillColor(context, 0.384, 0.608, 0.906, 1.0);
        } else {
            CGContextSetRGBFillColor(context, 0.471, 0.471, 0.471, 1.0);
        }
        CGContextFillPath(context);
        
        CGPathRelease(path);
    } CGContextRestoreGState(context);
    
    // Upper body
    CGContextSaveGState(context); {
        CGMutablePathRef path = [self bodyPathInRect:CGRectMake(rect.origin.x, rect.origin.y + 2, rect.size.width, rect.size.height / 2 - 2)];
        CGContextAddPath(context, path);
        CGContextClip(context);
        
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        CGFloat components[8];
        if (highlighted) {
            components[0] = 0.216; components[1] = 0.471; components[2] = 0.871; components[3] = 1;
            components[4] = 0.059; components[5] = 0.353; components[6] = 0.839; components[7] = 1;
        } else {
            components[0] = 0.314; components[1] = 0.314; components[2] = 0.314; components[3] = 1;
            components[4] = 0.165; components[5] = 0.165; components[6] = 0.165; components[7] = 1;
        }
        CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace, components, NULL, 2);
        
        CGPoint startPoint = CGPointMake(rect.origin.x, rect.origin.y + 2);
        CGPoint endPoint = CGPointMake(rect.origin.x, rect.origin.y + rect.size.height / 2 - 2);
        
        CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, kCGGradientDrawsAfterEndLocation);
        
        CGGradientRelease(gradient);
        CGColorSpaceRelease(colorSpace);
        CGPathRelease(path);
    } CGContextRestoreGState(context);
    
    // Lower body
    CGContextSaveGState(context); {
        CGMutablePathRef path = [self bodyPathInRect:CGRectMake(rect.origin.x, rect.origin.y + rect.size.height / 2, rect.size.width, rect.size.height / 2 - 1)];
        CGContextAddPath(context, path);
        CGContextClip(context);
        
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        CGFloat components[8];
        if (highlighted) {
            components[0] = 0.047; components[1] = 0.306; components[2] = 0.827; components[3] = 1;
            components[4] = 0.027; components[5] = 0.176; components[6] = 0.737; components[7] = 1;
        } else {
            components[0] = 0.102; components[1] = 0.102; components[2] = 0.102; components[3] = 1;
            components[4] = 0;     components[5] = 0;     components[6] = 0;     components[7] = 1;
        }
        CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace, components, NULL, 2);
        
        CGPoint startPoint = CGPointMake(rect.origin.x, rect.origin.y + rect.size.height / 2);
        CGPoint endPoint = CGPointMake(rect.origin.x, rect.origin.y + rect.size.height - 1);
        
        CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, kCGGradientDrawsAfterEndLocation);
        
        CGGradientRelease(gradient);
        CGColorSpaceRelease(colorSpace);
        CGPathRelease(path);
    } CGContextRestoreGState(context);
    
    // Draw separator
    if (!firstItem) {
        [self drawLeftSeparatorInRect:CGRectMake(rect.origin.x, rect.origin.y + 2, 1, rect.size.height - 3) highlighted:highlighted];
    }
    if (!lastItem) {
        [self drawRightSeparatorInRect:CGRectMake(rect.origin.x + rect.size.width - 1, rect.origin.y + 2, 1, rect.size.height - 3) highlighted:highlighted];
    }
}

- (void)drawLeftSeparatorInRect:(CGRect)rect highlighted:(BOOL)highlighted
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // Left separator
    CGContextSaveGState(context); {
        CGContextAddRect(context, rect);
        CGContextClip(context);
        
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        CGFloat components[16];
        if (highlighted) {
            components[0]  = 0.22; components[1]  = 0.47; components[2]  = 0.87; components[3]  = 1;
            components[4]  = 0.12; components[5]  = 0.50; components[6]  = 0.89; components[7]  = 1;
            components[8]  = 0.09; components[9]  = 0.47; components[10] = 0.88; components[11] = 1;
            components[12] = 0.03; components[13] = 0.18; components[14] = 0.74; components[15] = 1;
        } else {
            components[0]  = 0.31; components[1]  = 0.31; components[2]  = 0.31; components[3]  = 1;
            components[4]  = 0.31; components[5]  = 0.31; components[6]  = 0.31; components[7]  = 1;
            components[8]  = 0.24; components[9]  = 0.24; components[10] = 0.24; components[11] = 1;
            components[12] = 0.05; components[13] = 0.05; components[14] = 0.05; components[15] = 1;
        }
        CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace, components, NULL, 4);
        
        CGPoint startPoint = CGPointMake(rect.origin.x, rect.origin.y);
        CGPoint endPoint = CGPointMake(rect.origin.x, rect.origin.y + rect.size.height);
        
        CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, kCGGradientDrawsAfterEndLocation);
        
        CGGradientRelease(gradient);
        CGColorSpaceRelease(colorSpace);
    } CGContextRestoreGState(context);
}

- (void)drawRightSeparatorInRect:(CGRect)rect highlighted:(BOOL)highlighted
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // Right separator
    CGContextSaveGState(context); {
        CGContextAddRect(context, rect);
        CGContextClip(context);
        
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        CGFloat components[16];
        if (highlighted) {
            components[0]  = 0.22; components[1]  = 0.47; components[2]  = 0.87; components[3]  = 1;
            components[4]  = 0.03; components[5]  = 0.18; components[6]  = 0.72; components[7]  = 1;
            components[8]  = 0.02; components[9]  = 0.15; components[10] = 0.73; components[11] = 1;
            components[12] = 0.03; components[13] = 0.17; components[14] = 0.72; components[15] = 1;
        } else {
            components[0]  = 0.31; components[1]  = 0.31; components[2]  = 0.31; components[3]  = 1;
            components[4]  = 0.06; components[5]  = 0.06; components[6]  = 0.06; components[7]  = 1;
            components[8]  = 0.04; components[9]  = 0.04; components[10] = 0.04; components[11] = 1;
            components[12] = 0;    components[13] = 0;    components[14] = 0;    components[15] = 1;
        }
        CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace, components, NULL, 4);
        
        CGPoint startPoint = CGPointMake(rect.origin.x, rect.origin.y);
        CGPoint endPoint = CGPointMake(rect.origin.x, rect.origin.y + rect.size.height);
        
        CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, kCGGradientDrawsAfterEndLocation);
        
        CGGradientRelease(gradient);
        CGColorSpaceRelease(colorSpace);
    } CGContextRestoreGState(context);
}

@end
