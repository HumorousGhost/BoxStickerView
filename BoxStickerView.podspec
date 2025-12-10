#
# Be sure to run `pod lib lint BoxStickerView.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'BoxStickerView'
  s.version          = '1.0.0'
  s.summary          = 'A customizable sticker view component for iOS with drag, rotate, and scale gestures.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
BoxStickerView is a flexible iOS component that allows users to add, manipulate, and customize stickers 
with intuitive gestures including dragging, rotating, and scaling. Perfect for photo editing apps 
or any application requiring image annotation capabilities.
                       DESC

  s.homepage         = 'https://github.com/HumorousGhost/BoxStickerView'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'HumorousGhost' => 'superzhangliqun@gmail.com' }
  s.source           = { :git => 'https://github.com/HumorousGhost/BoxStickerView.git', :tag => s.version }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '10.0'

  s.swift_versions   = [5.0, 5.1, 5.2]

  s.source_files = 'BoxStickerView/Classes/**/*'
  
  # s.resource_bundles = {
  #   'BoxStickerView' => ['BoxStickerView/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'UIKit', 'CoreGraphics', 'Foundation'
  # s.dependency 'AFNetworking', '~> 2.3'
end
