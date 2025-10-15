//
//  RNReactBridge.m
//  RNComponentSDK
//
//  Objective-C wrapper to expose React Native types to Swift
//

#import "RNReactBridge.h"

#if __has_include(<React/RCTBridge.h>)
#import <React/RCTBridge.h>
#import <React/RCTRootView.h>
#import <React/RCTBundleURLProvider.h>
#elif __has_include(<React-Core/RCTBridge.h>)
#import <React-Core/RCTBridge.h>
#import <React-Core/RCTRootView.h>
#import <React-Core/RCTBundleURLProvider.h>
#else
#import "RCTBridge.h"
#import "RCTRootView.h"
#import "RCTBundleURLProvider.h"
#endif

@implementation RNReactBridge

+ (id)createBridgeWithBundleURL:(NSURL *)bundleURL {
    return [[RCTBridge alloc] initWithBundleURL:bundleURL
                                 moduleProvider:nil
                                  launchOptions:nil];
}

+ (UIView *)createRootViewWithBridge:(id)bridge
                          moduleName:(NSString *)moduleName
                   initialProperties:(nullable NSDictionary *)initialProperties {
    RCTBridge *rctBridge = (RCTBridge *)bridge;
    RCTRootView *rootView = [[RCTRootView alloc] initWithBridge:rctBridge
                                                      moduleName:moduleName
                                               initialProperties:initialProperties];
    return rootView;
}

+ (void)enqueueJSCall:(id)bridge
               module:(NSString *)module
               method:(NSString *)method
                 args:(NSArray *)args
           completion:(void (^)(void))completion {
    RCTBridge *rctBridge = (RCTBridge *)bridge;
    [rctBridge enqueueJSCall:module method:method args:args completion:completion];
}

@end

