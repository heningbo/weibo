//
//  WBWelcomeView.swift
//  我的微博
//
//  Created by 贺宁博 on 2017/8/16.
//  Copyright © 2017年 贺宁博. All rights reserved.
//

import UIKit
import SDWebImage
class WBWelcomeView: UIView {

    @IBOutlet weak var iconView: UIImageView!
   
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    class func welcomeView() -> WBWelcomeView {
        let nib = UINib(nibName: "WBWelcomeView", bundle: nil)
        let v = nib.instantiate(withOwner: nil, options: nil)[0] as! WBWelcomeView
        v.frame = UIScreen.main.bounds
        
        return v
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
//        只是xib的二进制文件将视图数据加载完成
//        还没有和代码连线建立起关系，所以开发时，千万不要在这个方法中处理UI
        
    }
    
    override func awakeFromNib() {
//        1、url
        guard let urlString = WBHttpManager.shared.userAccount.avatar_large,let url = URL(string: urlString) else {
            return
        }
        
        let placeImage = avatarImage(image: UIImage(named: "avatar_default_big")!, size: iconView.bounds.size)
        iconView.sd_setImage(with: url, placeholderImage: placeImage, options: [], completed: nil)
        iconView.layer.masksToBounds = true
        iconView.layer.cornerRadius = iconView.bounds.width * 0.5
        
    }
    func avatarImage(image: UIImage, size: CGSize) -> UIImage? {
//        图像的上下文 内存中开辟一个地址，跟屏幕无关
//        上下文
        let rect = CGRect(origin: CGPoint(), size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)
        image.draw(in: rect)
        
        let result = UIGraphicsGetImageFromCurrentImageContext()
//        关闭上下文
        UIGraphicsEndImageContext()
        
        return result
        
    }
//    视图添加到window上
    
   override func didMoveToWindow() {
        super.didMoveToWindow()
//    视图是使用自动布局设置的，只是设置了约束
//    当视图被添加到窗口上时，根据父视图的大小计算约束值，更新控件位置
    self.layoutIfNeeded()
    bottomConstraint.constant = bounds.size.height-200
    
    UIView.animate(withDuration: 1.0, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: [], animations: { (_) in
//        更新约束
        self.layoutIfNeeded()
    }) { (_) in
       
        UIView.animate(withDuration: 1.0, animations: { 
            self.tipLabel.alpha = 1
        }, completion: { (_) in
            self.removeFromSuperview()
        })
    }
    }
    
}
