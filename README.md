# AdaptiveSidebarViewController
AdaptiveSidebarViewController is a simple container which can adaptively display a viewcontroller in a sidebar _(regular environment)_ or pushed on the navigation stack _(compact environment)_.

<img src="https://raw.githubusercontent.com/mkoehnke/AdaptiveSidebarViewController/master/Resources/AdaptiveSidebarViewController_iPad.gif">
<img src="https://raw.githubusercontent.com/mkoehnke/AdaptiveSidebarViewController/master/Resources/AdaptiveSidebarViewController_iPhone.gif">

# Installation
Install via cocoapods by adding this to your Podfile:

```
pod "AdaptiveSidebarViewController"
```

# Usage
Make a subclass of AdaptiveSidebarViewController and specify the main/side viewcontrollers:

```swift
override func viewDidLoad() {
	let mainVC = storyboard.instantiateViewControllerWithIdentifier("mainVC")
    mainViewController = mainVC
        
    let detailVC : storyboard.instantiateViewControllerWithIdentifier("detailVC")
    sideViewController = detailVC
    
    super.viewDidLoad()
}
```
In order to show/hide the sidebar, you use:

```swift
func showSideView(animated: Bool) -> Void
func hideSideView(animated: Bool) -> Void
```

Apart from that, one can modify the following settings:

##### SideView Width
Sets the with of the sidebar if displayed in a regular environment.

# License
ExpandableLabel is available under the MIT license. See the LICENSE file for more info.
