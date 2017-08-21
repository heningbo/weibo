//
//  WBMainViewController.swift
//  我的微博
//
//  Created by 贺宁博 on 2017/8/10.
//  Copyright © 2017年 贺宁博. All rights reserved.
//

import UIKit
import SVProgressHUD
//主控制器
class WBMainViewController: UITabBarController {

//    定时器
    fileprivate var timer: Timer?
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(presentAuthController(noti:)), name: NSNotification.Name(rawValue: NotificationLogin), object: nil)
        setupChildController()
        setupComposeButton()
        setupTimer()
        setupNewfeatrue()
        
        delegate = self

    }
    @objc func presentAuthController(noti: Notification) {
        
        if noti.object != nil {
            SVProgressHUD.setDefaultMaskType(.gradient)
         SVProgressHUD.showInfo(withStatus: "用户登录已过期，请重新登录")
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now()+1) { 
            SVProgressHUD.setDefaultMaskType(.clear)
            let vc = UINavigationController(rootViewController: WBOAuthViewController())
            self.present(vc, animated: true, completion: nil)

        }
    }
    /*
    
     protrait 竖屏
     landscape 横屏
     设置支持的方向之后，当前的控制器都会支持这个方向
    **/
//    @objc 允许这个函数在运行时通过消息机制调用
    @objc fileprivate func composeState() {
    
        print("撰写微博")
    }
    fileprivate lazy var composeButton: UIButton = UIButton.cz_imageButton("tabbar_compose_icon_add", backgroundImageName: "tabbar_compose_button")
    
    deinit {
//        定时器销毁
        timer?.invalidate()
    }
    

}


extension WBMainViewController {
    fileprivate func setupTimer() {
        timer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    @objc private func updateTimer() {
        //        测试未读数量
        if WBHttpManager.shared.userLogon {
            WBHttpManager.shared.unreadCount { (count) in
                print("有\(count)条新微博")
                //            设置tabBarItem的badgeNumber
                self.tabBar.items?[0].badgeValue = count > 0 ? "\(count)" : nil
                //            从ios8.0后要用户授权后才能显示
                UIApplication.shared.applicationIconBadgeNumber = count
            }
 
        }

    }
    
    
}
//extension中不能定义属性
extension WBMainViewController {
    fileprivate func setupComposeButton() {
        //        计算按钮的高度
        let count = CGFloat((viewControllers?.count)!)
        let w = tabBar.bounds.width / count
        tabBar.addSubview(composeButton)
        composeButton.frame = tabBar.bounds.insetBy(dx: 2 * w,dy: 0)
        composeButton.addTarget(self, action: #selector(composeState), for: .touchUpInside)
    }
    fileprivate func setupChildController() {
        
//        从bundle加载配置json
        guard let path = Bundle.main.path(forResource: "001", ofType: "json"),let data = NSData.init(contentsOfFile: path),let array = try?JSONSerialization.jsonObject(with: data as Data, options: []) as! [[String: Any]]  else {
            return
        }
        
        
        /*
        let array: [[String:Any]] = [
            ["clsName":"WBHomeViewController"  ,"title":"首页","imageName":"home","visitor":["imageName":"","message":"关注一些人，回这里看看有什么惊喜"]],["clsName":"WBMessageViewController","title":"消息","imageName":"message_center","visitor":["imageName":"visitordiscover_image_message","message":"登陆后，别人评论你的微博，发给你的消息，都会在这里受到通知"]],
            ["clsName":"UiViewController"],["clsName":"WBDiscoverViewController","title":"发现","imageName":"discover","visitor":["imageName":"visitordiscover_image_message","message":"登陆后，最新最热微博尽在掌握，不再会与实时潮流插肩而过"]],["clsName":"WBProfileViewController","title":"我","imageName":"profile","visitor":["imageName":"visitordiscover_image_profile","message":"登陆后，你的微博、相册、个人资料会显示在这里，显示给别人"]]]
         */
    var arrayM = [UIViewController]()
        for dict in array {
            arrayM.append(controller(dict: dict))
        }
        viewControllers = arrayM
        
    }
    private func controller(dict: [String: Any]) -> UIViewController {
        guard let clsName = dict["clsName"] as? String,let title = dict["title"] as? String,let imageName = dict["imageName"] as? String,let cls = NSClassFromString(Bundle.main.nameSpace + "." + clsName) as? WBBaseViewController.Type,let visitorDict = dict["visitor"] as? [String:String] else {
            return UIViewController()
        }
        
        let vc = cls.init()
        vc.title = title
        vc.visitorInfoDict = visitorDict
        vc.tabBarItem.image = UIImage(named: "tabbar_"+imageName)
        vc.tabBarItem.selectedImage = UIImage(named: "tabbar_"+imageName+"_selected")?.withRenderingMode(.alwaysOriginal)
//        设置tabbar的标题字体
        vc.tabBarItem.setTitleTextAttributes([NSForegroundColorAttributeName:UIColor.lightGray], for: .normal)
        vc.tabBarItem.setTitleTextAttributes([NSForegroundColorAttributeName:UIColor.orange], for: .selected)

//        实例化导航控制器的时候，会调用push方法，会将rootviewcontroller压栈
        let nav = WBNavigationController(rootViewController: vc)
        return nav
        
    }
}
extension WBMainViewController:UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
//    判断目标控制器是否是uiviewController
       let index = childViewControllers.index(of: viewController)
        
        if selectedIndex == 0 && index == selectedIndex {
//            让表格滚动到顶部
            let nav = childViewControllers[0] as! UINavigationController
            let vc = nav.childViewControllers[0] as! WBHomeViewController
            vc.tableView?.setContentOffset(CGPoint(x: 0, y: -64), animated: true)
            DispatchQueue.main.asyncAfter(deadline: .now()+1, execute: { 
                vc.loadData()
            })
        }
        
        return !viewController.isMember(of: UIViewController.self)
    }
}
//新特性视图处理
extension WBMainViewController {
    fileprivate func setupNewfeatrue() {
        
//        检查版本是否更新 
//        如果更新，显示新特性，否则显示欢迎
        let v = isNewVersion ? WBNewfeatrueView.newFeatureView() : WBWelcomeView.welcomeView()
        v.frame = view.bounds
        view.addSubview(v)
    }
    
    fileprivate var isNewVersion: Bool {
//      取当前的版本号
        
        let currentVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
        
//      取保存 Document （）目录中的之前的版本号
        
        let path: String = ("version" as NSString).cz_appendDocumentDir()
        
        let sandboxVersion = (try? String(contentsOfFile: path)) ?? ""
        
        _ = try? currentVersion.write(toFile: path, atomically: true, encoding: .utf8)
        //       返回两个版本号是否一致
        
        return currentVersion != sandboxVersion
    }
}
