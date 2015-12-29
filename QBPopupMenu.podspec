Pod::Spec.new do |s|
  s.name         = "QBPopupMenu"
  s.version      = "2.0"
  s.summary      = "Customizable popup menu for iOS."
  s.license      = "MIT"
  s.frameworks   = 'Foundation', 'CoreGraphics', 'UIKit'
  s.platform     = :ios, '5.0'
  s.source_files = 'QBPopupMenu/*.{h,m}'
  s.requires_arc = true
end
