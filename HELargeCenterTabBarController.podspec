Pod::Spec.new do |spec|
  spec.name                 = 'HELargeCenterTabBarController'
  spec.version              = '2.0.0'
  spec.homepage             = 'https://github.com/HsoiEnterprises/HELargeCenterTabBarController'
  spec.source               = { :git => 'https://github.com/HsoiEnterprises/HELargeCenterTabBarController.git', :tag => "v#{spec.version}" }
  spec.summary              = 'A Swift UITabBarController with a larger center tab.'
  spec.author               = { 'John C. Daub (@hsoi)' => 'hsoi@hsoienterprises.com' }
  spec.social_media_url     = 'https://twitter.com/hsoienterprises'
  spec.description          = <<-DESC
                        HELargeCenterTabBarController is a 100% Swift implementation of a UITabBarController with a lager center tab. 
                        The center tab can be used in the typical manner where a tap switches to display the associated ViewController, or the center tab can be used in an alternate manner where the tap does not switch ViewControllers but instead executes a target-action.
                        
                        Simple. Lightweight. To-the-point.
                        DESC
  spec.requires_arc         = true
  spec.license              = { :type => 'BSD 3-clause “New” or “Revised”', :file => 'LICENSE' }
  spec.source_files         = ['HELargeCenterTabBarController/*.swift', 'HELargeCenterTabBarController/*.h']
  spec.platform             = :ios, '8.0'
  spec.module_name          = 'HELargeCenterTabBarController'
end
