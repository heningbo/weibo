//
//  AppDelegate.swift
//  我的微博
//
//  Created by 贺宁博 on 2017/8/9.
//  Copyright © 2017年 贺宁博. All rights reserved.
//

import UIKit
import UserNotifications //ios10
import SVProgressHUD
import AFNetworking
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        setupAddition()
        window = UIWindow()
        window?.backgroundColor = UIColor.white
        window?.rootViewController = WBMainViewController()
        window?.makeKeyAndVisible()
        return true
    }
}
//MARK:-从服务器加载应用程序信息
extension AppDelegate {
//
    fileprivate func setupAddition() {
       
        SVProgressHUD.setMinimumDismissTimeInterval(1)
        AFNetworkActivityIndicatorManager.shared().isEnabled = true
        //        取得用户授权显示通知
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.badge,.sound]) { (success, error) in
                print("授权 + \(success ? "成功":"失败")")
            }
            
        } else {
            let notifySettings = UIUserNotificationSettings(types: .alert, categories: nil)
            UIApplication.shared.registerUserNotificationSettings(notifySettings)
            
        }

    }
}

