//
//  SSNavigationTableViewController.m
//  SSSlidingViewControllerDemo
//
//  Copyright (c) 2013 Sascha Schwabbauer (http://github.com/sascha/)
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#import "SSNavigationTableViewController.h"

@interface SSNavigationTableViewController () {
    NSString *_activeViewControllerIdentifier;
}

@end

@implementation SSNavigationTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.view.autoresizingMask = UIViewAutoresizingFlexibleHeight;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // set the view controller's storyboard identifier for each corresponding cell
    NSString *viewControllerIdentifier;
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
                viewControllerIdentifier = @"item1ViewController";
                break;
            case 1:
                viewControllerIdentifier = @"item2ViewController";
                break;
        }
    }
    
    // instantiate view controller or create new one
    UIViewController *viewController;
    
    if (viewControllerIdentifier) {
        viewController = [self.storyboard instantiateViewControllerWithIdentifier:viewControllerIdentifier];
    } else {
        viewController = [[UIViewController alloc] init];
        viewController.view.backgroundColor = [UIColor whiteColor];
    }
    
    SSSlidingNavigationController *navController = (SSSlidingNavigationController *)self.slidingViewController.rootViewController;
    
    // change view controller if it has changed
    if (![_activeViewControllerIdentifier isEqual:viewControllerIdentifier]) {
        [navController setViewControllers:@[viewController] animated:NO];
        _activeViewControllerIdentifier = viewControllerIdentifier;
    }
    
    // close left side of SSSlidingViewController    
    [self.slidingViewController closeLeftViewController];
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
}

@end
