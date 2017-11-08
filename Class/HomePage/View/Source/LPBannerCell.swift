//
//  LPBannerCell.swift
//  LPBannerView
//
//  Created by Tony on 2017/8/16.
//  Copyright © 2017年 Tony. All rights reserved.
//

import UIKit

class LPBannerCell: UICollectionViewCell {
    
    /// 轮播图片
    public var imageView = UIImageView()
    /// 轮播标题
    private var titleLabel = UILabel()
    /// 属性是否已配置
    public var isConfigured = false
    /// 轮播文字label高度
    public var titleLabelHeight: CGFloat = 35
    /// 标题文字
    public var title = String() {
        didSet {
            titleLabel.text = String(format: "   %@", title)
            if title == "" {
                titleLabel.isHidden = true
            } else {
                titleLabel.isHidden = false
            }
        }
    }
    /// 轮播文字label字体颜色
    public var titleLabelTextColor = UIColor.white {
        didSet {
            titleLabel.textColor = titleLabelTextColor
        }
    }
    /// 轮播文字label字体大小
    public var titleLabelTextFont = UIFont.systemFont(ofSize: 15) {
        didSet {
            titleLabel.font = titleLabelTextFont
        }
    }
    /// 轮播文字label背景颜色
    public var titleLabelBackgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.5) {
        didSet {
            titleLabel.backgroundColor = titleLabelBackgroundColor
        }
    }
    /// 轮播文字label对齐方式
    public var titleLabelTextAlignment: NSTextAlignment = .left {
        didSet {
            titleLabel.textAlignment = titleLabelTextAlignment
        }
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        self.contentView.addSubview(imageView)
        titleLabel.isHidden = true
        titleLabel.numberOfLines = 0
        self.contentView.addSubview(titleLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        imageView.frame = self.bounds
        titleLabel.frame = CGRect(x: 0, y: self.bounds.height - titleLabelHeight, width: self.bounds.width, height: titleLabelHeight)
    }
}
