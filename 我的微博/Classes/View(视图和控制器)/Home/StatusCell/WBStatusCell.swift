//
//  WBStatusCell.swift
//  我的微博
//
//  Created by 贺宁博 on 2017/8/17.
//  Copyright © 2017年 贺宁博. All rights reserved.
//

import UIKit

class WBStatusCell: UITableViewCell {
//头像
    @IBOutlet weak var iconView: UIImageView!
   //姓名
    @IBOutlet weak var nameLabel: UILabel!
 //会员
    @IBOutlet weak var memberIconView: UIImageView!
   //时间
    @IBOutlet weak var timeLabel: UILabel!
    //来源
    @IBOutlet weak var sourceLabel: UILabel!
   //认证图标
    @IBOutlet weak var vipIconView: UIImageView!
//    微博正文
    @IBOutlet weak var statusLabel: UILabel!
    
    @IBOutlet weak var toolBar: WBStatusToolBar!
    
    @IBOutlet weak var picView: WBStatusPictureView!
    
    @IBOutlet weak var pictureTopCons: NSLayoutConstraint!
    var viewModel: WBStatusViewModel? {
        didSet {
           statusLabel.text = viewModel?.status.text
            nameLabel.text = viewModel?.status.user?.screen_name
            iconView.cz_setImage(urlString:  viewModel?.status.user?.profile_image_url, placeholderImage: UIImage(named: "avatar_default_small"), isAvatar: true)
            memberIconView.image = viewModel?.memberIcon
            vipIconView.image = viewModel?.vipIcon
            toolBar.viewModel = viewModel
            picView.heightCons.constant = viewModel?.pictureViewSize.height ?? 0
            picView.urls = viewModel?.status.pic_urls
        }
    }
    
    
        override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
