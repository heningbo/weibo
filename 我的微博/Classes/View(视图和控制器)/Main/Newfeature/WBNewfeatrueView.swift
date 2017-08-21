//
//  WBNewfeatrueView.swift
//  我的微博
//
//  Created by 贺宁博 on 2017/8/16.
//  Copyright © 2017年 贺宁博. All rights reserved.
//

import UIKit

class WBNewfeatrueView: UIView {
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var enterButton: UIButton!
    
    @IBOutlet weak var pageControl: UIPageControl!
    
    @IBAction func enterStatus() {
        removeFromSuperview()
    }
    class func newFeatureView() -> WBNewfeatrueView {
        let nib = UINib(nibName: "WBNewfeatrueView", bundle: nil)
        let v = nib.instantiate(withOwner: nil, options: nil)[0] as! WBNewfeatrueView
        v.frame = UIScreen.main.bounds
        
        return v
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //        只是xib的二进制文件将视图数据加载完成
        //        还没有和代码连线建立起关系，所以开发时，千万不要在这个方法中处理UI
        
    }
    override func awakeFromNib() {
        
        let count = 4
        
        let rect = UIScreen.main.bounds
        for i in 0..<count {
            
            let imageName = "new_feature_\(i+1)"
            let v = UIImageView(image: UIImage(named: imageName))
            v.frame = rect.offsetBy(dx: CGFloat(i) * rect.width, dy: 0)
            scrollView.addSubview(v)
        }
        
        scrollView.contentSize = CGSize(width: CGFloat(count+1) * rect.width, height: 0)
        scrollView.bounces = false
        scrollView.isPagingEnabled = true
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        
        scrollView.delegate = self
//        隐藏按钮
        enterButton.isHidden = true

        
    }

}

extension WBNewfeatrueView:UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let page = Int(scrollView.contentOffset.x / scrollView.bounds.width)
//        判断最后一页
        if page == scrollView.subviews.count {
            removeFromSuperview()
        }
        enterButton.isHidden = (page != scrollView.subviews.count-1)
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        enterButton.isHidden = true
        let page = Int(scrollView.contentOffset.x / scrollView.bounds.width + 0.5)
        
        pageControl.currentPage = page
        
        pageControl.isHidden = (page == scrollView.subviews.count)
    }
}
