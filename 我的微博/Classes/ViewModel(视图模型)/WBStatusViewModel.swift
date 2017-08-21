//
//  WBStatusViewModel.swift
//  我的微博
//
//  Created by 贺宁博 on 2017/8/17.
//  Copyright © 2017年 贺宁博. All rights reserved.
//

import Foundation
//表格的性能优化
//尽量少计算，所有需要的素材提前计算好
//控件上不要设置圆角半径，所有图像渲染的属性，都要注意
//不要动态创建控件，所有需要的控件，都要提前创建好
//cell中控件层级越少越好，数量越少越好
//如果没有任何父类 需要输出调试信息
//CustomStringConvertible协议 遵守后，实现description计算型属性

class WBStatusViewModel:CustomStringConvertible {

//    微博模型
    var status: WBStatus
    
//    会员图标 存储型属性 （用内存换cpu）
    
    var memberIcon: UIImage?
    
    var vipIcon: UIImage?
//    转发
    var retweetedStr: String?
//    评论
    var commentStr: String?
//    点赞文字
    var likeStr: String?
    
    var pictureViewSize = CGSize()
//    构造函数
    init(model: WBStatus) {
        self.status = model
        if (model.user?.mbrank)! > 0 && (model.user?.mbrank)! < 7 {
             let  imageName = "common_icon_membership_level\(model.user?.mbrank ?? 1)"
            memberIcon = UIImage(named: imageName)


        }
//        认证图标
        switch model.user?.verified_type ?? -1 {
        case 0:
            vipIcon = UIImage(named: "avatar_vip")
            
        case 2,3,5:
            vipIcon = UIImage(named: "avatar_enterprise_vip")
        case 220:
            vipIcon = UIImage(named: "avatar_grassroot")

        default:
            break
            
        }
        
        retweetedStr = countString(count: model.reposts_count, defaultStr: "转发")
        commentStr = countString(count: model.comments_count, defaultStr: "评论")
        likeStr = countString(count: model.attitudes_count, defaultStr: "点赞")
        
        pictureViewSize = calcPictureViewSize(count: model.pic_urls?.count ?? 0)




    }
    
    private func calcPictureViewSize(count: Int) -> CGSize {
         if count == 0  {
            return CGSize()
        }
//        计算配图视图的宽度
//        常数准备
        let row = (count - 1)/3 + 1
        
        let height = WBStatusPictureViewOutterMargin + CGFloat(row) * WBStatusPictureItemWidth + CGFloat(row - 1) * WBStatusPictureViewInnerMargin
        return CGSize(width: WBStatusPictureItemWidth, height: height)
    }

    var description: String {
        return status.description
    }
    func countString(count: Int,defaultStr: String)-> String  {
        if count == 0 {
            return defaultStr
        }
        if count < 10000 {
            return count.description
        }
        return String(format: "%.02f 万", count/10000)
    }
}
