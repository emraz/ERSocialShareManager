//
//  Extensions.swift
//  ERSocialShareManager
//
//  Created by Mahmudul Hasan on 6/7/21.
//

import Foundation
import UIKit


//https://stackoverflow.com/questions/26667009/get-top-most-uiviewcontroller
extension UIViewController {
    static func topMostViewController() -> UIViewController? {
        let keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        return keyWindow?.rootViewController?.topMostViewController()
    }
    
    func topMostViewController() -> UIViewController? {
        if let navigationController = self as? UINavigationController {
            return navigationController.topViewController?.topMostViewController()
        }
        else if let tabBarController = self as? UITabBarController {
            if let selectedViewController = tabBarController.selectedViewController {
                return selectedViewController.topMostViewController()
            }
            return tabBarController.topMostViewController()
        }
            
        else if let presentedViewController = self.presentedViewController {
            return presentedViewController.topMostViewController()
        }
        
        else {
            return self
        }
    }
}
