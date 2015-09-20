//
//  HELargeCenterTabBarController.swift
//  Created by hsoi on 2014-07-03, converted to Swift 2015-09-20
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

import UIKit


/**
HELargeCenterTabBarController, a UITabBarController where the middle tab is larger.

Based upon the logic found here: http://idevrecipes.com/2010/12/16/raised-center-tab-bar-button/

Naturally, this assumes an odd number of tabs. Nothing is necessarily done to prohibit or enforce it, but
it will look odd with an even number of tabs.

The center tab is actually a `UIButton` superimposed over the `UITabBar`. Thus the interaction effects (tapping)
isn't exactly like a tab bar button, but as close as we can get. Cosmetics are fully supplied by the
given images -- including any borders, labels, transparency, or other cosmetics. Note that you will want
to play with the height and width of your images to find the ideal size for your app. Consider that
the center `UIButton` is merely superimposed thus the middle tab bar button is actually still in place
and likely will stick out a little bit to either side of your `UIButton`; this means a user can still
tap on the actual tab bar button, thus HELargeCenterTabBarController works to make that interaction
effect seemless and still behave properly. Due to this **HELargeCenterTabBarController must be its own
delegate** -- do *NOT* override that. If we need it that someone external needs to delegateness, then 
we can work that out later (file an enhancement request).

It is expected to provide different images to represent when the center tab is selected vs.
unselected. If for some reason you must use the same image for both states, then you can simply
pass the same `UIImage` for both states.
*/

public
class HELargeCenterTabBarController: UITabBarController {


    override public func viewDidLoad() {
        super.viewDidLoad()
        
        delegate = self
    }
    
    
    override public var selectedViewController: UIViewController? {
        didSet {
            updateCenterButton()
        }
    }
    
    override public var selectedIndex: Int {
        didSet {
            updateCenterButton()
        }
    }
    
    
    private weak var centerButton: UIButton?
    private var buttonImageSelected: UIImage?
    private var buttonImageUnselected: UIImage?
    private var buttonTarget: AnyObject?
    private var buttonAction: Selector?
    private var allowSwitch: Bool = true
    
    public func addCenterButton(unselectedImage unselectedImage: UIImage, selectedImage: UIImage, target: AnyObject?, action: Selector?) {
        addCenterButton(unselectedImage: unselectedImage, selectedImage: selectedImage, target: target, action: action, allowSwitch: true)
    }

    
    public func addCenterButton(unselectedImage unselectedImage: UIImage, selectedImage: UIImage, target: AnyObject?, action: Selector?, allowSwitch: Bool) {
        assert(delegate === self, "HELargeCenterTabBarController must be its own delegate")
        delegate = self
        
        buttonImageUnselected = unselectedImage
        buttonImageSelected = selectedImage
        buttonTarget = target
        buttonAction = action
        self.allowSwitch = allowSwitch
        
        if let centerButton = centerButton {
            centerButton.removeFromSuperview()
            self.centerButton = nil
        }
        let button = UIButton(type: .Custom)
        button.autoresizingMask = [.FlexibleRightMargin, .FlexibleLeftMargin, .FlexibleBottomMargin, .FlexibleTopMargin] // TODO: convert to autolayout
        button.frame = CGRect(x: 0.0, y: 0.0, width: unselectedImage.size.width, height: unselectedImage.size.height)
        let heightDifference = unselectedImage.size.height - CGRectGetHeight(tabBar.bounds)
        if heightDifference < 0.0 {
            button.center = tabBar.center
        }
        else {
            var center = tabBar.center
            center.y = center.y - heightDifference / 2.0
            button.center = center
        }
        
        button.addTarget(self, action: "centerButtonAction:", forControlEvents: .TouchUpInside)
        view.addSubview(button)
        centerButton = button
        updateCenterButton()
    }


    @IBAction private func centerButtonAction(sender: AnyObject) {
        if allowSwitch {
            selectedViewController = centerViewController
        }
        
        if let buttonTarget = buttonTarget, buttonAction = buttonAction {
            buttonTarget.performSelector(buttonAction, withObject: sender)
        }
    }
    
    
    public var centerViewController: UIViewController? {
        if let viewControllers = viewControllers {
            let centerVC = viewControllers[viewControllers.count / 2]
            return centerVC
        }
        return nil
    }
    

    private func updateCenterButton() {
        var buttonImage = buttonImageUnselected
        if selectedViewController === centerViewController {
            buttonImage = buttonImageSelected
        }
        
        if let centerButton = centerButton {
            centerButton.setBackgroundImage(buttonImage, forState: .Normal)
        }
    }

}



private typealias TabBarControllerDelegate = HELargeCenterTabBarController
extension TabBarControllerDelegate: UITabBarControllerDelegate {

    public func tabBarController(tabBarController: UITabBarController, didSelectViewController viewController: UIViewController) {
        if tabBarController === self {
            if viewController === centerViewController {
                if let centerButton = centerButton {
                    centerButtonAction(centerButton)
                }
            }
            else {
                updateCenterButton()
            }
        }
    }
    
    
    public func tabBarController(tabBarController: UITabBarController, shouldSelectViewController viewController: UIViewController) -> Bool {
        var should = true
        if centerViewController === viewController && !allowSwitch {
            should = false
        }
        return should
    }
}

