# Uncomment this line to define a global platform for your project
# platform :ios, '9.0'

target 'HackerNews' do
  # Comment this line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for HackerNews
  pod 'Firebase/Database'
  pod "PromiseKit", "~> 4.1.7"
  pod 'NSDate+TimeAgo'
  pod 'Alamofire', '~> 4.0'
  pod "Texture"
  pod 'AMScrollingNavbar'
  pod 'PINCache'
  pod 'XLPagerTabStrip', '~> 6.0'
  pod 'MBProgressHUD'

end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['SWIFT_VERSION'] = '3.0'
    end
  end
end
