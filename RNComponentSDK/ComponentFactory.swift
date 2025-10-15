//
//  ComponentFactory.swift
//  RNComponentSDK
//
//  Public API for creating React Native components
//

import Foundation
import UIKit
import React

/// Factory class for creating native UI components backed by React Native
@objc public class ComponentFactory: NSObject {
    
    // MARK: - Singleton
    
    @objc public static let shared = ComponentFactory()
    
    // MARK: - Initialization
    
    private override init() {
        super.init()
        // Ensure bridge is initialized
        _ = RNBridgeManager.shared.initializeBridge()
    }
    
    // MARK: - Public API
    
    /// Create a small text view (14pt)
    /// - Parameter text: The text to display
    /// - Returns: A UIView containing the React Native component
    @objc public func createSmallText(_ text: String) -> UIView {
        return createRootView(
            moduleName: "SmallTextComponent",
            initialProps: ["text": text]
        )
    }
    
    /// Create a large text view (24pt bold with check icon)
    /// - Parameter text: The text to display
    /// - Returns: A UIView containing the React Native component
    @objc public func createLargeText(_ text: String) -> UIView {
        return createRootView(
            moduleName: "LargeTextComponent",
            initialProps: ["text": text]
        )
    }
    
    /// Fetch an array of strings asynchronously
    /// - Parameter completion: Callback with the string array result
    @objc public func fetchStringArray(completion: @escaping ([String]?, Error?) -> Void) {
        // Create a unique callback ID
        let callbackId = UUID().uuidString
        
        // Get the bridge
        guard let bridge = RNBridgeManager.shared.getBridge() else {
            let error = NSError(
                domain: "RNComponentSDK",
                code: -1,
                userInfo: [NSLocalizedDescriptionKey: "Bridge not initialized"]
            )
            completion(nil, error)
            return
        }
        
        // Use JavaScript to call the async function
        DispatchQueue.main.async {
            bridge.enqueueJSCall(
                "RCTDeviceEventEmitter",
                method: "emit",
                args: ["fetchStringArray", ["callbackId": callbackId]],
                completion: { [weak self] in
                    // The JS side should call back through a native module
                    // For now, simulate the response
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        completion(["Data 1", "Data 2", "Data 3"], nil)
                    }
                }
            )
        }
    }
    
    /// Fetch an array of strings asynchronously (Swift async/await version)
    /// - Returns: Array of strings
    @available(iOS 13.0, *)
    public func fetchStringArray() async throws -> [String] {
        return try await withCheckedThrowingContinuation { continuation in
            fetchStringArray { result, error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else if let result = result {
                    continuation.resume(returning: result)
                } else {
                    let error = NSError(
                        domain: "RNComponentSDK",
                        code: -2,
                        userInfo: [NSLocalizedDescriptionKey: "No result returned"]
                    )
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    // MARK: - Private Methods
    
    private func createRootView(moduleName: String, initialProps: [String: Any]?) -> UIView {
        guard let bridge = RNBridgeManager.shared.getBridge() else {
            print("[ComponentFactory] ERROR: Bridge not initialized")
            return createErrorView(message: "Bridge not initialized")
        }
        
        let rootView = RCTRootView(
            bridge: bridge,
            moduleName: moduleName,
            initialProperties: initialProps
        )
        
        // Set a reasonable default size
        rootView?.backgroundColor = .clear
        rootView?.frame = CGRect(x: 0, y: 0, width: 320, height: 50)
        
        guard let view = rootView else {
            print("[ComponentFactory] ERROR: Failed to create RCTRootView for \(moduleName)")
            return createErrorView(message: "Failed to create component")
        }
        
        return view
    }
    
    private func createErrorView(message: String) -> UIView {
        let label = UILabel()
        label.text = "Error: \(message)"
        label.textColor = .red
        label.textAlignment = .center
        label.numberOfLines = 0
        label.frame = CGRect(x: 0, y: 0, width: 320, height: 50)
        
        let containerView = UIView()
        containerView.addSubview(label)
        containerView.frame = label.frame
        
        return containerView
    }
}

