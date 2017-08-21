//
//  Swift-Exstence.swift
//  我的微博
//
//  Created by 贺宁博 on 2017/8/10.
//  Copyright © 2017年 贺宁博. All rights reserved.
//

import Foundation
import UIKit
import SDWebImage
//https://api.weibo.com/oauth2/authorize
let WBAppKey = "3550053398"
let WBAppSecret = "ea767aee34dc1067cad64a14cd5cb1b9"
let WBRedirect_uri = "http://baidu.com"

let NotificationLogin = "userLogin"

//微博配图视图常量
let WBStatusPictureViewOutterMargin = CGFloat(11)
let WBStatusPictureViewInnerMargin = CGFloat(3)
let WBStatusPictureViewWidth = UIScreen.main.bounds.width - 2 * WBStatusPictureViewOutterMargin
let WBStatusPictureItemWidth = (WBStatusPictureViewWidth - 2 * WBStatusPictureViewInnerMargin)/3



let WBUserLoginSuccessNotication = "LoginSuccess"
extension Bundle {
    var nameSpace: String {
        return infoDictionary?["CFBundleName"] as?String ?? ""
    }
}

extension UIBarButtonItem {
    convenience init(title: String,target: AnyObject?,action:Selector,isBack: Bool = false) {
        let btn: UIButton = UIButton.cz_textButton(title, fontSize: 16, normalColor: UIColor.darkGray, highlightedColor: UIColor.orange)
        btn.addTarget(target, action: action, for: .touchUpInside)
        if isBack {
            let imageName = "navigationbar_back_withtext"
            btn.setImage(UIImage(named: imageName), for: .normal)
//            _highlighted
            btn.setImage(UIImage(named: imageName + "_highlighted"), for: .highlighted)
            btn.sizeToFit()
        }
        self.init(customView: btn)
 
    }
}

extension UIImageView {
    func cz_setImage(urlString: String?,placeholderImage: UIImage?, isAvatar: Bool = false) {
        guard let urlString = urlString,let url = URL(string: urlString) else {
            image = placeholderImage
            return
        }
        sd_setImage(with: url, placeholderImage: placeholderImage, options: []) { (image, _, _, _) in
//           完成回调
            if isAvatar {
               self.image = image?.cz_avatarImage(size: self.bounds.size)
            }
        }
    }
}

extension UIImage {
    func cz_avatarImage(size: CGSize,backColor: UIColor = UIColor.white,lineColor: UIColor = UIColor.darkGray) -> UIImage? {
        let rect = CGRect(origin: CGPoint(), size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, true, 0)
        backColor.setFill()
        UIRectFill(rect)
        
        let path = UIBezierPath(ovalIn: rect)
        path.addClip()
        draw(in: rect)
        
        let ovalPath = UIBezierPath(ovalIn: rect)
        
        ovalPath.lineWidth = 2
        lineColor.setStroke()
        ovalPath.stroke()
        
        let result = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return result
    }
}
