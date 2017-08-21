//
//  WBUser.swift
//  我的微博
//
//  Created by 贺宁博 on 2017/8/17.
//  Copyright © 2017年 贺宁博. All rights reserved.
//

import UIKit
import YYModel
//微博用户模型
class WBUser: NSObject {
    var id: Int64 = 0
    
    var screen_name: String?
//    用户头像地址
    var profile_image_url: String?
//    认证类型 -1 ：没有认证 0: 认证用户 2.3.5企业认证， 220：达人
    var verified_type: Int = 0
//     会员等级0-6
    var mbrank: Int = 0
    override var description: String {
        return yy_modelDescription()
    }
}
