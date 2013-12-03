//
//  QBPopupMenuItemView.m
//  QBPopupMenu
//
//  Created by Tanaka Katsuma on 2013/11/22.
//  Copyright (c) 2013年 Katsuma Tanaka. All rights reserved.
//

#import "QBPopupMenuItemView.h"

#import "QBPopupMenu.h"
#import "QBPopupMenuItem.h"

@interface QBPopupMenuItemView ()

@property (nonatomic, strong, readwrite) UIButton *button;

@end

@implementation QBPopupMenuItemView

+ (instancetype)itemViewWithItem:(QBPopupMenuItem *)item
{
    return [[self alloc] initWithItem:item];
}

- (instancetype)initWithItem:(QBPopupMenuItem *)item
{
    self = [super initWithFrame:CGRectZero];
    
    if (self) {
        // View settings
        self.opaque = NO;
        self.backgroundColor = [UIColor clearColor];
        self.clipsToBounds = YES;
        
        // Create button
        self.button = ({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = self.bounds;
            button.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
            [button addTarget:self action:@selector(performAction) forControlEvents:UIControlEventTouchUpInside];
            
            // Set style
            button.contentMode = UIViewContentModeScaleAspectFit;
            button.titleLabel.font = [UIFont systemFontOfSize:14.0];
            button.imageView.contentMode = UIViewContentModeScaleAspectFit;
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
            
            button;
        });
        [self addSubview:self.button];
        
        // Property settings
        self.item = item;
    }
    
    return self;
}


#pragma mark - Accessors

- (void)setImage:(UIImage *)image
{
    [self.button setBackgroundImage:image forState:UIControlStateNormal];
}

- (UIImage *)image
{
    return [self.button backgroundImageForState:UIControlStateNormal];
}

- (void)setHighlightedImage:(UIImage *)highlightedImage
{
    [self.button setBackgroundImage:highlightedImage forState:UIControlStateHighlighted];
}

- (UIImage *)highlightedImage
{
    return [self.button backgroundImageForState:UIControlStateHighlighted];
}

- (void)setItem:(QBPopupMenuItem *)item
{
    _item = item;
    
    // Update
    [self configureButton];
}


#pragma mark - Actions

- (void)performAction
{
    if (self.item.target && self.item.action) {
        [self.item.target performSelector:self.item.action withObject:nil afterDelay:0];
    }
    
    // Close popup menu
    [self.popupMenu dismissAnimated:YES];
}


#pragma mark - Updating the View

- (void)sizeToFit
{
    CGSize size = [self sizeThatFits:CGSizeZero];
    
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

- (CGSize)sizeThatFits:(CGSize)size
{
    CGSize buttonSize = [self.button sizeThatFits:CGSizeZero];
    buttonSize.width += 10 * 2;
    
    return buttonSize;
}

- (void)configureButton
{
    // Title
    [self.button setTitle:self.item.title forState:UIControlStateNormal];
    
    // Image
    [self.button setImage:self.item.image forState:UIControlStateNormal];
    [self.button setImage:self.item.image forState:UIControlStateHighlighted];
    
    // Content edge insets
    if (self.item.title && self.item.image) {
        self.button.titleEdgeInsets = UIEdgeInsetsMake(0, 6, 0, 0);
        self.button.imageEdgeInsets = UIEdgeInsetsMake(0, -3, 0, 0);
    } else {
        self.button.titleEdgeInsets = UIEdgeInsetsZero;
        self.button.imageEdgeInsets = UIEdgeInsetsZero;
    }
}

@end
