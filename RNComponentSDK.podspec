Pod::Spec.new do |s|
  s.name         = 'RNComponentSDK'
  s.version      = '1.0.0'
  s.summary      = 'React Native component SDK with clean Swift API'
  s.description  = <<-DESC
                   A native iOS SDK that wraps React Native components with a clean Swift API.
                   Provides SmallTextComponent, LargeTextComponent, and async string array fetching.
                   Requires React Native to be configured in the consumer's app.
                   DESC
  s.homepage     = 'https://github.com/maxim-drobonoh/todolistsdk'
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.author       = { 'Maxim Drobonoh' => 'maxim@example.com' }
  
  # IMPORTANT: Point to monorepo root, but specify subdirectory
  s.source       = { 
    :git => 'https://github.com/maxim-drobonoh/todolistsdk.git', 
    :tag => "sdk-v#{s.version}" 
  }
  
  s.ios.deployment_target = '15.1'
  s.swift_version = '5.0'
  
  # Source files - relative to RNComponentSDK/ directory in monorepo
  s.source_files = 'RNComponentSDK/RNComponentSDK/**/*.{h,m,mm,swift}'
  s.public_header_files = 'RNComponentSDK/RNComponentSDK/RNComponentSDK.h'
  
  # Resources (JS bundle and fonts)
  s.resource_bundles = {
    'RNComponentSDK' => ['RNComponentSDK/RNComponentSDK/Resources/*']
  }
  
  # React Native is expected to be provided by the consumer's Podfile
  # via use_react_native!() - no explicit dependencies needed
  
  # Build settings
  s.pod_target_xcconfig = {
    'DEFINES_MODULE' => 'YES',
    'SWIFT_VERSION' => '5.0',
    'BUILD_LIBRARY_FOR_DISTRIBUTION' => 'YES',
    'CLANG_CXX_LANGUAGE_STANDARD' => 'c++20',
    'HEADER_SEARCH_PATHS' => '$(inherited) "${PODS_CONFIGURATION_BUILD_DIR}/React-Core/React_Core.framework/Headers" "${PODS_CONFIGURATION_BUILD_DIR}/React-hermes/React_hermes.framework/Headers"'
  }
  
  # User target build settings
  s.user_target_xcconfig = {
    'HEADER_SEARCH_PATHS' => '$(inherited) "${PODS_CONFIGURATION_BUILD_DIR}/React-Core/React_Core.framework/Headers"'
  }
  
  # Framework configuration
  s.requires_arc = true
  s.static_framework = true
  
  # Weak framework links (React Native will be linked by consumer)
  s.frameworks = 'UIKit', 'Foundation'
end
