//
//  ViewController.h
//  QBPopupMenu
//
//  Created by Katsuma Tanaka on 2013/02/01.
//  Copyright (c) 2013年 Katsuma Tanaka. All rights reserved.
//

#import <UIKit/UIKit.h>

@class QBPopupMenu;

@interface ViewController : UIViewController

@property (nonatomic, strong) QBPopupMenu *popupMenu;
@property (nonatomic, strong) QBPopupMenu *popupMenu2;

- (IBAction)showPopupMenu:(id)sender;
- (IBAction)showPopupMenu2:(id)sender;

@end
