# Podfile for RNComponentSDK Framework (Development Only)
# This file is used for developing the SDK itself, not by consumers

platform :ios, '15.1'

# Use local node_modules for React Native and Expo
require File.join(__dir__, 'node_modules/react-native/scripts/react_native_pods.rb')

# Add Expo autolinking support for development
begin
  require File.join(File.dirname(`node --print "require.resolve('expo/package.json')"`), "scripts/autolinking")
rescue
  puts "⚠️  Expo not found. Run: npm install expo expo-modules-core expo-font"
end

prepare_react_native_project!

inhibit_all_warnings!

target 'RNComponentSDK' do
  use_frameworks! :linkage => :static
  
  # Expo modules (required for fonts, icons, etc.)
  begin
    use_expo_modules!
  rescue => e
    puts "⚠️  Could not load Expo modules: #{e.message}"
    puts "    Run: npm install expo expo-modules-core expo-font"
  end
  
  # Install React Native pods from local node_modules
  use_react_native!(
    :path => './node_modules/react-native',
    :hermes_enabled => true,
    :app_path => "#{__dir__}"
  )
  
  post_install do |installer|
    react_native_post_install(
      installer,
      './node_modules/react-native',
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
