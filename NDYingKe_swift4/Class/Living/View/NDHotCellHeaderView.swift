//
//  NDHotCellHeaderView.swift
//  NDYingKe_swift4
//
//  Created by 李家奇_南湖国旅 on 2017/9/7.
//  Copyright © 2017年 NorthDogLi. All rights reserved.
//

import UIKit

class NDHotCellHeaderView: UIView {

    //映票数量
    @IBOutlet weak var YPNumbers: UIButton!
    //映客号
    @IBOutlet weak var YKID: UILabel!
    //日期
    @IBOutlet weak var YKDate: UILabel!
    //
    @IBOutlet weak var userScrollerView: UIScrollView!
    //主播头像
    @IBOutlet weak var userHeaderImage: UIImageView!
    //主播名字
    @IBOutlet weak var userName: UILabel!
    //主播ID
    @IBOutlet weak var userID: UILabel!
    //关注
    @IBOutlet weak var userLove: UIButton!
    
    @IBOutlet weak var userView: UIView!
    
    let userModel = NDTopUsers()
    
    
    class func instanceFromNib() -> NDHotCellHeaderView {
        
        return Bundle.main.loadNibNamed("NDHotCellHeaderView", owner: nil, options: nil)?[0] as! NDHotCellHeaderView
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        print("headerView");
        
        userView.layer.cornerRadius = userView.ND_Height/2
        userLove.layer.cornerRadius = userLove.ND_Height/2
//        userHeaderImage.layer.cornerRadius = userHeaderImage.ND_Height/2
        YPNumbers.layer.cornerRadius = YPNumbers.ND_Height/2
        
//        YKID.textColor = UIColor.white
//        YKDate.textColor = UIColor.white
        
        userScrollerView.showsHorizontalScrollIndicator = false
        userScrollerView.showsVerticalScrollIndicator = false
    }
    

    //显示数据
    public var setLivess = livess() {
        didSet {
            self.userHeaderImage.setURLImageWithURL(url: URL.init(string: (setLivess.creator?.portrait)!)!, placeHoldImage: UIImage.init(named: "default_head")!, isCircle: true)
            let livName = setLivess.name as NSString
            
            if livName.length == 0 {
                self.userName.text = setLivess.creator?.nick
            }else {
                self.userName.text = setLivess.name
            }
            
            self.userID.text = setLivess.online_users//setLivess.creator?.id
            
            self.YKID.text = "映客号:" + (setLivess.creator?.id)!
            self.YKDate.text = NDTools.shareTool.getDate()
            
            self.YPNumbers.setTitle(String.init(format: "映票:%@", setLivess.online_users), for: UIControlState.normal)
            
            var contentWidth:CGFloat = 0.0
            
            userModel.getTopUsers(userID: setLivess.id) { [unowned self] (message) in
                if message == kSucceed {
                    for i in 0 ..< self.userModel.users.count {
                        let topImageV = UIImageView()
                        self.userScrollerView.addSubview(topImageV)
                        
                        topImageV.frame = CGRect.init(x: contentWidth, y: 0, width: self.userScrollerView.ND_Height, height: self.userScrollerView.ND_Height)
                        topImageV.setURLImageWithURL(url: URL.init(string: self.userModel.users[i].portrait)!, placeHoldImage: UIImage.init(named: "default_head")!, isCircle: true)
                        topImageV.clipsToBounds = true
                        topImageV.layer.cornerRadius = topImageV.ND_Height/2
                        
                        contentWidth = CGFloat(i) * (self.userScrollerView.ND_Height + 6)
                        
                        //let tap =
                        
                    }
                    
                    self.layoutIfNeeded()
                    self.userScrollerView.contentSize = CGSize.init(width: contentWidth+20, height: 0)
                }
            }
        }
    }
    
    
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
