//
//  HELargeCenterTabBarController.m
//
//  Created by hsoi on 2014-07-03.
//
//  HELargeCenterTabBarController - Copyright (c) 2014, 2015, Hsoi Enterprises LLC
//  All rights reserved.
//  hsoi@hsoienterprises.com
//
//  Redistribution and use in source and binary forms, with or without
//  modification, are permitted provided that the following conditions are met:
//
//  * Redistributions of source code must retain the above copyright notice, this
//  list of conditions and the following disclaimer.
//
//  * Redistributions in binary form must reproduce the above copyright notice,
//  this list of conditions and the following disclaimer in the documentation
//  and/or other materials provided with the distribution.
//
//  * Neither the name of HELargeCenterTabBarController nor the names of its
//  contributors may be used to endorse or promote products derived from
//  this software without specific prior written permission.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
//  AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
//  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
//  DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
//  FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
//  DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
//  SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
//  CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
//  OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
//  OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#import "HELargeCenterTabBarController.h"

@interface HELargeCenterTabBarController ()

@property (nonatomic, weak)     UIButton*           centerButton;

@property (nonatomic, strong)   UIImage*            buttonImageSelected;
@property (nonatomic, strong)   UIImage*            buttonImageUnselected;

@property (nonatomic, strong)   id                  buttonTarget;
@property (nonatomic, assign)   SEL                 buttonAction;
@property (nonatomic, assign)	BOOL				allowSwitch;

@end

@implementation HELargeCenterTabBarController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.delegate = self;
}


#pragma mark - Center Support

// Hsoi 2014-07-30 - main public API for setting up the center button.
//
// The unselected and selected images are required. target/action is optional, if you want to do something special when the
// button is selected (generally not needed).
- (void)addCenterButtonWithUnselectedImage:(UIImage*)unselectedImage selectedImage:(UIImage*)selectedImage target:(id)target action:(SEL)action allowSwitch:(BOOL)allowSwitch {
    NSParameterAssert(unselectedImage != nil);
    NSParameterAssert(selectedImage != nil);
    NSParameterAssert(self.delegate == self);  // it should already be, but in case someone removes it... don't do that!
    self.delegate = self;
    
    self.buttonImageUnselected = unselectedImage;
    self.buttonImageSelected = selectedImage;
    self.buttonTarget = target;
    self.buttonAction = action;
	self.allowSwitch = allowSwitch;
    
    UIButton*   strongCenterButton = self.centerButton;
    if (strongCenterButton) {
        [strongCenterButton removeFromSuperview];
        strongCenterButton = nil;
        self.centerButton = nil;
    }
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];;
    self.centerButton = button;
    
    // TODO: convert this to autolayout
    button.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin;
    button.frame = CGRectMake(0.0f, 0.0f, unselectedImage.size.width, unselectedImage.size.height);
    CGFloat heightDifference = unselectedImage.size.height - CGRectGetHeight(self.tabBar.bounds);
    if (heightDifference < 0.0f) {
        button.center = self.tabBar.center;
    }
    else {
        CGPoint center = self.tabBar.center;
        center.y = center.y - heightDifference / 2.0f;
        button.center = center;
    }
    
    [button addTarget:self action:@selector(centerButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self updateCenterButton];
    
    [self.view addSubview:button];
}


// Hsoi 2014-07-30 - Private action for the center button. This takes care of ensuring things are right internally and that
// we can fake out the tab controller internals. Then invoking the user's action, if any.
- (IBAction)centerButtonAction:(id)sender {
	if (self.allowSwitch) {
		self.selectedViewController = self.centerViewController;
	}

    if (self.buttonTarget && self.buttonAction) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [self.buttonTarget performSelector:self.buttonAction withObject:sender];
#pragma clang diagnostic pop
    }
}


// Hsoi 2014-07-30 - public accessor for getting the center viewcontroller (or almost center, if we have an even number... which we shouldn't).
- (UIViewController*)centerViewController {
    UIViewController*   centerViewController = self.viewControllers[self.viewControllers.count / 2];
    return centerViewController;
}


// Hsoi 2014-07-30 - internal mechanism for updating the center button's cosmetics.
- (void)updateCenterButton {
    UIButton*   strongCenterButton = self.centerButton;
    UIImage*    buttonImage = self.buttonImageUnselected;
    if (self.selectedViewController == self.centerViewController) {
        buttonImage = self.buttonImageSelected;
    }
    [strongCenterButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
}


#pragma mark - UITabBarControllerDelegate

// Hsoi 2014-07-30 - we have to be our own delegate so that we can know when the center tab is selected. See, the tabs are always
// there, and likely our button will NOT fully cover the center tab button. So, if the user taps just outside our button but
// still within the frame of the center tab button, we gotta accept it and do the right thing.
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    if (tabBarController == self) {
        if (viewController == self.centerViewController) {
            [self centerButtonAction:self.centerButton];  // this should trigger an -updateCenterButton.
        }
        else {
            [self updateCenterButton];
        }
    }
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
	BOOL returnValue = YES;

	if ([self centerViewController] == viewController && NO == self.allowSwitch) {
		returnValue = NO;
	}

	return returnValue;
}


#pragma mark - Overrides

- (void)setSelectedViewController:(UIViewController *)selectedViewController {
    [super setSelectedViewController:selectedViewController];
    
    [self updateCenterButton];
}


- (void)setSelectedIndex:(NSUInteger)selectedIndex {
    [super setSelectedIndex:selectedIndex];
    
    [self updateCenterButton];
}


@end
