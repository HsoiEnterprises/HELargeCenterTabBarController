[![Build Status](https://travis-ci.org/HsoiEnterprises/HELargeCenterTabBarController.svg)](https://travis-ci.org/HsoiEnterprises/HELargeCenterTabBarController)
![CocoaPods Compatible](https://img.shields.io/cocoapods/v/HELargeCenterTabBarController.svg)
![License](https://img.shields.io/badge/license-BSD%203--Clause-blue.svg)
![Platform](https://img.shields.io/badge/platform-iOS-lightgrey.svg)


# HELargeCenterTabBarController

`HELargeCenterTabBarController` is a 100% Swift implementation of a `UITabBarController` with a lager center tab.

The center tab can be used in the typical manner where a tap switches to display the associated ViewController, or the center tab can be used in an alternate manner where the tap does not switch ViewControllers but instead executes a target-action.

Simple. Lightweight. To-the-point.

**Typical Use:**

![alt tag](https://raw.githubusercontent.com/HsoiEnterprises/HELargeCenterTabBarController/master/HELargeCenterTabBarController-allowSwitchTrue.gif)


**Alternate approach (`allowSwitch = false`)**

![alt tag](https://raw.githubusercontent.com/HsoiEnterprises/HELargeCenterTabBarController/master/HELargeCenterTabBarController-allowSwitchFalse.gif)


# Supported OS and SDK

- Xcode 8+
- Swift 3+
- iOS 8 (minimum, required)

As of v2.0, only Swift 3 is supported. If you need Swift 2.2 support, use v1.0.1.


# Installation

Currently supports being installed by simple source code addition, by git submodule, or by CocoaPods (preferred).


## Submodule

You can easily obtain git as a submodule, and simply add `HELargeCenterTabBarController.swift` to your project. Off you go!

## CocoaPods

[CocoaPods][CocoaPods] is a dependency manager for Cocoa projects.

CocoaPods 0.36 adds supports for Swift and embedded frameworks. You can install it with the following command:

```bash
$ gem install cocoapods
```

To integrate HEAlert into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '8.0'
use_frameworks!

pod 'HELargeCenterTabBarController'
```

Then, run the following command:

```bash
$ pod install
```


# Usage

Instantiate the `HELargeCenterTabBarController` either in code or in your storyboard.

## Setup

### Storyboard

* Drag a `UITabBarController` from the Interface Builder Object Library into your Storyboard.
* Select the `UITabBarController` instance, switch to the "Identity Inspector" tab, and set the custom class to `HELargeCenterTabBarController`.
  * You may need to set the Module, depending how you added `HELargeCenterTabBarController` to your project.
* Have some way to obtain a reference to the `HELargeCenterTabBarController` instance, so you can call `addCenterButton()` on it. This could be:
  * via an `IBOutlet`
  * As the controller is likely the `appDelegate.window?.rootViewController?`, you could access it that way.
  
### Code

In your `application(application:didFinishLaunchingWithOptions:)`:

```swift
private var tabController: UITabBarController!

func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
   
   // create your content view controllers
   
   tabController = HELargeCenterTabBarController()
   tabController.viewControllers = [firstViewController, secondViewController, thirdViewController]
   // addCenterButton() -- see below
   window?.rootViewController = tabController
   
   return true
}
```

### Common

Assuming you now have instantiated a `HELargeCenterTabBarController` and have a reference to it, you add your button images thusly:

```swift
if let unselectedImage = UIImage(named: "tab-unselected"), selectedImage = UIImage(named: "tab-selected") {
    tabController.addCenterButton(unselectedImage: unselectedImage, selectedImage: selectedImage)
}
```

It's important to ensure your call to `addCenterButton()` happens after the `HELargeCenterTabBarController` actually loads (its `viewDidLoad()` is called). Depending upon the timing of how things are created, it you may need to wrap your add in a dispatch_async() to ensure this ordering:

```swift
dispatch_async(dispatch_get_main_queue(), { () -> Void in
    if let unselectedImage = UIImage(named: "tab-unselected"), selectedImage = UIImage(named: "tab-selected") {
        tabBarController.addCenterButton(unselectedImage: unselectedImage, selectedImage: selectedImage)
    }
})
```


## Images

The images wholly define the look and feel of the center button/tab. The colors, borders, transparency, icons, labels, and most importantly **size of the tab** come 100% from the images.

It is expected to provide two versions of the same image: a selected and an unselected image. The selected image is used when the tab is selected, and cosmetics should reflect a selected state (e.g. "brighter"). The unselected image is used when the tab is not selected, and cosmetics should reflect an unselected state (e.g. dimmer, subdued, disabled).

It's important the two images are the same size and general look and feel, differing only in reflection of (un)selected state. This provides the seemless UI and UX needed to make this control work.


## Target-Action

Because the tab is actually implemented as a `UIButton`, a optional target-action is supported for taps on the button. Having a target-action is generally not necessary, if all you desire is typical tab-like functionality, just with the larger-center cosmetics.

One place where target-action is required is if `allowSwitch` is false.


## `allowSwitch`

While the controller's typical behavior is to act in a tab-like manner, where tapping the tab button switches the content to the ViewController associated with that tab, setting `allowSwitch` to false will prevent the switch from occurring. The tap still occurs, just no switching occurs. Instead, you will want to install a target-action to execute your behavior.

One reason for this might be that instead of switching to a different tab, a ViewController is presented modally. For example:

```swift
tabController.addCenterButton(unselectedImage: unselectedImage, selectedImage: selectedImage, target: self, action: "presentSecondViewController:", allowSwitch: false)

...

func presentSecondViewController(sender: AnyObject) {
    if let rootViewController = window?.rootViewController {
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("modalNavViewController")
        rootViewController.presentViewController(viewController, animated: true, completion: nil)
    }
}

```


# Contact

## Hsoi Enterprises
- [Website][hsoienterprises-website]
- [Facebook][hsoienterprises-facebook]
- [Twitter (@HsoiEnterprises)][hsoienterprises-twitter]

## Creator
- John C. Daub [(@hsoi)][hsoi-twitter]


# Changes / Release Notes

See included `CHANGELOG.md` file.


# License

BSD 3-clause “New” or “Revised” License. See included "License" file.


[hsoienterprises-website]: http://www.hsoienterprises.com
[hsoienterprises-facebook]: https://www.facebook.com/HsoiEnterprises
[hsoienterprises-twitter]: http://twitter.com/hsoienterprises
[hsoi-twitter]: http://twitter.com/hsoi
[cocoapods]: http://cocoapods.org
