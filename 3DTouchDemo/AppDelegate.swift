//
//  AppDelegate.swift
//  3DTouchDemo
//
//  Created by Evan Mckee on 9/26/15.
//  Copyright © 2015 McKeeMaKer. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    var launchedShortcutItem:UIApplicationShortcutItem?
    
    enum ShortcutIdentifier: String {
        case First
        case Second
        
        // MARK: Initializers
        
        init?(fullType: String) {
            guard let last = fullType.componentsSeparatedByString(".").last else { return nil }
            
            self.init(rawValue: last)
        }
        
        // MARK: Properties
        
        var type: String {
            return NSBundle.mainBundle().bundleIdentifier! + ".\(self.rawValue)"
        }
    }
    
    static let applicationShortcutUserInfoIconKey = "applicationShortcutUserInfoIconKey"
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        var shouldPerformAdditionalDelegateHandling = true
        
        // If a shortcut was launched, display its information and take the appropriate action
        if let shortcutItem = launchOptions?[UIApplicationLaunchOptionsShortcutItemKey] as? UIApplicationShortcutItem {
            
            launchedShortcutItem = shortcutItem
            
            // This will block "performActionForShortcutItem:completionHandler" from being called.
            shouldPerformAdditionalDelegateHandling = false
        }
        
        // Install initial versions of our two extra dynamic shortcuts.
        if let shortcutItems = application.shortcutItems where shortcutItems.isEmpty {
            // Construct the items.
            let dynamicShortcut = UIMutableApplicationShortcutItem(type: ShortcutIdentifier.Second.type, localizedTitle: "Open JunkVC", localizedSubtitle: "dynamic item", icon: UIApplicationShortcutIcon(type: .Compose), userInfo: [
                AppDelegate.applicationShortcutUserInfoIconKey: UIApplicationShortcutIconType.Add.rawValue
                ]
            )
            
            
            // Update the application providing the initial 'dynamic' shortcut items.
            application.shortcutItems = [dynamicShortcut]
        }
        
        return shouldPerformAdditionalDelegateHandling
    }
    
    
    func handleShortcutItem(shortcutItem:UIApplicationShortcutItem)->Bool{
        var handled = false
        // Verify that the provided `shortcutItem`'s `type` is one handled by the application.
        guard ShortcutIdentifier(fullType: shortcutItem.type) != nil else { return false }
        
        guard let shortCutType = shortcutItem.type as String? else { return false }
        let tabBarVC = window!.rootViewController! as! UITabBarController
        
        
        print(tabBarVC.viewControllers)
        switch (shortCutType) {
        case ShortcutIdentifier.First.type:
            handled = true
            
            tabBarVC.selectedViewController = tabBarVC.viewControllers![1]
            break
        case ShortcutIdentifier.Second.type:
            handled = true
            
            let peekNav = tabBarVC.viewControllers![1] as! UINavigationController
            tabBarVC.selectedViewController = peekNav
            let junkVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("junkVC")
            peekNav.pushViewController(junkVC, animated: true)
            break
        default:
            break
        }
        
        return handled
        
        
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        guard let shortcut = launchedShortcutItem else { return }
        handleShortcutItem(shortcut)
        launchedShortcutItem = nil
    }
    
    
    
    func application(application: UIApplication, performActionForShortcutItem shortcutItem: UIApplicationShortcutItem, completionHandler: (Bool) -> Void) {
        let handledShortCutItem = handleShortcutItem(shortcutItem)
        
        completionHandler(handledShortCutItem)
    }
    
}

