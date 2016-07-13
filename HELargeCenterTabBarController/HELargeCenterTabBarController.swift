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
//


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


    /**
    Sets `self` as the delegate.
    */
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        delegate = self
    }
    
    
    /// Override to ensure that upon selection, the center button is updated
    override public var selectedViewController: UIViewController? {
        didSet {
            updateCenterButton()
        }
    }
    
    
    /// Override to ensure that upon selection, the center button is updated.
    override public var selectedIndex: Int {
        didSet {
            updateCenterButton()
        }
    }
    
    
    /// Reference to the center button. Marked optional, but generally should exist (else what's the point?).
    public weak var centerButton: UIButton?
    
    /// Reference to the "selected" version of the button. Marked optional, but generally should exist (else what's the point?).
    private var buttonImageSelected: UIImage?
    
    /// Reference to the "unselected" version of the button. Marked optional, but generally should exist (else what's the point?).
    private var buttonImageUnselected: UIImage?
    
    /// Reference to the action target. Optional, as the button doesn't have to have a target-action behavior.
    private var buttonTarget: AnyObject?
    
    /// Reference to the action selector. Optional, as the button doesn't haev to have a target-action behavior.
    private var buttonAction: Selector?
    
    /// Does tapping/selecting the center button allow the tab controller to actually switch to that tab or not? Generally if set to false, the target-action should be set so as to have some response to the button tap.
    private var allowSwitch: Bool = true
    
    
    /**
    Sets the center tab/button to the given parameters.
    
    The center "tab" is really a UIButton, which will be sized to the dimensions of the given unselected image. The exact size of the image is up to you. In choosing a size, consider of course the height should extend slightly above the tab bar (but not too much so as to obscure content), and the width should be wide enough to cover most of the underlying tab bar button, but that some of the tab bar button will be exposed (depending upon device, tab bar width, device orientation, OS version, etc.).
    
    The image provides the whole content -- cosmetics, labels, borders, etc.. Ideally the selected and unselected images should be the same size, content, and general appearance, just that one will look selected (e.g. brighter) and the other will look unselected (e.g. more subdued). This will allow for seemless UI transitions between the two states.
    
    Because the center tab is actually a button, a target/action can be optionally provided so when the center tab is selected it will execute the target/action (as well as selecting the tab).
    
    The `allowSwitch` option provides control over whether taps on the tab/button will actually switch tabs or not. If true (default), taps on the button/tab will switch to make the center ViewController the selected/visible ViewController. If false, taps on the button/tab will not select the center ViewController. This allows the center button/tab to be used exclusively as a button (thus you will want to set the target and action), to give the center tab/button alternative behavior (e.g. perhaps instead of switching tabs, it presents a ViewController modally over the whole screen).
    
    - parameter unselectedImage: UIImage for the center button/tab, unselected state.
    - parameter selectedImage:   UIImage for the center button/tab, selected state.
    - parameter target:          Optional action target to message when tapping the center button/tab.
    - parameter action:          Optional target selector to execute when tapping the center button/tab.
    - parameter allowSwitch:     If true, taps on the center button/tab will select that tab. If false, taps will not select (but target-action will still be executed).
    */
    public func addCenterButton(unselectedImage: UIImage, selectedImage: UIImage, target: AnyObject? = nil, action: Selector? = nil, allowSwitch: Bool = true) {
        assert((target == nil && action == nil) || (target != nil && action != nil))
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
        button.translatesAutoresizingMaskIntoConstraints = false
        tabBar.addSubview(button)
        
        view.addConstraint(NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.CenterX, multiplier: 1.0, constant: 0.0));
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[button]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["button": button]));
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:[button(==\(unselectedImage.size.width))]", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["button": button]));
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[button(==\(unselectedImage.size.height))]", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["button": button]));
        
        button.addTarget(self, action: #selector(centerButtonAction(_:)), forControlEvents: .TouchUpInside)
        centerButton = button
        updateCenterButton()
    }


    /**
    HELargerCenterTabBarController must handle the taps on the centerButton. If `allowSwitch`, it will set the `selectedViewController` to the `centerViewController`. If the `buttonTarget` and `buttonAction` are set, execute them.
    
    - parameter sender: The sender of the action.
    */
    @IBAction dynamic private func centerButtonAction(sender: AnyObject) {
        if allowSwitch {
            selectedViewController = centerViewController
        }
        
        if let buttonTarget = buttonTarget, buttonAction = buttonAction {
            buttonTarget.performSelector(buttonAction, withObject: sender)
        }
    }
    
    
    /// Obtains the center UIViewController, if any.
    public var centerViewController: UIViewController? {
        if let viewControllers = viewControllers {
            let centerVC = viewControllers[viewControllers.count / 2]
            return centerVC
        }
        return nil
    }
    

    /**
    Ensures the center button cosmetics are correct, regarding the button images.
    */
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

