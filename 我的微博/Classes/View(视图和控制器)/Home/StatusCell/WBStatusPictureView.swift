//
//  WBStatusPictureView.swift
//  我的微博
//
//  Created by 贺宁博 on 2017/8/18.
//  Copyright © 2017年 贺宁博. All rights reserved.
//

import UIKit

class WBStatusPictureView: UIView {

    var urls: [WBtatusPicture]? {
        didSet {
            for v in subviews {
                v.isHidden = true
            }
            var index = 0
            
            for url in urls ?? [] {
                
                let iv = subviews[index] as! UIImageView
                if index == 1 && urls?.count == 4 {
                    index += 1
                }
                iv.cz_setImage(urlString: url.thumbnail_pic, placeholderImage: nil)
//                显示图像
                iv.isHidden = false
                index += 1
            }
            
        }
    }
    @IBOutlet weak var heightCons: NSLayoutConstraint!

    override func awakeFromNib() {
        setupUI()
    }
}

extension WBStatusPictureView {
//    cell中的所有的控件都是提前设置好
//    设置的时候，根据数据决定是否显示
//    不要动态创建控件
    fileprivate func setupUI() {
        backgroundColor = super.backgroundColor
        let count = 9
        clipsToBounds = true
        let rect = CGRect(x: 0, y: WBStatusPictureViewOutterMargin, width: WBStatusPictureItemWidth, height: WBStatusPictureItemWidth)
        for i in 0..<count {
            let iv = UIImageView()
            
            let row = CGFloat(i / 3)
            let col = CGFloat(i % 3)
            
            let xOffSet = col * (WBStatusPictureItemWidth + WBStatusPictureViewInnerMargin)
            let yOffSet = row * (WBStatusPictureItemWidth + WBStatusPictureViewInnerMargin)
            iv.frame = rect.offsetBy(dx: xOffSet, dy: yOffSet)
            addSubview(iv)
        }
    }
}
