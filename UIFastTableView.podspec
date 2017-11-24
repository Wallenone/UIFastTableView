#
# Be sure to run `pod lib lint UIFastTableView.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'UIFastTableView'
  s.version          = '0.2.2'
  s.summary          = 'A short description of UIFastTableView.'
# This description is used to generate tags and improv--e search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
这是一个被封装的控件快捷使用类库，里面有demo，通过demo直接可以使用控件类库
                       DESC

  s.homepage         = 'www.baidu.com'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'wallen' => '910082734@qq.com' }
  s.source           = { :git => 'https://github.com/Wallenone/UIFastTableView', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '7.0'

  s.source_files = 'UIFastTableView/Classes/**/*'
  
  # s.resource_bundles = {
  #   'UIFastTableView' => ['UIFastTableView/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
    s.dependency 'MJRefresh'
end
