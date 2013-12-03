//
//  QBPopupMenuPagenatorView.h
//  QBPopupMenu
//
//  Created by Tanaka Katsuma on 2013/11/23.
//  Copyright (c) 2013年 Katsuma Tanaka. All rights reserved.
//

#import "QBPopupMenuItemView.h"

typedef NS_ENUM(NSUInteger, QBPopupMenuPagenatorDirection) {
    QBPopupMenuPagenatorDirectionLeft,
    QBPopupMenuPagenatorDirectionRight
};

@interface QBPopupMenuPagenatorView : QBPopupMenuItemView

@property (nonatomic, weak) id target;
@property (nonatomic, assign) SEL action;

+ (CGFloat)pagenatorWidth;

+ (instancetype)leftPagenatorViewWithTarget:(id)target action:(SEL)action;
+ (instancetype)rightPagenatorViewWithTarget:(id)target action:(SEL)action;

- (instancetype)initWithArrowDirection:(QBPopupMenuPagenatorDirection)arrowDirection target:(id)target action:(SEL)action;

// NOTE: When subclassing this class, use these methods to customize the appearance.
- (CGMutablePathRef)arrowPathInRect:(CGRect)rect direction:(QBPopupMenuPagenatorDirection)direction CF_RETURNS_RETAINED;
- (void)drawArrowInRect:(CGRect)rect direction:(QBPopupMenuPagenatorDirection)direction highlighted:(BOOL)highlighted;

@end
