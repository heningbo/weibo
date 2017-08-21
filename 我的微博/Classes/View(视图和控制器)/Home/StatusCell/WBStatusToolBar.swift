//
//  WBStatusToolBar.swift
//  我的微博
//
//  Created by 贺宁博 on 2017/8/18.
//  Copyright © 2017年 贺宁博. All rights reserved.
//

import UIKit

class WBStatusToolBar: UIView {

    var viewModel: WBStatusViewModel? {
        didSet {
            reweetedButton.setTitle(viewModel?.retweetedStr, for: [])
            commentButton.setTitle(viewModel?.commentStr, for: [])
            likeButton.setTitle(viewModel?.likeStr, for: [])

        }
    }
    //    转发
    @IBOutlet weak var reweetedButton: UIButton!
    //   评论
    @IBOutlet weak var commentButton: UIButton!
    //点赞
    @IBOutlet weak var likeButton: UIButton!

    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
