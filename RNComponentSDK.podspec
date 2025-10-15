Pod::Spec.new do |s|
  s.name         = 'RNComponentSDK'
  s.version      = '1.0.0'
  s.summary      = 'React Native component SDK with clean Swift API'
  s.description  = <<-DESC
                   A native iOS SDK that wraps React Native components with a clean Swift API.
                   Provides SmallTextComponent, LargeTextComponent, and async string array fetching.
                   Requires React Native 0.81.x to be installed in the consumer's app via npm.
                   DESC
  s.homepage     = 'https://github.com/maxim-drobonoh/RNComponentSDK'
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.author       = { 'Maxim Drobonoh' => 'maxim@example.com' }
  
  # Point to RNComponentSDK repository
  s.source       = { 
    :git => 'https://github.com/maxim-drobonoh/RNComponentSDK.git', 
    :tag => "v#{s.version}" 
  }
  
  s.ios.deployment_target = '15.1'
  s.swift_version = '5.0'
  
  # Source files - relative to repository root
  s.source_files = 'RNComponentSDK/**/*.{h,m,mm,swift}'
  s.public_header_files = 'RNComponentSDK/RNComponentSDK.h', 'RNComponentSDK/RNReactBridge.h'
  
  # Resources (JS bundle and fonts)
  s.resource_bundles = {
    'RNComponentSDK' => ['RNComponentSDK/Resources/*']
  }
  
  # React Native dependencies (will be resolved from consumer's node_modules)
  s.dependency 'React-Core'
  s.dependency 'React'
  s.dependency 'React-RCTImage'
  
  # Build settings
  s.pod_target_xcconfig = {
    'DEFINES_MODULE' => 'YES',
    'SWIFT_VERSION' => '5.0',
    'BUILD_LIBRARY_FOR_DISTRIBUTION' => 'YES',
    'CLANG_CXX_LANGUAGE_STANDARD' => 'c++20',
    'HEADER_SEARCH_PATHS' => '$(inherited) ' \
      '"${PODS_ROOT}/Headers/Public" ' \
      '"${PODS_ROOT}/Headers/Public/React-Core" ' \
      '"${PODS_ROOT}/Headers/Public/React" ' \
      '"${PODS_ROOT}/Headers/Public/React-RCTImage" ' \
      '"${PODS_ROOT}/Headers/Public/React-hermes" ' \
      '"${PODS_ROOT}/Headers/Private/React-Core" ' \
      '"${PODS_CONFIGURATION_BUILD_DIR}/React-Core/React_Core.framework/Headers" ' \
      '"${PODS_CONFIGURATION_BUILD_DIR}/React/React.framework/Headers" ' \
      '"${PODS_CONFIGURATION_BUILD_DIR}/React-hermes/React_hermes.framework/Headers"',
    'OTHER_CFLAGS' => '$(inherited) -DFOLLY_NO_CONFIG -DFOLLY_MOBILE=1 -DFOLLY_USE_LIBCPP=1',
    'USE_HEADERMAP' => 'YES'
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
