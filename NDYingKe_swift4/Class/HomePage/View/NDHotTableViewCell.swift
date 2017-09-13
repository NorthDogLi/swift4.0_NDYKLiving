//
//  NDHotTableViewCell.swift
//  NDYingKe_swift4
//
//  Created by 李家奇_南湖国旅 on 2017/8/25.
//  Copyright © 2017年 NorthDogLi. All rights reserved.
//

import UIKit

class NDHotTableViewCell: UITableViewCell {

    var userImageV = UIImageView() //头像
    var nameLb = UILabel() //名字
    var lookLb = UILabel() //人数
    var addressLb = UILabel() //地址
    var backImageV = UIImageView() //背景图片
    
    let tagView = NDTagView()
 
    lazy var liveLingLb : UILabel = {
        let liveLb = UILabel()
        liveLb.text = "直播"
        liveLb.font = __FONT(x: 14)
        liveLb.textColor = UIColor.white
        liveLb.textAlignment = NSTextAlignment.center
        liveLb.frame = CGRect.init(x: kSCREEN_WIDTH-__X(x: 60), y: __Y(y: 70), width: __X(x: 45), height: __Y(y: 18))
        
        liveLb.layer.masksToBounds = true
        liveLb.layer.cornerRadius = __Y(y: 18)/2
        liveLb.layer.borderWidth = 0.5
        liveLb.layer.borderColor = UIColor.white.cgColor
        
        return liveLb
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.frame = CGRect.init(x: 0, y: 0, width: kSCREEN_WIDTH, height: __Y(y: 400))
        
        self.backgroundColor = UIColor.white
        self.layer.masksToBounds = true
        self.layer.borderWidth = 0.5
        self.layer.borderColor = UIColor.gray.cgColor
    }
    
    override func prepareForReuse() {
        
    }
    
    override func layoutSubviews() {
        
        self.addSubview(userImageV)
        userImageV.frame = CGRect.init(x: __LEFT, y: 8, width: __X(x: 45), height: __X(x: 45))
        userImageV.clipsToBounds = true
        userImageV.layer.cornerRadius = userImageV.ND_Width/2
        
        
        self.addSubview(nameLb)
        nameLb.frame = CGRect.init(x: userImageV.frame.maxX+__LEFT, y: 8, width: __X(x: 200), height: __Y(y: 15))
        nameLb.textColor = UIColor.black
        nameLb.font = __FONT(x: 14)
        
        self.addSubview(lookLb)
        lookLb.frame = CGRect.init(x: self.ND_Width - __LEFT - __X(x: 50), y: 8, width: __X(x: 50), height: __Y(y: 13))
        lookLb.textColor = UIColor.orange
        lookLb.font = __FONT(x: 12)
        lookLb.textAlignment = NSTextAlignment.right
        
        self.addSubview(backImageV)
        backImageV.frame = CGRect.init(x: 0, y: userImageV.frame.maxY+8, width: self.ND_Width, height: self.ND_Height - userImageV.frame.maxY+__LEFT)
        
        self.addSubview(self.liveLingLb)
        
        
        tagView.frame = CGRect.init(x: self.nameLb.ND_X, y: self.nameLb.frame.maxY+10, width: self.ND_Width-self.nameLb.ND_X, height: __Y(y: 18))
        
        self.addSubview(tagView)
    }
    
    
    public var livData = livess() {
        didSet {
            
            userImageV.setURLImageWithURL(url: URL.init(string: (livData.creator?.portrait)!)!, placeHoldImage: UIImage.init(named: "default_head")!, isCircle: true)
            
            backImageV.setURLImageWithURL(url: URL.init(string: (livData.creator?.portrait)!)!, placeHoldImage: UIImage.init(named: "default_room")!, isCircle: false)
            
            nameLb.text = livData.creator?.nick
            lookLb.text = dealWithOnlineNumber(num: livData.online_users)
            
            //异步并行去创建
            DispatchQueue(label: "com.tags", qos: .userInitiated, attributes: .concurrent, autoreleaseFrequency: .workItem, target: nil).async {
                self.tagView.tagsLbArray = (self.livData.extra?.label)!
            }
            
            //刷新高度
            self.layoutIfNeeded()
            livData.cellHeight = backImageV.frame.maxY + __LEFT
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
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class NDTagView: UIView {
    
    var tagsLbArray = [labelst]() {
        didSet {
            
            var lastWidth:CGFloat = 0.0 //记录前面添加过的所有标签的宽度
            
            for i in 0 ..< tagsLbArray.count {
                
                let tagLb = UILabel()
                self.addSubview(tagLb)
                
                let __wid = NDTools.shareTool.sizeWithFont(font: __FONT(x: 10), width: CGFloat(MAXFLOAT), text: tagsLbArray[i].tab_name)
                let tagWidth = __wid.width + __X(x: 15)
                
                tagLb.frame = CGRect.init(x: lastWidth, y: 0, width: tagWidth, height: __wid.height + __Y(y: 6))
                //放在frame下面加载
                lastWidth += tagWidth + 6
                
                tagLb.font = __FONT(x: 10)
                tagLb.textAlignment = NSTextAlignment.center
                tagLb.textColor = kGlobalLightBlueColor
                
                tagLb.layer.masksToBounds = true
                tagLb.layer.cornerRadius = tagLb.ND_Height/2
                tagLb.layer.borderWidth = 0.5
                tagLb.layer.borderColor = kGlobalLightBlueColor.cgColor
                
                DispatchQueue.main.async {
                    tagLb.text = self.tagsLbArray[i].tab_name
                }
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    } 
}
