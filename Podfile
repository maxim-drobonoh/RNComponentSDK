# Podfile for RNComponentSDK Framework

platform :ios, '15.1'

# Relative path to React Native
$RNPath = '../todolist-example-rn-app/node_modules/react-native'

# Load React Native scripts
require File.join(__dir__, $RNPath, 'scripts', 'react_native_pods.rb')

prepare_react_native_project!

inhibit_all_warnings!

target 'RNComponentSDK' do
  use_frameworks! :linkage => :static
  
  # Install React Native pods
  use_react_native!(
    :path => $RNPath,
    :hermes_enabled => true,
    :app_path => "#{__dir__}"
  )
  
  post_install do |installer|
    react_native_post_install(
      installer,
      $RNPath,
      :mac_catalyst_enabled => false
    )
    
    installer.pods_project.targets.each do |target|
      target.build_configurations.each do |config|
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '15.1'
        config.build_settings['BUILD_LIBRARY_FOR_DISTRIBUTION'] = 'YES'
        config.build_settings['ENABLE_BITCODE'] = 'NO'
        config.build_settings['SWIFT_VERSION'] = '5.0'
        config.build_settings['ONLY_ACTIVE_ARCH'] = 'NO'
        config.build_settings['OTHER_SWIFT_FLAGS'] ||= ['$(inherited)']
        config.build_settings['OTHER_SWIFT_FLAGS'] << '-enable-library-evolution'
        config.build_settings['CLANG_CXX_LANGUAGE_STANDARD'] = 'c++20'
      end
    end
  end
end
