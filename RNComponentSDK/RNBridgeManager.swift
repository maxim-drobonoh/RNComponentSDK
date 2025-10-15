//
//  RNBridgeManager.swift
//  RNComponentSDK
//
//  Manages React Native bridge lifecycle
//

import Foundation
import React

/// Manages the React Native bridge for the SDK
@objc public class RNBridgeManager: NSObject {
    
    // MARK: - Singleton
    
    @objc public static let shared = RNBridgeManager()
    
    // MARK: - Properties
    
    private var bridge: RCTBridge?
    private var isInitialized = false
    private let bundleName = "main.jsbundle"
    
    // MARK: - Initialization
    
    private override init() {
        super.init()
    }
    
    // MARK: - Public Methods
    
    /// Initialize the React Native bridge
    /// - Returns: True if initialization succeeded, false otherwise
    @objc public func initializeBridge() -> Bool {
        guard !isInitialized else {
            print("[RNBridgeManager] Bridge already initialized")
            return true
        }
        
        guard let jsCodeLocation = getBundleURL() else {
            print("[RNBridgeManager] ERROR: Could not locate JS bundle")
            return false
        }
        
        print("[RNBridgeManager] Initializing bridge with bundle: \(jsCodeLocation)")
        
        do {
            bridge = RCTBridge(bundleURL: jsCodeLocation, moduleProvider: nil, launchOptions: nil)
            isInitialized = true
            print("[RNBridgeManager] Bridge initialized successfully")
            return true
        } catch {
            print("[RNBridgeManager] ERROR: Failed to initialize bridge: \(error)")
            return false
        }
    }
    
    /// Get the active bridge instance
    /// - Returns: The RCTBridge instance, or nil if not initialized
    @objc public func getBridge() -> RCTBridge? {
        if !isInitialized {
            _ = initializeBridge()
        }
        return bridge
    }
    
    /// Reload the React Native bundle (useful for development)
    @objc public func reloadBridge() {
        print("[RNBridgeManager] Reloading bridge...")
        bridge?.reload()
    }
    
    /// Invalidate and cleanup the bridge
    @objc public func invalidateBridge() {
        print("[RNBridgeManager] Invalidating bridge...")
        bridge?.invalidate()
        bridge = nil
        isInitialized = false
    }
    
    // MARK: - Private Methods
    
    private func getBundleURL() -> URL? {
        // Try to get bundle from framework resources
        let frameworkBundle = Bundle(for: type(of: self))
        
        // First try to load from framework bundle
        if let bundleURL = frameworkBundle.url(forResource: bundleName.replacingOccurrences(of: ".jsbundle", with: ""), withExtension: "jsbundle") {
            print("[RNBridgeManager] Found bundle in framework: \(bundleURL)")
            return bundleURL
        }
        
        // Try without extension
        if let bundleURL = frameworkBundle.url(forResource: bundleName, withExtension: nil) {
            print("[RNBridgeManager] Found bundle in framework (no extension): \(bundleURL)")
            return bundleURL
        }
        
        print("[RNBridgeManager] ERROR: Bundle not found in framework resources")
        print("[RNBridgeManager] Framework bundle path: \(frameworkBundle.bundlePath)")
        print("[RNBridgeManager] Looking for: \(bundleName)")
        
        return nil
    }
}

