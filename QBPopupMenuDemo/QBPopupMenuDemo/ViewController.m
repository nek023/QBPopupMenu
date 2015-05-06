//
//  ViewController.m
//  QBPopupMenuDemo
//
//  Created by Tanaka Katsuma on 2013/11/22.
//  Copyright (c) 2013年 Katsuma Tanaka. All rights reserved.
//

#import "ViewController.h"

#import "QBPopupMenu.h"
#import "QBPlasticPopupMenu.h"

@interface ViewController ()

@property (nonatomic, strong) QBPopupMenu *popupMenu;
@property (nonatomic, strong) QBPlasticPopupMenu *plasticPopupMenu;

@property (nonatomic, strong) QBPopupMenu *popupMenuBlcok;
@property (nonatomic, strong) QBPlasticPopupMenu *plasticPopupMenuBlcok;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    QBPopupMenuItem *item = [QBPopupMenuItem itemWithTitle:@"Hello" target:self action:@selector(action)];
    QBPopupMenuItem *item2 = [QBPopupMenuItem itemWithTitle:@"Cut" target:self action:@selector(action)];
    QBPopupMenuItem *item3 = [QBPopupMenuItem itemWithTitle:@"Copy" target:self action:@selector(action)];
    QBPopupMenuItem *item4 = [QBPopupMenuItem itemWithTitle:@"Delete" target:self action:@selector(action)];
    QBPopupMenuItem *item5 = [QBPopupMenuItem itemWithImage:[UIImage imageNamed:@"clip"] target:self action:@selector(action)];
    QBPopupMenuItem *item6 = [QBPopupMenuItem itemWithTitle:@"Delete" image:[UIImage imageNamed:@"trash"] target:self action:@selector(action)];
    NSArray *items = @[item, item2, item3, item4, item5, item6];
    
    QBPopupMenu *popupMenu = [[QBPopupMenu alloc] initWithItems:items];
    popupMenu.highlightedColor = [[UIColor colorWithRed:0 green:0.478 blue:1.0 alpha:1.0] colorWithAlphaComponent:0.8];
    self.popupMenu = popupMenu;
    
    QBPlasticPopupMenu *plasticPopupMenu = [[QBPlasticPopupMenu alloc] initWithItems:items];
    plasticPopupMenu.height = 40;
    self.plasticPopupMenu = plasticPopupMenu;
    
    
    QBPopupMenuItem *bItem = [QBPopupMenuItem itemWithTitle:@"Hello" actionBlcok:^{
        NSLog(@"Hello");
    }];
    QBPopupMenuItem *bItem2 = [QBPopupMenuItem itemWithTitle:@"Cut" actionBlcok:^{
        NSLog(@"Cut");
    }];
    QBPopupMenuItem *bItem3 = [QBPopupMenuItem itemWithTitle:@"Copy" actionBlcok:^{
        NSLog(@"Copy");
    }];
    QBPopupMenuItem *bItem4 = [QBPopupMenuItem itemWithTitle:@"Delete" actionBlcok:^{
        NSLog(@"Delete");
    }];
    QBPopupMenuItem *bItem5 = [QBPopupMenuItem itemWithImage:[UIImage imageNamed:@"clip"] actionBlock:^{
        NSLog(@"Clip Image");
    }];
    QBPopupMenuItem *bItem6 = [QBPopupMenuItem itemWithTitle:@"Delete" image:[UIImage imageNamed:@"trash"] actionBlcok:^{
        NSLog(@"Trash Image");
    }];
    NSArray *bItems = @[bItem, bItem2, bItem3, bItem4, bItem5, bItem6];
    
    QBPopupMenu *popupMenuBlcok = [[QBPopupMenu alloc] initWithItems:bItems];
    popupMenuBlcok.highlightedColor = [[UIColor colorWithRed:0 green:0.478 blue:1.0 alpha:1.0] colorWithAlphaComponent:0.8];
    self.popupMenuBlcok = popupMenuBlcok;
    
    QBPlasticPopupMenu *plasticPopupMenuBlcok = [[QBPlasticPopupMenu alloc] initWithItems:bItems];
    plasticPopupMenuBlcok.height = 40;
    self.plasticPopupMenuBlcok = plasticPopupMenuBlcok;

    
}


- (IBAction)showPopupMenu:(id)sender
{
    UIButton *button = (UIButton *)sender;
    [self.popupMenu showInView:self.view targetRect:button.frame animated:YES];
}

- (IBAction)showPlasticPopupMenu:(id)sender
{
    UIButton *button = (UIButton *)sender;
    [self.plasticPopupMenu showInView:self.view targetRect:button.frame animated:YES];
}
- (IBAction)showPopupMenuBlock:(id)sender {
    UIButton *button = (UIButton *)sender;
    [self.popupMenuBlcok showInView:self.view targetRect:button.frame animated:YES];
}
- (IBAction)showPlasticPopupMenuBlcok:(id)sender {
    UIButton *button = (UIButton *)sender;
    [self.plasticPopupMenuBlcok showInView:self.view targetRect:button.frame animated:YES];

}

- (void)action
{
    NSLog(@"*** action");
}

@end
