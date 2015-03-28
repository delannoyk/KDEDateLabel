Pod::Spec.new do |s|
  s.name         = 'KDEDateLabel'
  s.version      = '1.0'
  s.license      =  { :type => 'MIT' }
  s.homepage     = 'https://github.com/delannoyk/KDEDateLabel'
  s.authors      = {
    'Kevin Delannoy' => 'delannoyk@gmail.com'
  }
  s.summary      = 'KDEDateLabel is an UILabel subclass that updates itself to make time ago\'s format easier.'

# Source Info
  s.platform     =  :ios, '8.0'
  s.source       =  {
    :git => 'https://github.com/delannoyk/KDEDateLabel.git',
    :tag => s.version.to_s
  }
  s.source_files = 'KDEDateLabel.swift'
  s.framework    =  'UIKit'

  s.requires_arc = true
end
