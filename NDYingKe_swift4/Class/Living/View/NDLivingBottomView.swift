//
//  NDLivingBottomView.swift
//  NDYingKe_swift4
//
//  Created by 李家奇_南湖国旅 on 2017/9/6.
//  Copyright © 2017年 NorthDogLi. All rights reserved.
//

import UIKit

class NDLivingBottomView: UIView {

    enum LivingBottomViewBtnClickType {
        case hotMessageType
        case hot_e_mailClickType
        case hot_giftClickType
        case hot_shareClickType
        case hot_gobackClickType
    }
    
    /// 闭包
    public var bottomViewBtnClickBlock: ((LivingBottomViewBtnClickType) -> Void)?
    
    
    class func instanceFromNib() -> NDLivingBottomView {
        return Bundle.main.loadNibNamed("NDLivingBottomView", owner: nil, options: nil)?[0] as! NDLivingBottomView
    }
    
    
    @IBAction func hotMessage(_ sender: UIButton) {
        if (self.bottomViewBtnClickBlock != nil) {
            self.bottomViewBtnClickBlock?(LivingBottomViewBtnClickType.hotMessageType)
        }
    }
    
    @IBAction func hot_e_mailClick(_ sender: UIButton) {
        if (self.bottomViewBtnClickBlock != nil) {
            self.bottomViewBtnClickBlock?(LivingBottomViewBtnClickType.hot_e_mailClickType)
        }
    }
    
    @IBAction func hot_giftClick(_ sender: UIButton) {
        if (self.bottomViewBtnClickBlock != nil) {
            self.bottomViewBtnClickBlock?(LivingBottomViewBtnClickType.hot_giftClickType)
        }
    }
    
    @IBAction func hot_shareClick(_ sender: UIButton) {
        if (self.bottomViewBtnClickBlock != nil) {
            self.bottomViewBtnClickBlock?(LivingBottomViewBtnClickType.hot_shareClickType)
        }
    }
    
    @IBAction func hot_gobackClick(_ sender: UIButton) {
        if (self.bottomViewBtnClickBlock != nil) {
            self.bottomViewBtnClickBlock?(LivingBottomViewBtnClickType.hot_gobackClickType)
        }
    }

}
