//
//  RNReactBridge.h
//  RNComponentSDK
//
//  Objective-C wrapper to expose React Native types to Swift
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// Wrapper for React Native bridge and view creation
@interface RNReactBridge : NSObject

/// Create and return an RCTBridge instance
+ (id)createBridgeWithBundleURL:(NSURL *)bundleURL;

/// Create an RCTRootView
+ (UIView *)createRootViewWithBridge:(id)bridge
                          moduleName:(NSString *)moduleName
                   initialProperties:(nullable NSDictionary *)initialProperties;

/// Enqueue a JavaScript call on the bridge (for async operations)
+ (void)enqueueJSCall:(id)bridge
               module:(NSString *)module
               method:(NSString *)method
                 args:(NSArray *)args
           completion:(void (^)(void))completion;

@end

NS_ASSUME_NONNULL_END
