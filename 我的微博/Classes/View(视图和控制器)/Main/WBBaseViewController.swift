//
//  WBBaseViewController.swift
//  我的微博
//
//  Created by 贺宁博 on 2017/8/10.
//  Copyright © 2017年 贺宁博. All rights reserved.
//

import UIKit

class WBBaseViewController: UIViewController {

    
    var visitorInfoDict: [String: String]?
    lazy var navigationBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: UIScreen.cz_screenWidth(), height: 64))
    lazy var navItem = UINavigationItem()
    
    var tableView: UITableView?
    var refreshControl: UIRefreshControl?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        automaticallyAdjustsScrollViewInsets = false
        setUpUI()
        WBHttpManager.shared.userLogon ? loadData() : ()
        NotificationCenter.default.addObserver(self, selector: #selector(loginSuccess(n:)), name: NSNotification.Name(rawValue: WBUserLoginSuccessNotication), object: nil)
    }
    override var title: String? {
        didSet {
           navItem.title = title
        }
    }
    
    @objc func loginSuccess(n: Notification) {
//        更新成功
//        当view == nil 重新调loadView viewDidLoad
        navItem.leftBarButtonItem = nil
        navItem.rightBarButtonItem = nil
        
        view = nil
        NotificationCenter.default.removeObserver(self)
        
    }
    func loadData()  {
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
 
    }

}

extension WBBaseViewController {
    func setUpUI() {
        view.backgroundColor = UIColor.cz_random()
        setupNavigationBar()
        WBHttpManager.shared.userLogon ? setupTableView() : setupVisitorView()


    }
    
    private func setupNavigationBar() {
        view.addSubview(navigationBar)
        navigationBar.items = [navItem]
//        设置navBar整个背景的渲染颜色
        navigationBar.barTintColor = UIColor.cz_color(withHex: 0xF6F6F6)
//        设置navBar的字体颜色
        navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.darkGray]
//      设置系统按钮的文字颜色
        navigationBar.tintColor = UIColor.orange
        
    }
    func setupTableView()  {
        tableView = UITableView(frame: view.bounds, style: .plain)
        tableView?.delegate = self
        tableView?.dataSource = self
        tableView?.contentInset = UIEdgeInsets(top: navigationBar.bounds.height, left: 0, bottom: tabBarController?.tabBar.bounds.height ?? 49, right: 0)
        view.insertSubview(tableView!, belowSubview: navigationBar)

        tableView?.scrollIndicatorInsets = tableView!.contentInset
        refreshControl = UIRefreshControl()
        
        tableView?.addSubview(refreshControl!)
        
        refreshControl?.addTarget(self, action: #selector(loadData), for: .valueChanged)
        
    }
    
    func setupVisitorView() {
        let visitorView = WBVisitorView(frame: view.bounds)
        visitorView.visitorInfo = visitorInfoDict
        visitorView.registerButton.addTarget(self, action: #selector(regis), for: .touchUpInside)
        visitorView.loginButton.addTarget(self, action: #selector(login), for: .touchUpInside)

        view.insertSubview(visitorView, belowSubview: navigationBar)
//    设置导航条按钮
        navItem.leftBarButtonItem = UIBarButtonItem(title: "注册", style: .plain, target: self, action: #selector(regis))
        navItem.rightBarButtonItem = UIBarButtonItem(title: "登录", style: .plain, target: self, action: #selector(login))

    }
}

extension WBBaseViewController {
    @objc func login() {
       
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: NotificationLogin), object: nil)
    }
    @objc func regis() {
        
    }
}
//extence 中不能有属性
//extence 中不能重写父类 本类 的方法 拓展的方法可以重写
extension WBBaseViewController:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
//    基类知识准备方法，子类负责具体的实现
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}
