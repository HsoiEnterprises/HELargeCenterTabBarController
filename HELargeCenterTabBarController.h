//
//  HELargeCenterTabBarController.h
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


@import UIKit;

/**
HELargeCenterTabBarController, a UITabBarController where the middle tab is larger.

Based upon the logic found here: http://idevrecipes.com/2010/12/16/raised-center-tab-bar-button/

NB: it is its own delegate and MUST be -- do NOT override that.

If we need it that someone external needs to delegateness, then we can work that out later.
*/
@interface HELargeCenterTabBarController : UITabBarController  <UITabBarControllerDelegate>

- (void)addCenterButtonWithUnselectedImage:(UIImage*)unselectedImage selectedImage:(UIImage*)selectedImage target:(id)target action:(SEL)action;
- (void)addCenterButtonWithUnselectedImage:(UIImage*)unselectedImage selectedImage:(UIImage*)selectedImage target:(id)target action:(SEL)action allowSwitch:(BOOL)allowSwitch;

@property (nonatomic, readonly) UIViewController*       centerViewController;

@end
