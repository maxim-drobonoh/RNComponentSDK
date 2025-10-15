//
//  RNComponentSDK.h
//  RNComponentSDK
//
//  iOS Framework wrapper for React Native components
//

#import <Foundation/Foundation.h>

//! Project version number for RNComponentSDK.
FOUNDATION_EXPORT double RNComponentSDKVersionNumber;

//! Project version string for RNComponentSDK.
FOUNDATION_EXPORT const unsigned char RNComponentSDKVersionString[];

// Import React Native headers for internal use
#if __has_include(<React/RCTBridge.h>)
#import <React/RCTBridge.h>
#import <React/RCTRootView.h>
#import <React/RCTBundleURLProvider.h>
#else
#import "RCTBridge.h"
#import "RCTRootView.h"
#import "RCTBundleURLProvider.h"
#endif

