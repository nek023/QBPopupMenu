//
//  QBPlasticPopupMenu.h
//  QBPopupMenu
//
//  Created by Tanaka Katsuma on 2013/11/25.
//  Copyright (c) 2013年 Katsuma Tanaka. All rights reserved.
//

#import "QBPopupMenu.h"

@interface QBPlasticPopupMenu : QBPopupMenu

// NOTE: When subclassing this class, use these methods to customize the appearance.
- (CGMutablePathRef)upperHeadPathInRect:(CGRect)rect cornerRadius:(CGFloat)cornerRadius CF_RETURNS_RETAINED;
- (CGMutablePathRef)lowerHeadPathInRect:(CGRect)rect cornerRadius:(CGFloat)cornerRadius CF_RETURNS_RETAINED;
- (CGMutablePathRef)upperTailPathInRect:(CGRect)rect cornerRadius:(CGFloat)cornerRadius CF_RETURNS_RETAINED;
- (CGMutablePathRef)lowerTailPathInRect:(CGRect)rect cornerRadius:(CGFloat)cornerRadius CF_RETURNS_RETAINED;

- (void)drawLeftSeparatorInRect:(CGRect)rect highlighted:(BOOL)highlighted;
- (void)drawRightSeparatorInRect:(CGRect)rect highlighted:(BOOL)highlighted;

@end
