//
//  ViewController.m
//  QBPopupMenu
//
//  Created by Katsuma Tanaka on 2013/02/01.
//  Copyright (c) 2013年 Katsuma Tanaka. All rights reserved.
//

#import "ViewController.h"

#import "QBPopupMenu.h"

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // popupMenu
    QBPopupMenu *popupMenu = [[QBPopupMenu alloc] init];
    
    QBPopupMenuItem *item1 = [QBPopupMenuItem itemWithTitle:@"Reply" image:[UIImage imageNamed:@"icon_reply.png"] target:self action:@selector(reply:)];
    item1.width = 64;
    
    QBPopupMenuItem *item2 = [QBPopupMenuItem itemWithTitle:@"Favorite" image:[UIImage imageNamed:@"icon_favorite.png"] target:nil action:NULL];
    item2.width = 64;
    
    QBPopupMenuItem *item3 = [QBPopupMenuItem itemWithTitle:@"Retweet" image:[UIImage imageNamed:@"icon_retweet.png"] target:nil action:NULL];
    item3.width = 64;
    
    popupMenu.items = [NSArray arrayWithObjects:item1, item2, item3, nil];
    
    self.popupMenu = popupMenu;
    [popupMenu release];
    
    // popupMenu2
    QBPopupMenu *popupMenu2 = [[QBPopupMenu alloc] init];
    
    QBPopupMenuItem *item4 = [QBPopupMenuItem itemWithTitle:@"Text" target:nil action:NULL];
    
    QBPopupMenuItem *item5 = [QBPopupMenuItem itemWithTitle:@"Disabled" target:nil action:NULL];
    item5.enabled = NO;
    
    UIView *customView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 80, 50)];
    customView.backgroundColor = [UIColor clearColor];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = CGRectMake(6, 6, 68, 38);
    [button setTitle:@"Button" forState:UIControlStateNormal];
    [customView addSubview:button];
    
    QBPopupMenuItem *item6 = [QBPopupMenuItem itemWithCustomView:customView target:nil action:NULL];
    item6.enabled = NO;
    
    [customView release];
    
    popupMenu2.items = [NSArray arrayWithObjects:item4, item5, item6, nil];
    
    self.popupMenu2 = popupMenu2;
    [popupMenu2 release];
}

- (void)dealloc
{
    [_popupMenu release];
    [_popupMenu2 release];
    
    [super dealloc];
}


#pragma mark -

- (IBAction)showPopupMenu:(id)sender {
    UIButton *button = (UIButton *)sender;
    
    [self.popupMenu showInView:self.view atPoint:CGPointMake(button.center.x, button.frame.origin.y)];
}

- (IBAction)showPopupMenu2:(id)sender {
    UIButton *button = (UIButton *)sender;
    
    [self.popupMenu2 showInView:self.view atPoint:CGPointMake(button.center.x, button.frame.origin.y)];
}

- (void)reply:(id)sender
{
    NSLog(@"*** reply: %@", [sender class]);
}

@end