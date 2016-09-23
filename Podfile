platform :ios, '9.0'
use_frameworks!

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['SWIFT_VERSION'] = '3.0'
      config.build_settings['MACOSX_DEPLOYMENT_TARGET'] = '10.10'
    end
  end
end

def install_pods
    pod 'RxSwift', '3.0.0-beta.1'
    pod 'RxCocoa', '3.0.0-beta.1'
    pod 'RealmSwift', '1.1.0'
end

def testing_pods
    pod 'Quick', :git => 'git@github.com:Quick/Quick.git', :branch => 'master'
    pod 'Nimble', '5.0.0'
end

target 'TODO' do
    install_pods
end

target 'TODOTests' do
    install_pods
    testing_pods
end

target 'TODOUITests' do

end

