Pod::Spec.new do |s|
  s.name     = 'UAModalPanel'
  s.version  = '1.0'
  s.license  = 'BSD'
  s.summary  = 'An animated modal panel alternative for iOS.'
  s.homepage = 'http://coneybeare.net'
  s.author   = { 'Matt Coneybeare' => 'coneybeare@gmail.com' }
  s.source   = { :git => 'https://github.com/creativemess/UAModalPanel.git' }
  s.platform = :ios  
  s.source_files = 'UAModalPanel/Panel/Categories/UIView+JMNoise.{h,m}' , 'UAModalPanel/Panel/Panels/*.{h,m}' , 'UAModalPanel/Panel/Views/*.{h,m}'
  s.resources = "UAModalPanel/Panel/Images/*.png"
  s.framework = 'UIKit' , 'QuartzCore'
end