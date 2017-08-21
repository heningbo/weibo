//
//  WBStatus.swift
//  我的微博
//
//  Created by 贺宁博 on 2017/8/13.
//  Copyright © 2017年 贺宁博. All rights reserved.
//

import UIKit
import YYModel
class WBStatus: NSObject {
// Int 类型在64位的机器是64位，在32位机器就是32位
//  如果不写Int在ipad2/iphone5/5c的机器上不能运行
    
    var id: Int64 = 0
//    微博信息内容
    var text: String?
//    转发数
    var reposts_count: Int = 0
//    评论数
    var comments_count: Int = 0
//    点赞数
    var attitudes_count: Int = 0
//    微博的用户
//    设置的变量和服务器返回的一样
    var user: WBUser?
    
    var pic_urls: [WBtatusPicture]?
//    重写description 的计算型属性
    override var description: String {
        return yy_modelDescription()
    }
//    类函数 -> 告诉第三方框架YY_Model 如果遇到数组类型的属性，数组存放的是什么类
//    NSArray 中保存对象的类型通畅是id类型
//    oc中范性 是swift 推出后 苹果为了兼容给oc增加的
//    从运行时角度，仍然不知道数组中应该存放什么了什么类型的对象
    class func modelContainerPropertyGenericClass()-> [String: Any] {
        return ["pic_urls":WBtatusPicture.self]
    }

}
