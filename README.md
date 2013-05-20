# QBPopupMenu
*QBPopupMenu* is a popup menu for iOS without using image files.


## ScreenShot
![ss01.png](http://adotout.sakura.ne.jp/github/QBPopupMenu/ss01.png)
![ss02.png](http://adotout.sakura.ne.jp/github/QBPopupMenu/ss02.png)

<!-- MacBuildServer Install Button -->
<div class="macbuildserver-block">
    <a class="macbuildserver-button" href="http://macbuildserver.com/project/github/build/?xcode_project=QBPopupMenu.xcodeproj&amp;target=QBPopupMenu&amp;repo_url=https%3A%2F%2Fgithub.com%2Fquestbeat%2FQBPopupMenu&amp;build_conf=Release" target="_blank"><img src="http://com.macbuildserver.github.s3-website-us-east-1.amazonaws.com/button_up.png"/></a><br/><sup><a href="http://macbuildserver.com/github/opensource/" target="_blank">by MacBuildServer</a></sup>
</div>
<!-- MacBuildServer Install Button -->

## Example
    QBPopupMenu *popupMenu = [[QBPopupMenu alloc] init];
    
    QBPopupMenuItem *item = [QBPopupMenuItem itemWithTitle:@"Text Only" target:self action:@selector(hoge:)];
    
    QBPopupMenuItem *item2 = [QBPopupMenuItem itemWithTitle:@"Text with Image" image:[UIImage imageNamed:@"image.png"] target:self action:@selector(hoge:)];
    
    popupMenu.items = [NSArray arrayWithObjects, item1, item2, nil];
	
	[popupMenu showInView:self.view atPoint:CGPointMake(...)];

See *QBPopupMenu* project for more example usage.


## License
*QBPopupMenu* is released under the **MIT License**, see *LICENSE.txt*.
