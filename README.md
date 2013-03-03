# SSSlidingViewController

A custom container view controller for iOS that is very similar to the one Facebook uses in its iOS app and that is very easy to use.
It comes with three classes:

- `SSSlidingViewController`
- `SSNavigationTableViewController`
- `SSSlidingNavigationController`

`SSSlidingViewController` should be your root view controller. 
Use `- (void)setLeftViewController:` and `- (void)setRootViewController:` to set the left view controller and the root view controller. 

The left view controller should be an instance of `SSNavigationTableViewController` while the root view controller should be an instance of `SSSlidingNavigationController`, which can contain any kind of other view controller.
 
`SSNavigationTableViewController` uses storyboard identifiers to initialize new view controllers.

A sample Xcode project is available in the Examples directory.

## Screenshots

![Left side hidden](https://raw.github.com/sascha/SSSlidingViewController/screenshots/screenshots/screenshot1.png)
![Left side visible](https://raw.github.com/sascha/SSSlidingViewController/screenshots/screenshots/screenshot2.png)


## License 

SSSlidingViewController is available under the MIT license. See the LICENSE file for more info.