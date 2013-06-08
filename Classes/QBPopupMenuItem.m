/*
 Copyright (c) 2013 Katsuma Tanaka
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

#import "QBPopupMenuItem.h"

@interface QBPopupMenuItem ()

+ (UIFont *)fontForTitle;
+ (UIFont *)fontForTitleWithImage;

- (instancetype)initWithTitle:(NSString *)title image:(UIImage *)image customView:(UIView *)customView target:(id)target action:(SEL)action;

@end

@implementation QBPopupMenuItem

+ (UIFont *)fontForTitle
{
    return [UIFont boldSystemFontOfSize:17];
}

+ (UIFont *)fontForTitleWithImage
{
    return [UIFont boldSystemFontOfSize:12];
}

+ (instancetype)itemWithTitle:(NSString *)title target:(id)target action:(SEL)action
{
    return [[self alloc] initWithTitle:title target:target action:action];
}

+ (instancetype)itemWithImage:(UIImage *)image target:(id)target action:(SEL)action
{
    return [[self alloc] initWithImage:image target:target action:action];
}

+ (instancetype)itemWithTitle:(NSString *)title image:(UIImage *)image target:(id)target action:(SEL)action
{
    return [[self alloc] initWithTitle:title image:image target:target action:action];
}

+ (instancetype)itemWithCustomView:(UIView *)customView target:(id)target action:(SEL)action
{
    return [[self alloc] initWithCustomView:customView target:target action:action];
}

- (instancetype)initWithTitle:(NSString *)title target:(id)target action:(SEL)action
{
    return [self initWithTitle:title image:nil customView:nil target:target action:action];
}

- (instancetype)initWithImage:(UIImage *)image target:(id)target action:(SEL)action
{
    return [self initWithTitle:nil image:image customView:nil target:target action:action];
}

- (instancetype)initWithTitle:(NSString *)title image:(UIImage *)image target:(id)target action:(SEL)action
{
    return [self initWithTitle:title image:image customView:nil target:target action:action];
}

- (instancetype)initWithCustomView:(UIView *)customView target:(id)target action:(SEL)action
{
    return [self initWithTitle:nil image:nil customView:customView target:target action:action];
}

- (instancetype)initWithTitle:(NSString *)title image:(UIImage *)image customView:(UIView *)customView target:(id)target action:(SEL)action
{
    self = [super init];
    
    if (self) {
        self.title = title;
        self.image = image;
        self.customView = customView;
        self.target = target;
        self.action = action;
        
        self.enabled = YES;
        self.width = 0;
        self.font = nil;
    }
    
    return self;
}



#pragma mark -

- (CGSize)actualSize
{
    CGFloat width = 0, height = 0;
    
    if (self.customView) {
        width = self.customView.frame.size.width;
        height = self.customView.frame.size.height;
    } else {
        if (self.width > 0) {
            width = self.width;
            height = 50;
        } else {
            height = 50;
            
            if (self.title && self.image) {
                UIFont *font = (self.font) ? self.font : [QBPopupMenuItem fontForTitleWithImage];
                
                CGSize titleSize = [self.title sizeWithFont:font];
                CGSize imageSize = self.image.size;
                
                if (titleSize.width > imageSize.width) {
                    width = titleSize.width;
                } else {
                    width = imageSize.width;
                }
            } else if (self.title) {
                UIFont *font = (self.font) ? self.font : [QBPopupMenuItem fontForTitle];
                
                CGSize titleSize = [self.title sizeWithFont:font];
                width = titleSize.width;
            } else if (self.image) {
                width = self.image.size.width;
            }
            
            // フォントからアイテムの適当な間隔を計算
            width = width + ([[self actualFont] pointSize] - 4) * 2;
        }
    }
    
    return CGSizeMake(width, height);
}

- (UIFont *)actualFont
{
    UIFont *font = self.font;
    
    if (font == nil) {
        if (self.title && self.image) {
            font = [QBPopupMenuItem fontForTitleWithImage];
        } else {
            font = [QBPopupMenuItem fontForTitle];
        }
    }
    
    return font;
}

- (void)performAction
{
    if ([self.target respondsToSelector:self.action]) {
        [self.target performSelectorOnMainThread:self.action withObject:self waitUntilDone:YES];
    }
}

@end
