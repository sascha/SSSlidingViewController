//
//  SSSlidingViewController.m
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

#import "SSSlidingViewController.h"

CGFloat const kMaximumLeftViewControllerWidth = 320.0f;
CGFloat const kMinimumRootViewControllerWidth = 60.0f;

@interface SSSlidingViewController () {
    CGFloat _initialXTouchPosition;
    CGFloat _initialHorizontalCenter;
}

- (CGPoint)newCenterForPoint:(CGPoint)point;
- (CGPoint)originalCenterForPoint:(CGPoint)point;
- (void)addRootViewSnapshot;
- (void)removeRootViewSnapshot;

@property (nonatomic, strong) UIView *rootViewSnapshot;
@property (nonatomic, readonly) UITapGestureRecognizer *tapGestureRecognizer;
@property (nonatomic, readonly) UIPanGestureRecognizer *rootViewSnapshotPanRecognizer;

@end

@implementation UIViewController (SlidingViewExtension)

- (SSSlidingViewController *)slidingViewController
{
    UIViewController *viewController = self.parentViewController;
    while (!(viewController == nil || [viewController isKindOfClass:[SSSlidingViewController class]])) {
        viewController = viewController.parentViewController;
    }
    
    return (SSSlidingViewController *)viewController;
}

@end

@implementation SSSlidingViewController
@synthesize tapGestureRecognizer = _tapGestureRecognizer;
@synthesize rootViewSnapshotPanRecognizer = _rootViewSnapshotPanRecognizer;

#pragma mark - getters

- (UITapGestureRecognizer *)tapGestureRecognizer {
    if (!_tapGestureRecognizer) {
        _tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeLeftViewController)];
    }
    return _tapGestureRecognizer;
}

#pragma mark - setters

- (void)setLeftViewController:(UIViewController *)leftViewController {   
    if (![self.leftViewController isEqual:leftViewController]) {        
        if (self.leftViewController) {
            [self.leftViewController.view removeFromSuperview];
            [self.leftViewController willMoveToParentViewController:nil];
            [self.leftViewController removeFromParentViewController];
        }
        
        _leftViewController = leftViewController;
        if (kMinimumRootViewControllerWidth + kMaximumLeftViewControllerWidth <= self.view.bounds.size.width) {
            _leftViewController.view.frame = CGRectMake(0, 0, kMaximumLeftViewControllerWidth, self.view.bounds.size.height);
        } else {
            _leftViewController.view.frame = CGRectMake(0, 0, self.view.bounds.size.width - kMinimumRootViewControllerWidth, self.view.bounds.size.height);
        }
        [self addChildViewController:_leftViewController];
        [self.view insertSubview:self.leftViewController.view atIndex:0];        
        [self.leftViewController didMoveToParentViewController:self];
    }
}

- (void)setRootViewController:(UIViewController *)rootViewController {
    if (![self.rootViewController isEqual:rootViewController]) {
        if (self.rootViewController) {
            [self.leftViewController.view removeFromSuperview];
            [self.rootViewController willMoveToParentViewController:nil];
            [self.rootViewController removeFromParentViewController];
        }
        
        _rootViewController = rootViewController;
        [self addChildViewController:self.rootViewController];
        [self.view addSubview:self.rootViewController.view];
        
        [self.rootViewController didMoveToParentViewController:self];
        self.rootViewController.view.layer.rasterizationScale = [[UIScreen mainScreen] scale];
    }
}

#pragma mark - view lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.rootViewSnapshot = [[UIView alloc] initWithFrame:self.view.bounds];
    [self.rootViewSnapshot addGestureRecognizer:self.tapGestureRecognizer];
}

#pragma mark - custom methods

- (void)revealLeftViewController {
    self.rootViewController.view.layer.shouldRasterize = YES;

    [self revealLeftViewControllerWithVelocity:1500];
}

- (void)revealLeftViewControllerWithVelocity:(CGFloat)velocity {
    if (velocity < 500) {
        velocity = 500;
    }
    
    CGPoint newCenter = [self newCenterForPoint:self.rootViewController.view.center];
    CGFloat xPoints = fabsf(self.rootViewController.view.center.x - newCenter.x);
    NSTimeInterval duration = xPoints / velocity;
    
    [UIView animateWithDuration:duration animations:^{
        self.rootViewController.view.center = [self newCenterForPoint:self.rootViewController.view.center];
    } completion:^(BOOL finished) {
        [self addRootViewSnapshot];
        self.rootViewController.view.layer.shouldRasterize = NO;
    }];
}

- (void)closeLeftViewController {
    self.rootViewController.view.layer.shouldRasterize = YES;

    [self closeLeftViewControllerWithVelocity:1500];
}

- (void)closeLeftViewControllerWithVelocity:(CGFloat)velocity {
    if (velocity < 500) {
        velocity = 500;
    }
        
    CGPoint newCenter = [self originalCenterForPoint:self.rootViewController.view.center];
    CGFloat xPoints = fabsf(self.rootViewController.view.center.x - newCenter.x);
    NSTimeInterval duration = xPoints / velocity;
    
    [UIView animateWithDuration:duration animations:^{
        self.rootViewController.view.center = [self originalCenterForPoint:self.rootViewController.view.center];
    } completion:^(BOOL finished) {
        [self removeRootViewSnapshot];
        self.rootViewController.view.layer.shouldRasterize = NO;
    }];
}

- (CGPoint)newCenterForPoint:(CGPoint)point {
    CGPoint newPoint;
    
    if (kMaximumLeftViewControllerWidth + kMinimumRootViewControllerWidth > self.view.bounds.size.width) {
        newPoint = CGPointMake(fabs(self.view.bounds.size.width * 1.5 - kMinimumRootViewControllerWidth), point.y);
    } else {
        newPoint = CGPointMake(fabs(self.view.bounds.size.width / 2 + kMaximumLeftViewControllerWidth), point.y);
    }
    
    return newPoint;
}

- (CGPoint)originalCenterForPoint:(CGPoint)point {
    return CGPointMake(self.view.bounds.size.width / 2, point.y);
}

- (void)addRootViewSnapshot {
    if (!self.rootViewSnapshot.superview) {
        [self.rootViewController.view addSubview:self.rootViewSnapshot];
    }
}

- (void)removeRootViewSnapshot
{
    if (self.rootViewSnapshot.superview) {
        [self.rootViewSnapshot removeFromSuperview];
    }
}

- (void)updateRootViewWithPanRecognizer:(UIPanGestureRecognizer *)recognizer {
    CGPoint currentTouchPoint = [recognizer locationInView:self.view];
    CGFloat currentTouchPositionX = currentTouchPoint.x;
    
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        self.rootViewController.view.layer.shouldRasterize = YES;
        _initialXTouchPosition = currentTouchPositionX;
        _initialHorizontalCenter = self.rootViewController.view.center.x;
    } else if (recognizer.state == UIGestureRecognizerStateChanged) {      
        CGFloat panAmount = _initialXTouchPosition - currentTouchPositionX;
        CGFloat newCenterPosition = _initialHorizontalCenter - panAmount;
        
        if (newCenterPosition < self.view.bounds.size.width / 2) {
            newCenterPosition = self.view.bounds.size.width / 2;
        } else if (newCenterPosition > fabs(self.view.bounds.size.width / 2 + kMaximumLeftViewControllerWidth)) {
            newCenterPosition = fabs(self.view.bounds.size.width / 2 + kMaximumLeftViewControllerWidth);
        } else if (newCenterPosition > fabs(self.view.bounds.size.width * 1.5 - kMinimumRootViewControllerWidth)) {
            newCenterPosition = fabs(self.view.bounds.size.width * 1.5 - kMinimumRootViewControllerWidth);
        }
                
        CGPoint center = self.rootViewController.view.center;
        center.x = newCenterPosition;
        self.rootViewController.view.center = center;
    } else if (recognizer.state == UIGestureRecognizerStateEnded || recognizer.state == UIGestureRecognizerStateCancelled) {
        CGPoint currentVelocityPoint = [recognizer velocityInView:self.view];
        CGFloat currentVelocityX = currentVelocityPoint.x;
        
        if (currentTouchPositionX < _initialXTouchPosition) {
            // move root view to the left (hide menu)
            if (fabsf(currentVelocityX) > 100 || (self.rootViewController.view.center.x - self.rootViewController.view.bounds.size.width / 2) < self.leftViewController.view.center.x) {
                [self closeLeftViewControllerWithVelocity:fabsf(currentVelocityX)];
            } else {
                [self revealLeftViewControllerWithVelocity:500];
            }
        } else {
            // move root view to the right (show menu)
            if (fabsf(currentVelocityX) > 100 || (self.rootViewController.view.center.x - self.rootViewController.view.bounds.size.width / 2) > self.leftViewController.view.center.x) {
                [self revealLeftViewControllerWithVelocity:fabsf(currentVelocityX)];
            } else {
                [self closeLeftViewControllerWithVelocity:500];
            }
        }
    }
}

@end
