# QBPopupMenu
*QBPopupMenu* is a popup menu for iOS without using image files.


## ScreenShot
![ss01.png](http://adotout.sakura.ne.jp/github/QBPopupMenu/ss01.png)
![ss02.png](http://adotout.sakura.ne.jp/github/QBPopupMenu/ss02.png)


## Example
    QBPopupMenu *popupMenu = [[QBPopupMenu alloc] init];
    
    QBPopupMenuItem *item = [QBPopupMenuItem itemWithTitle:@"Text Only" target:self action:@selector(hoge:)];
    
    QBPopupMenuItem *item2 = [QBPopupMenuItem itemWithTitle:@"Text with Image" image:[UIImage imageNamed:@"image.png"] target:self action:@selector(hoge:)];
    
    popupMenu.items = [NSArray arrayWithObjects, item1, item2, nil];
	
	[popupMenu showInView:self.view atPoint:CGPointMake(...)];

See *QBPopupMenu* project for more example usage.


## License
*QBPopupMenu* is released under the **MIT License**, see *LICENSE.txt*.