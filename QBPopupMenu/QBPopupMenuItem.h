//
//  QBPopupMenuItem.h
//  QBPopupMenu
//
//  Created by Tanaka Katsuma on 2013/11/22.
//  Copyright (c) 2013年 Katsuma Tanaka. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QBPopupMenuItem : NSObject

@property (nonatomic, weak, readonly) id target;
@property (nonatomic, assign, readonly) SEL action;

@property (nonatomic, copy, readonly) NSString *title;
@property (nonatomic, copy, readonly) UIImage *image;

+ (instancetype)itemWithTitle:(NSString *)title target:(id)target action:(SEL)action;
+ (instancetype)itemWithImage:(UIImage *)image target:(id)target action:(SEL)action;
+ (instancetype)itemWithTitle:(NSString *)title image:(UIImage *)image target:(id)target action:(SEL)action;

- (instancetype)initWithTitle:(NSString *)title target:(id)target action:(SEL)action;
- (instancetype)initWithImage:(UIImage *)image target:(id)target action:(SEL)action;
- (instancetype)initWithTitle:(NSString *)title image:(UIImage *)image target:(id)target action:(SEL)action;

@end
