platform :ios, '9.0'
use_frameworks!

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['SWIFT_VERSION'] = '2.3'
      config.build_settings['MACOSX_DEPLOYMENT_TARGET'] = '10.10'
    end
  end
end

def install_pods
    pod 'RxSwift', '2.6.0'
    pod 'RxCocoa', '2.6.0'
    pod 'RealmSwift', '1.1.0'
end

def testing_pods
    pod 'Quick', '0.9.2'
    pod 'Nimble', '4.1.0'
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

