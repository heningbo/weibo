//
//  WBHttpManager.swift
//  我的微博
//
//  Created by 贺宁博 on 2017/8/11.
//  Copyright © 2017年 贺宁博. All rights reserved.
//

import UIKit
import AFNetworking
//swift的枚举支持任意数据类型
//switch／enum在oc中都只支持整数
enum WBHTTPMethod {
    case GET
    case POST
}
class WBHttpManager: AFHTTPSessionManager {
//    网络管理工具
//    静态区／常量区
    static let shared: WBHttpManager = {
       let instance = WBHttpManager()
        
        instance.responseSerializer.acceptableContentTypes?.insert("text/plain")
        
        return instance
    }()
    
//    访问令牌，所有网络数据请求，并且将结果保存在shared常量中
//    "2.00mwJreGmDfPsD8b0e8a14bdwG3ETD"
    lazy var userAccount = WBUserAccount()
    var userLogon: Bool {
        return userAccount.access_token != nil
    }
    //    专门负责拼接token的网络请求方法
    func tokenRequest(method: WBHTTPMethod = .GET,URLString: String,parameters:[String:Any]?,completion:@escaping (_ json: Any?,_ isSuccess: Bool) -> ()) {
//       处理token字典
//        判断 参数token是否为nil 为nil，直接返回
        guard let token = userAccount.access_token else {
            print("没有token，需要登陆")
            completion(nil,false)
            return
        }
//        判断字典是否为nil
        var newParameters = parameters
        if newParameters == nil {
            newParameters = [:]
        }
        newParameters?["access_token"] = token
        
        
        
        
        request(method: method, URLString: URLString, parameters: newParameters!, completion: completion)
    }
//    网络请求
    func request(method: WBHTTPMethod = .GET,URLString: String,parameters:[String:Any],completion:@escaping (_ json: Any?,_ isSuccess: Bool) -> ()) {
        let success = { (task: URLSessionTask,json:Any?)->() in
            completion(json,true)
        }
        let failure = { (task: URLSessionTask?,error:Error)->() in
//           针对403 处理用户 token 过期
//           对于测试用户（应用程序还没有提交给新浪微博审核）每天的刷新是有效的
//            超出上限，token会被锁定一段时间
//            解决办法创建一个新的应用程序
            if (task?.response as? HTTPURLResponse)?.statusCode == 403 {
                print("token过期了")
//                FIXME:发送通知 提示用户再次登陆
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: NotificationLogin), object: "badToken")
            }
            completion(nil,false)
        }
        if method == .GET {
            get(URLString, parameters: parameters, progress: nil, success: success, failure: failure)
        } else
        {
            post(URLString, parameters: parameters, progress: nil, success: success, failure: failure)
 
        }

    }

}

