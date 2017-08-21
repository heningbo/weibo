//
//  WBStatuList_ViewModel.swift
//  我的微博
//
//  Created by 贺宁博 on 2017/8/13.
//  Copyright © 2017年 贺宁博. All rights reserved.
//

import Foundation

fileprivate let maxPullTryTimes = 3
class WBStatuList_ViewModel {
//          微博模型懒加载
    lazy var statusList = [WBStatusViewModel]()
    
    private var pullupErrorTimes = 0
    func loadStatus(pullup: Bool,complement:@escaping (_ isSuccess: Bool,_ shouldRefresh: Bool)->())  {
        if pullup && pullupErrorTimes > maxPullTryTimes {
            complement(false,false)
            return
        }
//       since_id 取出第一条微博的id
        let since_id = pullup ? 0 : statusList.first?.status.id ?? 0
        let max_id = !pullup ? 0 : statusList.last?.status.id ?? 0
        WBHttpManager.shared.statusList(since_id: since_id, max_id: max_id, completion: { (list, isSuccess) in
//            判断网络请求是否成功
            if !isSuccess {
                complement(false,false)

            }
            
            var array = [WBStatusViewModel]()
            
            
            
            for dict in list ?? [] {
                guard let model = WBStatus.yy_model(with: dict) else {
                    continue
                }
                array.append(WBStatusViewModel(model: model))
                
            }
            if pullup {
                self.statusList += array
            } else {
                self.statusList = array + self.statusList

            }
//             判断上拉刷新的数据源
            if pullup && array.count == 0 {
                self.pullupErrorTimes += 1
                complement(isSuccess,false)

            } else {
//                完成回调
                complement(isSuccess,true)
            }

        })
    }
    
}
