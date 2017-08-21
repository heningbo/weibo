//
//  WBHTTPManager+Extence.swift
//  我的微博
//
//  Created by 贺宁博 on 2017/8/12.
//  Copyright © 2017年 贺宁博. All rights reserved.
//

import Foundation

extension WBHttpManager {
    
    
    func statusList(since_id: Int64 = 0,max_id: Int64 = 0,completion: @escaping (_ list: [[String:Any]]?,_ isSuccess: Bool)->()) {
        let urlString = "https://api.weibo.com/2/statuses/home_timeline.json"
        let param = ["since_id":"\(since_id)",
                    "max_id":"\(max_id)"]
        tokenRequest(URLString: urlString, parameters: param) { (json, isSuccess) in
            let result = ((json as? [String:Any])?["statuses"]) as? [[String:Any]]
            completion(result,isSuccess)

        }
    }
    
    func unreadCount(completion: @escaping (_ count: Int)->())  {
        let urlString = "https://api.weibo.com/2/remind/unread_count.json"
        guard let uid = userAccount.uid else {
            return
        }
        let parmeter = ["uid":uid]
        tokenRequest(URLString: urlString, parameters: parmeter) { (json, isSuccess) in
            let dict = json as? [String: Any]
            
            let count = dict?["status"] as? Int ?? 0
            
            completion(count)
        }
    }
    
}

extension WBHttpManager {
    func loadAccessToken(code: String,completion: @escaping(_ isSuccess: Bool)->()) {
        
        let urlString = "https://api.weibo.com/oauth2/access_token"
        let paramert = ["client_id":WBAppKey,
                        "client_secret":WBAppSecret,
                        "grant_type":"authorization_code",
                        "code":code,
                        "redirect_uri":WBRedirect_uri
                        ]

        request(method: .POST, URLString: urlString, parameters: paramert) { (json, isSuccess) in
            self.userAccount.yy_modelSet(with: json as? [String: Any] ?? [:])
            self.loadUserInfo(completion: { (dictInfo) in
//                用户信息加载完成再回调
                self.userAccount.yy_modelSet(with: dictInfo)
            self.userAccount.saveAccount()
                completion(isSuccess)
 
            })
        }
    }
}

extension WBHttpManager {
//   获取用户信息
    func loadUserInfo(completion: @escaping  (_ dict:[String: Any])->()) {
      guard let uid = userAccount.uid else {
       
        return
        }
        let urlString = "https://api.weibo.com/2/users/show.json"
        
        let params = ["uid":uid]
        tokenRequest(URLString: urlString, parameters: params) { (json, isSuccess) in
            completion(json as? [String:Any] ?? [:])
        }
    
    }
}



