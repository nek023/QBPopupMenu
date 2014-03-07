//
//  QBPopupMenu.m
//  QBPopupMenu
//
//  Created by Tanaka Katsuma on 2013/11/22.
//  Copyright (c) 2013年 Katsuma Tanaka. All rights reserved.
//

#import "QBPopupMenu.h"

#import "QBPopupMenuOverlayView.h"
#import "QBPopupMenuItemView.h"
#import "QBPopupMenuPagenatorView.h"

static const NSTimeInterval kQBPopupMenuAnimationDuration = 0.2;

@interface QBPopupMenu ()

@property (nonatomic, assign, getter = isVisible, readwrite) BOOL visible;
@property (nonatomic, strong) QBPopupMenuOverlayView *overlayView;

@property (nonatomic, weak) UIView *view;
@property (nonatomic, assign) CGRect targetRect;

@property (nonatomic, assign) NSUInteger page;
@property (nonatomic, assign) QBPopupMenuArrowDirection actualArrorDirection;
@property (nonatomic, assign) CGPoint arrowPoint;

@property (nonatomic, strong) NSMutableArray *itemViews;
@property (nonatomic, strong) NSMutableArray *groupedItemViews;
@property (nonatomic, strong) NSMutableArray *visibleItemViews;

@end

@implementation QBPopupMenu

+ (Class)itemViewClass
{
    return [QBPopupMenuItemView class];
}

+ (Class)pagenatorViewClass
{
    return [QBPopupMenuPagenatorView class];
}

+ (instancetype)popupMenuWithItems:(NSArray *)items
{
    return [[self alloc] initWithItems:items];
}

- (instancetype)initWithItems:(NSArray *)items
{
    self = [super initWithFrame:CGRectZero];
    
    if (self) {
        // View settings
        self.opaque = NO;
        self.backgroundColor = [UIColor clearColor];
        self.clipsToBounds = YES;
        
        // Property settings
        self.items = items;
        self.height = 36;
        self.cornerRadius = 8;
        self.arrowSize = 9;
        self.arrowDirection = QBPopupMenuArrowDirectionDefault;
        self.popupMenuInsets = UIEdgeInsetsMake(10, 10, 10, 10);
        self.margin = 2;
        
        self.color = [[UIColor blackColor] colorWithAlphaComponent:0.8];
        self.highlightedColor = [[UIColor darkGrayColor] colorWithAlphaComponent:0.8];
    }
    
    return self;
}


#pragma mark - Accessors

- (void)setItems:(NSArray *)items
{
    _items = items;
    
    // Create item views
    [self createItemViews];
}

- (void)setHeight:(CGFloat)height
{
    _height = height;
    
    // Update view
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}


#pragma mark - Managing Popup Menu

- (void)showInView:(UIView *)view targetRect:(CGRect)targetRect animated:(BOOL)animated
{
    if ([self isVisible]) {
        return;
    }
    
    self.view = view;
    self.targetRect = targetRect;
    
    // Decide arrow direction
    QBPopupMenuArrowDirection arrowDirection = self.arrowDirection;
    
    if (arrowDirection == QBPopupMenuArrowDirectionDefault) {
        if ((targetRect.origin.y - (self.height + self.arrowSize)) >= self.popupMenuInsets.top) {
            arrowDirection = QBPopupMenuArrowDirectionDown;
        }
        else if ((targetRect.origin.y + targetRect.size.height + (self.height + self.arrowSize)) < (view.bounds.size.height - self.popupMenuInsets.bottom)) {
            arrowDirection = QBPopupMenuArrowDirectionUp;
        }
        else {
            CGFloat left = targetRect.origin.x - self.popupMenuInsets.left;
            CGFloat right = view.bounds.size.width - (targetRect.origin.x + targetRect.size.width + self.popupMenuInsets.right);
            
            arrowDirection = (left > right) ? QBPopupMenuArrowDirectionLeft : QBPopupMenuArrowDirectionRight;
        }
    }
    
    self.actualArrorDirection = arrowDirection;
    
    // Calculate width
    CGFloat maximumWidth = 0;
    CGFloat minimumWidth = 40;
    
    switch (arrowDirection) {
        case QBPopupMenuArrowDirectionDown:
        case QBPopupMenuArrowDirectionUp:
            maximumWidth = view.bounds.size.width - (self.popupMenuInsets.left + self.popupMenuInsets.right);
            if (maximumWidth < minimumWidth) maximumWidth = minimumWidth;
            break;
            
        case QBPopupMenuArrowDirectionLeft:
            maximumWidth = targetRect.origin.x - self.popupMenuInsets.left;
            break;
            
        case QBPopupMenuArrowDirectionRight:
            maximumWidth = view.bounds.size.width - (targetRect.origin.x + targetRect.size.width + self.popupMenuInsets.right);
            break;
            
        default:
            break;
    }
    
    // Layout item views
    [self groupItemViewsWithMaximumWidth:maximumWidth];
    
    // Show page
    [self showPage:0];
    
    // Create overlay view
    self.overlayView = ({
        QBPopupMenuOverlayView *overlayView = [[QBPopupMenuOverlayView alloc] initWithFrame:view.bounds];
        overlayView.popupMenu = self;
        
        overlayView;
    });
    
    // Delegate
    if (self.delegate && [self.delegate respondsToSelector:@selector(popupMenuWillAppear:)]) {
        [self.delegate popupMenuWillAppear:self];
    }
    
    // Show
    [view addSubview:self.overlayView];
    
    if (animated) {
        self.alpha = 0;
        [self.overlayView addSubview:self];
        
        [UIView animateWithDuration:kQBPopupMenuAnimationDuration animations:^(void) {
            self.alpha = 1.0;
        } completion:^(BOOL finished) {
            self.visible = YES;
            
            // Delegate
            if (self.delegate && [self.delegate respondsToSelector:@selector(popupMenuDidAppear:)]) {
                [self.delegate popupMenuDidAppear:self];
            }
        }];
    } else {
        [self.overlayView addSubview:self];
        
        self.visible = YES;
        
        // Delegate
        if (self.delegate && [self.delegate respondsToSelector:@selector(popupMenuDidAppear:)]) {
            [self.delegate popupMenuDidAppear:self];
        }
    }
}

- (void)dismissAnimated:(BOOL)animated
{
    if (![self isVisible]) {
        return;
    }
    
    // Delegate
    if (self.delegate && [self.delegate respondsToSelector:@selector(popupMenuWillDisappear:)]) {
        [self.delegate popupMenuWillDisappear:self];
    }
    
    if (animated) {
        [UIView animateWithDuration:kQBPopupMenuAnimationDuration animations:^{
            self.alpha = 0;
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
            [self.overlayView removeFromSuperview];
            
            self.visible = NO;
            
            // Delegate
            if (self.delegate && [self.delegate respondsToSelector:@selector(popupMenuDidDisappear:)]) {
                [self.delegate popupMenuDidDisappear:self];
            }
        }];
    } else {
        [self removeFromSuperview];
        [self.overlayView removeFromSuperview];
        
        self.visible = NO;
        
        // Delegate
        if (self.delegate && [self.delegate respondsToSelector:@selector(popupMenuDidDisappear:)]) {
            [self.delegate popupMenuDidDisappear:self];
        }
    }
}

- (void)updateWithTargetRect:(CGRect)targetRect
{
    self.targetRect = targetRect;
    
    [self updatePopupMenuFrameAndArrowPosition];
    [self updatePopupMenuImage];
}

- (void)showPreviousPage
{
    [self showPage:(self.page - 1)];
}

- (void)showNextPage
{
    [self showPage:(self.page + 1)];
}

- (void)showPage:(NSUInteger)page
{
    self.page = page;
    
    [self updateVisibleItemViewsWithPage:page];
    [self layoutVisibleItemViews];
    [self updatePopupMenuFrameAndArrowPosition];
    [self updatePopupMenuImage];
}


#pragma mark - Updating Content

- (void)createItemViews
{
    NSMutableArray *itemViews = [NSMutableArray array];
    
    for (QBPopupMenuItem *item in self.items) {
        QBPopupMenuItemView *itemView = [[[self class] itemViewClass] itemViewWithItem:item];
        itemView.popupMenu = self;
        
        [itemViews addObject:itemView];
    }
    
    self.itemViews = itemViews;
}

- (void)resetItemViewState:(QBPopupMenuItemView *)itemView
{
    // NOTE: Reset properties related to the size of the button before colling sizeThatFits: of item view,
    //       or the size of the view will change from the second time.
    itemView.button.contentEdgeInsets = UIEdgeInsetsZero;
    itemView.image = nil;
    itemView.highlightedImage = nil;
}

- (void)groupItemViewsWithMaximumWidth:(CGFloat)maximumWidth
{
    NSMutableArray *groupedItemViews = [NSMutableArray array];
    
    CGFloat pagenatorWidth = [QBPopupMenuPagenatorView pagenatorWidth];
    
    // Create new array
    NSMutableArray *itemViews = [NSMutableArray array];
    CGFloat width = 0;
    if (self.actualArrorDirection == QBPopupMenuArrowDirectionLeft || self.actualArrorDirection == QBPopupMenuArrowDirectionRight) {
        width += self.arrowSize;
    }
    
    for (QBPopupMenuItemView *itemView in self.itemViews) {
        // Clear state
        [self resetItemViewState:itemView];
        
        CGSize itemViewSize = [itemView sizeThatFits:CGSizeZero];
        
        if (itemViews.count > 0 && width + itemViewSize.width + pagenatorWidth > maximumWidth) {
            [groupedItemViews addObject:[itemViews copy]];
            
            // Create new array
            itemViews = [NSMutableArray array];
            width = pagenatorWidth;
            if (self.actualArrorDirection == QBPopupMenuArrowDirectionLeft || self.actualArrorDirection == QBPopupMenuArrowDirectionRight) {
                width += self.arrowSize;
            }
        }
        
        [itemViews addObject:itemView];
        width += itemViewSize.width;
    }
    
    if (itemViews.count > 0) {
        [groupedItemViews addObject:[itemViews copy]];
    }
    
    self.groupedItemViews = groupedItemViews;
}

- (void)updateVisibleItemViewsWithPage:(NSUInteger)page
{
    // Remove all visible item views
    for (UIView *view in self.visibleItemViews) {
        [view removeFromSuperview];
    }
    
    // Add item views
    NSMutableArray *visibleItemViews = [NSMutableArray array];
    NSUInteger numberOfPages = self.groupedItemViews.count;
    
    if (numberOfPages > 1 && page != 0) {
        QBPopupMenuPagenatorView *leftPagenatorView = [[[self class] pagenatorViewClass] leftPagenatorViewWithTarget:self action:@selector(showPreviousPage)];
        
        [self addSubview:leftPagenatorView];
        [visibleItemViews addObject:leftPagenatorView];
    }
    
    NSArray *itemViews = [self.groupedItemViews objectAtIndex:page];
    
    for (QBPopupMenuItemView *itemView in itemViews) {
        [self addSubview:itemView];
        [visibleItemViews addObject:itemView];
    }
    
    if (numberOfPages > 1 && page != numberOfPages - 1) {
        QBPopupMenuPagenatorView *rightPagenatorView = [[[self class] pagenatorViewClass] rightPagenatorViewWithTarget:self action:@selector(showNextPage)];
        
        [self addSubview:rightPagenatorView];
        [visibleItemViews addObject:rightPagenatorView];
    }
    
    self.visibleItemViews = visibleItemViews;
}

- (void)layoutVisibleItemViews
{
    CGFloat height = self.height;
    if (self.actualArrorDirection == QBPopupMenuArrowDirectionDown || self.actualArrorDirection == QBPopupMenuArrowDirectionUp) {
        height += self.arrowSize;
    }
    
    CGFloat offset = 0;
    for (NSInteger i = 0; i < self.visibleItemViews.count; i++) {
        QBPopupMenuItemView *itemView = [self.visibleItemViews objectAtIndex:i];
        
        // Clear state
        [self resetItemViewState:itemView];
        
        // Set item view insets
        if (i == 0 && self.actualArrorDirection == QBPopupMenuArrowDirectionLeft) {
            itemView.button.contentEdgeInsets = UIEdgeInsetsMake(0, self.arrowSize, 0, 0);
        }
        else if (i == self.visibleItemViews.count - 1 && self.actualArrorDirection == QBPopupMenuArrowDirectionRight) {
            itemView.button.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, self.arrowSize);
        }
        else if (self.actualArrorDirection == QBPopupMenuArrowDirectionDown) {
            itemView.button.contentEdgeInsets = UIEdgeInsetsMake(0, 0, self.arrowSize, 0);
        }
        else if (self.actualArrorDirection == QBPopupMenuArrowDirectionUp) {
            itemView.button.contentEdgeInsets = UIEdgeInsetsMake(self.arrowSize, 0, 0, 0);
        }
        
        // Set item view frame
        CGSize size = [itemView sizeThatFits:CGSizeZero];
        CGFloat width = size.width;
        
        if ((i == 0 && self.actualArrorDirection == QBPopupMenuArrowDirectionLeft) ||
            (i == self.visibleItemViews.count - 1 && self.actualArrorDirection == QBPopupMenuArrowDirectionRight)) {
            width += self.arrowSize;
        }
        
        itemView.frame = CGRectMake(offset, 0, width, height);
        
        offset += width;
    }
}

- (void)updatePopupMenuFrameAndArrowPosition
{
    // Calculate popup frame
    CGRect popupMenuFrame = CGRectZero;
    CGPoint arrowPoint = CGPointZero;
    
    UIView *itemView = [self.visibleItemViews lastObject];
    CGFloat width = itemView.frame.origin.x + itemView.frame.size.width;
    CGFloat height = itemView.frame.origin.y + itemView.frame.size.height;
    
    switch (self.actualArrorDirection) {
        case QBPopupMenuArrowDirectionDown:
        {
            popupMenuFrame = CGRectMake(self.targetRect.origin.x + (self.targetRect.size.width - width) / 2.0,
                                        self.targetRect.origin.y - (height + self.margin),
                                        width,
                                        height);
            
            if (popupMenuFrame.origin.x + popupMenuFrame.size.width > self.view.frame.size.width - self.popupMenuInsets.right) {
                popupMenuFrame.origin.x = self.view.frame.size.width - self.popupMenuInsets.right - popupMenuFrame.size.width;
            }
            if (popupMenuFrame.origin.x < self.popupMenuInsets.left) {
                popupMenuFrame.origin.x = self.popupMenuInsets.left;
            }
            
            CGFloat centerOfTargetRect = self.targetRect.origin.x + self.targetRect.size.width / 2.0;
            arrowPoint = CGPointMake(MAX(self.cornerRadius, MIN(popupMenuFrame.size.width - self.cornerRadius, centerOfTargetRect - popupMenuFrame.origin.x)),
                                     popupMenuFrame.size.height);
        }
            break;
            
        case QBPopupMenuArrowDirectionUp:
        {
            popupMenuFrame = CGRectMake(self.targetRect.origin.x + (self.targetRect.size.width - width) / 2.0,
                                        self.targetRect.origin.y + (self.targetRect.size.height + self.margin),
                                        width,
                                        height);
            
            if (popupMenuFrame.origin.x + popupMenuFrame.size.width > self.view.frame.size.width - self.popupMenuInsets.right) {
                popupMenuFrame.origin.x = self.view.frame.size.width - self.popupMenuInsets.right - popupMenuFrame.size.width;
            }
            if (popupMenuFrame.origin.x < self.popupMenuInsets.left) {
                popupMenuFrame.origin.x = self.popupMenuInsets.left;
            }
            
            CGFloat centerOfTargetRect = self.targetRect.origin.x + self.targetRect.size.width / 2.0;
            arrowPoint = CGPointMake(MAX(self.cornerRadius, MIN(popupMenuFrame.size.width - self.cornerRadius, centerOfTargetRect - popupMenuFrame.origin.x)),
                                     0);
        }
            break;
            
        case QBPopupMenuArrowDirectionLeft:
        {
            popupMenuFrame = CGRectMake(self.targetRect.origin.x + (self.targetRect.size.width + self.margin),
                                        self.targetRect.origin.y + (self.targetRect.size.height - height) / 2.0,
                                        width,
                                        height);
            
            if (popupMenuFrame.origin.y + popupMenuFrame.size.height > self.view.frame.size.height - self.popupMenuInsets.bottom) {
                popupMenuFrame.origin.y = self.view.frame.size.height - self.popupMenuInsets.bottom - popupMenuFrame.size.height;
            }
            if (popupMenuFrame.origin.y < self.popupMenuInsets.top) {
                popupMenuFrame.origin.y = self.popupMenuInsets.top;
            }
            
            CGFloat centerOfTargetRect = self.targetRect.origin.y + self.targetRect.size.height / 2.0;
            arrowPoint = CGPointMake(0,
                                     MAX(self.cornerRadius, MIN(popupMenuFrame.size.height - self.cornerRadius, centerOfTargetRect - popupMenuFrame.origin.y)));
        }
            break;
            
        case QBPopupMenuArrowDirectionRight:
        {
            popupMenuFrame = CGRectMake(self.targetRect.origin.x - (width + self.margin),
                                        self.targetRect.origin.y + (self.targetRect.size.height - height) / 2.0,
                                        width,
                                        height);
            
            if (popupMenuFrame.origin.y + popupMenuFrame.size.height > self.view.frame.size.height - self.popupMenuInsets.bottom) {
                popupMenuFrame.origin.y = self.view.frame.size.height - self.popupMenuInsets.bottom - popupMenuFrame.size.height;
            }
            if (popupMenuFrame.origin.y < self.popupMenuInsets.top) {
                popupMenuFrame.origin.y = self.popupMenuInsets.top;
            }
            
            CGFloat centerOfTargetRect = self.targetRect.origin.y + self.targetRect.size.height / 2.0;
            arrowPoint = CGPointMake(popupMenuFrame.size.width,
                                     MAX(self.cornerRadius, MIN(popupMenuFrame.size.height - self.cornerRadius, centerOfTargetRect - popupMenuFrame.origin.y)));
        }
            break;
            
        default:
            break;
    }
    
    // Round coordinates
    popupMenuFrame = CGRectMake(round(popupMenuFrame.origin.x),
                                round(popupMenuFrame.origin.y),
                                round(popupMenuFrame.size.width),
                                round(popupMenuFrame.size.height));
    arrowPoint = CGPointMake(round(arrowPoint.x),
                             round(arrowPoint.y));
    
    self.frame = popupMenuFrame;
    self.arrowPoint = arrowPoint;
}

- (void)updatePopupMenuImage
{
    UIImage *popupMenuImage = [self popupMenuImageWithHighlighted:NO];
    UIImage *popupMenuHighlightedImage = [self popupMenuImageWithHighlighted:YES];
    
    for (NSInteger i = 0; i < self.visibleItemViews.count; i++) {
        QBPopupMenuItemView *itemView = [self.visibleItemViews objectAtIndex:i];
        
        UIImage *image = [self cropImageFromImage:popupMenuImage inRect:itemView.frame];
        UIImage *highlightedImage = [self cropImageFromImage:popupMenuHighlightedImage inRect:itemView.frame];
        
        itemView.image = image;
        itemView.highlightedImage = highlightedImage;
    }
}


#pragma mark - Creating Popup Menu Image

- (UIImage *)cropImageFromImage:(UIImage *)image inRect:(CGRect)rect
{
    CGFloat scale = [[UIScreen mainScreen] scale];
    CGRect scaledRect = CGRectMake(rect.origin.x * scale, rect.origin.y * scale, rect.size.width * scale, rect.size.height * scale);
    
    CGImageRef imageRef = CGImageCreateWithImageInRect(image.CGImage, scaledRect);
    UIImage *croppedImage = [UIImage imageWithCGImage:imageRef scale:scale orientation:UIImageOrientationUp];
    CGImageRelease(imageRef);
    
    return croppedImage;
}

- (UIImage *)popupMenuImageWithHighlighted:(BOOL)highlighted
{
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, 0);
    
    // Draw body
    CGFloat y = (self.actualArrorDirection == QBPopupMenuArrowDirectionUp) ? self.arrowSize : 0;
    CGFloat height = self.height;
    
    for (NSInteger i = 0; i < self.visibleItemViews.count; i++) {
        QBPopupMenuItemView *itemView = [self.visibleItemViews objectAtIndex:i];
        CGRect frame = itemView.frame;
        
        if (i == 0) {
            if (self.visibleItemViews.count == 1) {
                CGRect headRect;
                CGRect bodyRect;
                CGRect tailRect;
                if (self.actualArrorDirection == QBPopupMenuArrowDirectionLeft) {
                    headRect = CGRectMake(self.arrowSize, y, self.cornerRadius, height);
                    bodyRect = CGRectMake(self.arrowSize + self.cornerRadius, y, frame.size.width - (self.arrowSize + self.cornerRadius * 2.0), height);
                    tailRect = CGRectMake(frame.size.width - self.cornerRadius, y, self.cornerRadius, height);
                }
                else if (self.actualArrorDirection == QBPopupMenuArrowDirectionRight) {
                    headRect = CGRectMake(0, y, self.cornerRadius, height);
                    bodyRect = CGRectMake(self.cornerRadius, y, frame.size.width - (self.arrowSize + self.cornerRadius * 2.0), height);
                    tailRect = CGRectMake(frame.size.width - (self.arrowSize + self.cornerRadius), y, self.cornerRadius, height);
                }
                else {
                    headRect = CGRectMake(0, y, self.cornerRadius, height);
                    bodyRect = CGRectMake(self.cornerRadius, y, frame.size.width - self.cornerRadius * 2.0, height);
                    tailRect = CGRectMake(frame.size.width - self.cornerRadius, y, self.cornerRadius, height);
                }
                
                // Draw head
                [self drawHeadInRect:headRect cornerRadius:self.cornerRadius highlighted:highlighted];
                
                // Draw body
                [self drawBodyInRect:bodyRect firstItem:YES lastItem:YES highlighted:highlighted];
                
                // Draw tail
                [self drawTailInRect:tailRect cornerRadius:self.cornerRadius highlighted:highlighted];
            } else {
                CGRect headRect;
                CGRect bodyRect;
                if (self.actualArrorDirection == QBPopupMenuArrowDirectionLeft) {
                    headRect = CGRectMake(self.arrowSize, y, self.cornerRadius, height);
                    bodyRect = CGRectMake(self.arrowSize + self.cornerRadius, y, frame.size.width - (self.arrowSize + self.cornerRadius), height);
                } else {
                    headRect = CGRectMake(0, y, self.cornerRadius, height);
                    bodyRect = CGRectMake(self.cornerRadius, y, frame.size.width - self.cornerRadius, height);
                }
                
                // Draw head
                [self drawHeadInRect:headRect cornerRadius:self.cornerRadius highlighted:highlighted];
                
                // Draw body
                [self drawBodyInRect:bodyRect firstItem:YES lastItem:NO highlighted:highlighted];
            }
        }
        else if (i == self.visibleItemViews.count - 1) {
            CGRect bodyRect;
            CGRect tailRect;
            if (self.actualArrorDirection == QBPopupMenuArrowDirectionRight) {
                bodyRect = CGRectMake(frame.origin.x, y, frame.size.width - (self.cornerRadius + self.arrowSize), height);
                tailRect = CGRectMake(frame.origin.x + frame.size.width - (self.cornerRadius + self.arrowSize), y, self.cornerRadius, height);
            } else {
                bodyRect = CGRectMake(frame.origin.x, y, frame.size.width - self.cornerRadius, height);
                tailRect = CGRectMake(frame.origin.x + frame.size.width - self.cornerRadius, y, self.cornerRadius, height);
            }
            
            // Draw body
            [self drawBodyInRect:bodyRect firstItem:NO lastItem:YES highlighted:highlighted];
            
            // Draw tail
            [self drawTailInRect:tailRect cornerRadius:self.cornerRadius highlighted:highlighted];
        }
        else {
            // Draw body
            CGRect bodyRect = CGRectMake(frame.origin.x, y, frame.size.width, height);
            [self drawBodyInRect:bodyRect firstItem:NO lastItem:NO highlighted:highlighted];
        }
    }
    
    // Draw arrow
    [self drawArrowAtPoint:self.arrowPoint arrowSize:self.arrowSize arrowDirection:self.actualArrorDirection highlighted:highlighted];
    
    // Create image from buffer
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}


#pragma mark - Creating Paths

- (CGMutablePathRef)arrowPathInRect:(CGRect)rect direction:(QBPopupMenuArrowDirection)direction
{
    // Create arrow path
    CGMutablePathRef path = CGPathCreateMutable();
    
    switch (direction) {
        case QBPopupMenuArrowDirectionDown:
        {
            CGPathMoveToPoint(path, NULL, rect.origin.x, rect.origin.y);
            CGPathAddLineToPoint(path, NULL, rect.origin.x + rect.size.width, rect.origin.y);
            CGPathAddLineToPoint(path, NULL, rect.origin.x + rect.size.width / 2.0, rect.origin.y + rect.size.height);
            CGPathCloseSubpath(path);
        }
            break;
            
        case QBPopupMenuArrowDirectionUp:
        {
            CGPathMoveToPoint(path, NULL, rect.origin.x, rect.origin.y + rect.size.height);
            CGPathAddLineToPoint(path, NULL, rect.origin.x + rect.size.width, rect.origin.y + rect.size.height);
            CGPathAddLineToPoint(path, NULL, rect.origin.x + rect.size.width / 2.0, rect.origin.y);
            CGPathCloseSubpath(path);
        }
            break;
            
        case QBPopupMenuArrowDirectionLeft:
        {
            CGPathMoveToPoint(path, NULL, rect.origin.x + rect.size.width, rect.origin.y);
            CGPathAddLineToPoint(path, NULL, rect.origin.x + rect.size.width, rect.origin.y + rect.size.height);
            CGPathAddLineToPoint(path, NULL, rect.origin.x, rect.origin.y + rect.size.height / 2.0);
            CGPathCloseSubpath(path);
        }
            break;
            
        case QBPopupMenuArrowDirectionRight:
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

- (CGMutablePathRef)headPathInRect:(CGRect)rect cornerRadius:(CGFloat)cornerRadius
{
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, rect.origin.x, rect.origin.y + cornerRadius);
    CGPathAddArcToPoint(path, NULL, rect.origin.x, rect.origin.y, rect.origin.x + cornerRadius, rect.origin.y, cornerRadius);
    CGPathAddLineToPoint(path, NULL, rect.origin.x + rect.size.width, rect.origin.y);
    CGPathAddLineToPoint(path, NULL, rect.origin.x + rect.size.width, rect.origin.y + rect.size.height);
    CGPathAddLineToPoint(path, NULL, rect.origin.x + cornerRadius, rect.origin.y + rect.size.height);
    CGPathAddArcToPoint(path, NULL, rect.origin.x, rect.origin.y + rect.size.height, rect.origin.x, rect.origin.y + rect.size.height - cornerRadius, cornerRadius);
    CGPathCloseSubpath(path);
    
    return path;
}

- (CGMutablePathRef)tailPathInRect:(CGRect)rect cornerRadius:(CGFloat)cornerRadius
{
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, rect.origin.x, rect.origin.y);
    CGPathAddLineToPoint(path, NULL, rect.origin.x + rect.size.width - cornerRadius, rect.origin.y);
    CGPathAddArcToPoint(path, NULL, rect.origin.x + rect.size.width, rect.origin.y, rect.origin.x + rect.size.width, rect.origin.y + cornerRadius, cornerRadius);
    CGPathAddLineToPoint(path, NULL, rect.origin.x + rect.size.width, rect.origin.y + rect.size.height - cornerRadius);
    CGPathAddArcToPoint(path, NULL, rect.origin.x + rect.size.width, rect.origin.y + rect.size.height, rect.origin.x + rect.size.width - cornerRadius, rect.origin.y + rect.size.height, cornerRadius);
    CGPathAddLineToPoint(path, NULL, rect.origin.x, rect.origin.y + rect.size.height);
    CGPathCloseSubpath(path);
    
    return path;
}

- (CGMutablePathRef)bodyPathInRect:(CGRect)rect
{
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, rect.origin.x, rect.origin.y);
    CGPathAddLineToPoint(path, NULL, rect.origin.x + rect.size.width, rect.origin.y);
    CGPathAddLineToPoint(path, NULL, rect.origin.x + rect.size.width, rect.origin.y + rect.size.height);
    CGPathAddLineToPoint(path, NULL, rect.origin.x, rect.origin.y + rect.size.height);
    CGPathCloseSubpath(path);
    
    return path;
}


#pragma mark - Drawing

- (void)drawArrowAtPoint:(CGPoint)point arrowSize:(CGFloat)arrowSize arrowDirection:(QBPopupMenuArrowDirection)arrowDirection highlighted:(BOOL)highlighted
{
    CGRect arrowRect = CGRectZero;
    
    switch (arrowDirection) {
        case QBPopupMenuArrowDirectionDown:
        {
            arrowRect = CGRectMake(point.x - arrowSize + 1.0,
                                   point.y - arrowSize,
                                   arrowSize * 2.0 - 1.0,
                                   arrowSize);
            
            arrowRect.origin.x = MIN(MAX(arrowRect.origin.x, self.cornerRadius),
                                     self.frame.size.width - self.cornerRadius - arrowRect.size.width);
        }
            break;
            
        case QBPopupMenuArrowDirectionUp:
        {
            arrowRect = CGRectMake(point.x - arrowSize + 1.0,
                                   0,
                                   arrowSize * 2.0 - 1.0,
                                   arrowSize);
            
            arrowRect.origin.x = MIN(MAX(arrowRect.origin.x, self.cornerRadius),
                                     self.frame.size.width - self.cornerRadius - arrowRect.size.width);
        }
            break;
            
        case QBPopupMenuArrowDirectionLeft:
        {
            arrowRect = CGRectMake(0,
                                   point.y - arrowSize + 1.0,
                                   arrowSize,
                                   arrowSize * 2.0 - 1.0);
        }
            break;
            
        case QBPopupMenuArrowDirectionRight:
        {
            arrowRect = CGRectMake(point.x - arrowSize,
                                   point.y - arrowSize + 1.0,
                                   arrowSize,
                                   arrowSize * 2.0 - 1.0);
        }
            break;
            
        default:
            break;
    }
    
    [self drawArrowInRect:arrowRect direction:arrowDirection highlighted:highlighted];
}

- (void)drawArrowInRect:(CGRect)rect direction:(QBPopupMenuArrowDirection)direction highlighted:(BOOL)highlighted
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // Arrow
    CGContextSaveGState(context); {
        CGMutablePathRef path = [self arrowPathInRect:rect direction:direction];
        CGContextAddPath(context, path);
        
        UIColor *color = highlighted ? self.highlightedColor : self.color;
        CGContextSetFillColorWithColor(context, [color CGColor]);
        CGContextFillPath(context);
        
        CGPathRelease(path);
    } CGContextRestoreGState(context);
    
    // Separator
    if (direction == QBPopupMenuArrowDirectionDown || direction == QBPopupMenuArrowDirectionUp) {
        for (QBPopupMenuItemView *itemView in self.visibleItemViews) {
            [self drawSeparatorInRect:CGRectMake(itemView.frame.origin.x + itemView.frame.size.width - 1, rect.origin.y, 1, rect.size.height)];
        }
    }
}

- (void)drawHeadInRect:(CGRect)rect cornerRadius:(CGFloat)cornerRadius highlighted:(BOOL)highlighted
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // Head
    CGContextSaveGState(context); {
        CGMutablePathRef path = [self headPathInRect:rect cornerRadius:cornerRadius];
        CGContextAddPath(context, path);
        
        UIColor *color = highlighted ? self.highlightedColor : self.color;
        CGContextSetFillColorWithColor(context, [color CGColor]);
        CGContextFillPath(context);
        
        CGPathRelease(path);
    } CGContextRestoreGState(context);
}

- (void)drawTailInRect:(CGRect)rect cornerRadius:(CGFloat)cornerRadius highlighted:(BOOL)highlighted
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // Tail
    CGContextSaveGState(context); {
        CGMutablePathRef path = [self tailPathInRect:rect cornerRadius:cornerRadius];
        CGContextAddPath(context, path);
        
        UIColor *color = highlighted ? self.highlightedColor : self.color;
        CGContextSetFillColorWithColor(context, [color CGColor]);
        CGContextFillPath(context);
        
        CGPathRelease(path);
    } CGContextRestoreGState(context);
}

- (void)drawBodyInRect:(CGRect)rect firstItem:(BOOL)firstItem lastItem:(BOOL)lastItem highlighted:(BOOL)highlighted
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // Body
    CGContextSaveGState(context); {
        CGMutablePathRef path = [self bodyPathInRect:rect];
        CGContextAddPath(context, path);
        
        UIColor *color = highlighted ? self.highlightedColor : self.color;
        CGContextSetFillColorWithColor(context, [color CGColor]);
        CGContextFillPath(context);
        
        CGPathRelease(path);
    } CGContextRestoreGState(context);
    
    // Separator
    if (!lastItem) {
        [self drawSeparatorInRect:CGRectMake(rect.origin.x + rect.size.width - 1, rect.origin.y, 1, rect.size.height)];
    }
}

- (void)drawSeparatorInRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // Separator
    CGContextSaveGState(context); {
        CGContextClearRect(context, rect);
    } CGContextRestoreGState(context);
}

@end
