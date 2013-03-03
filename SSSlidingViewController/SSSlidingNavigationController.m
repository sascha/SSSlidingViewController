//
//  SSSlidingNavigationController.m
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

#import "SSSlidingNavigationController.h"

@interface SSSlidingNavigationController ()

- (void)revealMenuViewController:(id)sender;

@end

@implementation SSSlidingNavigationController

#pragma mark - custom methods

- (void)revealMenuViewController:(id)sender {
    [self.slidingViewController revealLeftViewController];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.delegate = self;
    
    // add shadow image
    UIImage *shadow = [UIImage imageNamed:@"shadowDivider"];
    UIImageView *shadowImage = [[UIImageView alloc] initWithImage:shadow];
    shadowImage.frame = CGRectMake(shadow.size.width * -1, 0, shadow.size.width, self.view.frame.size.height);
    shadowImage.contentMode = UIViewContentModeScaleToFill;
    [self.view addSubview:shadowImage];
    
    // add pan gesture recognizer
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self.slidingViewController action:@selector(updateRootViewWithPanRecognizer:)];
    panGestureRecognizer.minimumNumberOfTouches = 1;
    panGestureRecognizer.maximumNumberOfTouches = 1;
    [self.view addGestureRecognizer:panGestureRecognizer];
}

#pragma mark - navigation controller delegate

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    // add menu or back button when view controller changed
    if ([viewController isEqual:self.viewControllers[0]]) {
        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Menu" style:UIBarButtonItemStylePlain target:self action:@selector(revealMenuViewController:)];
    }
    viewController.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];
}

@end
