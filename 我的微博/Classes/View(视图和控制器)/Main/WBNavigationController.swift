//
//  WBNavigationController.swift
//  我的微博
//
//  Created by 贺宁博 on 2017/8/10.
//  Copyright © 2017年 贺宁博. All rights reserved.
//

import UIKit

class WBNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.isHidden = true
    }


}
extension WBNavigationController {
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if childViewControllers.count > 0 {
            
           viewController.hidesBottomBarWhenPushed = true
           var title = "返回"
            if let vc = viewController as? WBBaseViewController {
                if childViewControllers.count == 1 {
                    title = childViewControllers.first?.title ?? "返回"

                }
                vc.navItem.leftBarButtonItem = UIBarButtonItem(title: title, target: self, action: #selector(poptoparent), isBack: true)

            }
            
        }
        super.pushViewController(viewController, animated: true)
    }
    @objc private func poptoparent() {
        popViewController(animated: true)
    }
}
