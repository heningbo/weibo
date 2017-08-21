//
//  WBHomeViewController.swift
//  我的微博
//
//  Created by 贺宁博 on 2017/8/10.
//  Copyright © 2017年 贺宁博. All rights reserved.
//

import UIKit

fileprivate let cellID = "cellID"
class WBHomeViewController: WBBaseViewController {

    fileprivate lazy var listViewModel = WBStatuList_ViewModel()
    var isPull: Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @objc fileprivate func showFriends() {
        
    }
    override func loadData() {
        listViewModel.loadStatus(pullup: false) { (isSuccess, shouldRefresh) in
            self.refreshControl?.endRefreshing()

            if  shouldRefresh  {
                self.tableView?.reloadData()
            }
        }
    }

}

extension WBHomeViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listViewModel.statusList.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! WBStatusCell
        cell.viewModel = listViewModel.statusList[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
    let count = tableView.numberOfRows(inSection: indexPath.section)
        if indexPath.row == count-1 {
            listViewModel.loadStatus(pullup: true, complement: { (isSuccess, hasMorePull) in
                if hasMorePull && isSuccess  {
                    self.tableView?.reloadData()
                }

            })
        }
        
    }
    
}

extension WBHomeViewController {
    override func setupTableView() {
        super.setupTableView()
//        设置导航栏按钮
        
        navItem.leftBarButtonItem = UIBarButtonItem(title: "好友", target: self, action: #selector(showFriends))
        tableView?.rowHeight = UITableViewAutomaticDimension
        tableView?.estimatedRowHeight = 300
        tableView?.separatorStyle = .none
        tableView?.register(UINib(nibName: "WBStatusCell", bundle: nil), forCellReuseIdentifier: cellID)
        setupNavTitle()
    }
    func setupNavTitle() {
        let title = WBHttpManager.shared.userAccount.screen_name
        let button = UIButton.cz_textButton(title, fontSize: 17, normalColor: UIColor.darkGray, highlightedColor: UIColor.black)!
        button.setImage(UIImage(named: "navigationbar_arrow_down"), for: [])
        button.setImage(UIImage(named: "navigationbar_arrow_up"), for: .selected)
        button.sizeToFit()
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left:-(button.imageView?.width)! , bottom: 0, right: (button.imageView?.width)!)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: (button.titleLabel?.width)!, bottom: 0, right: -(button.titleLabel?.width)! )
        self.navItem.titleView = button
        button.addTarget(self, action: #selector(clickTitleButton(btn:)), for: .touchUpInside)

    }
    @objc func clickTitleButton(btn: UIButton) {
        btn.isSelected = !btn.isSelected
    }
    
}
