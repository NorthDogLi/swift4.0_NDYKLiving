//
//  NDHotTableCell.swift
//  NDYingKe_swift4
//
//  Created by 李家奇_南湖国旅 on 2017/9/6.
//  Copyright © 2017年 NorthDogLi. All rights reserved.
//

import UIKit

class NDHotTableCell: UITableViewCell {

    @IBOutlet weak var userImageV: UIImageView!
    
    @IBOutlet weak var userName: UILabel!
    
    @IBOutlet weak var usertags: UILabel!
    
    @IBOutlet weak var userLooks: UILabel!
    
    @IBOutlet weak var userBackImageV: UIImageView!
    
    @IBOutlet weak var lingLb: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //self.frame = CGRect.init(x: 0, y: 0, width: kSCREEN_WIDTH, height: __Y(y: 400))
        
        lingLb.layer.cornerRadius = lingLb.ND_Height/2
        lingLb.layer.borderWidth = 1.0
        lingLb.layer.borderColor = UIColor.white.cgColor
        
        usertags.isHidden = true
    }

    public var livData = livess() {
        didSet {
            userImageV.setURLImageWithURL(url: URL.init(string: (livData.creator?.portrait)!)!, placeHoldImage: UIImage.init(named: "default_head")!, isCircle: true)
            
            userBackImageV.setURLImageWithURL(url: URL.init(string: (livData.creator?.portrait)!)!, placeHoldImage: UIImage.init(named: "default_room")!, isCircle: false)
            
            userName.text = livData.creator?.nick
            userLooks.text = dealWithOnlineNumber(num: livData.online_users)
            
            //异步并行去创建
            DispatchQueue(label: "com.tags", qos: .userInitiated, attributes: .concurrent, autoreleaseFrequency: .workItem, target: nil).async {
                self.tagView.tagsLbArray = (self.livData.extra?.label)!
            }
            
            //刷新高度  xib直接赋值更新  不需要时时更新
            //self.layoutIfNeeded()
            livData.cellHeight = userBackImageV.frame.maxY + __LEFT
        }
    }
    
    fileprivate func dealWithOnlineNumber(num:String?) -> String {
        var resultStr = ""
        let numbers = (num! as NSString).floatValue
        if (numbers >= 10000) {
            resultStr = String.init(format: "%.1f万", numbers / 10000)
        }else if (numbers > 0) {
            resultStr = String.init(format: "%.zd", numbers)
        }
        return resultStr;
        
    }
    
    lazy var tagView: NDTagView = {
        let tagView = NDTagView()
        tagView.frame = CGRect.init(x: self.userName.ND_X, y: self.userName.frame.maxY+10, width: self.ND_Width-self.userName.ND_X, height: __Y(y: 18))
        
        self.addSubview(tagView)
        return tagView
    }()
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

