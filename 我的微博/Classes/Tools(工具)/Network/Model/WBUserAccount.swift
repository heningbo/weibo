//
//  WBUserAccount.swift
//  我的微博
//
//  Created by 贺宁博 on 2017/8/14.
//  Copyright © 2017年 贺宁博. All rights reserved.
//

import UIKit
fileprivate let accountName = ("useraccount.json" as NSString)
class WBUserAccount: NSObject {
//访问令牌
    var access_token: String?
//    用户代号
    var uid: String?
    var expiresDate: Date?
    var expires_in: TimeInterval = 0 {
        didSet {
            expiresDate = Date(timeIntervalSinceNow: expires_in)
        }
    }
    
    var screen_name: String?//用户名字
    var avatar_large: String?//用户头像大图
//    accesstoken 生命周期 秒位单位
//    开发者 5年
//    使用者3天
    override var description: String {
        return yy_modelDescription()
    }
    
    override init() {
        super.init()
//        从磁盘加载保存文件
//        使用属性值
        
        guard let path = accountName.cz_appendDocumentDir(),let data = NSData(contentsOfFile: path),let dict = try? JSONSerialization.jsonObject(with: data as Data, options: []) as? [String: Any] else {
           return
        }
        print(path)
        yy_modelSet(with: dict ?? [:])
//        升序
        if expiresDate?.compare(Date()) != .orderedDescending {
           print("token过期")
//            清空token
            access_token = nil
            uid = nil
//            删除账户文件
           _ =  try? FileManager.default.removeItem(atPath: path)
        }
        
    }
    
//    偏好设置
//    沙盒 归档 plist／json
//    数据库
//    钥匙串访问(小/自动加密-需要使用框架sskeyChain)
    func saveAccount() {
//        1模型转字典
        var dict = self.yy_modelToJSONObject() as? [String: Any] ?? [:]
        dict.removeValue(forKey: "expires_in")
//        字典序列化 data
        guard let data = try? JSONSerialization.data(withJSONObject: dict, options: []), let fileName = accountName.cz_appendDocumentDir()
            else {
                return
        }
//          写入磁盘
        (data as NSData).write(toFile: fileName, atomically: true)
        
        
    }
}
