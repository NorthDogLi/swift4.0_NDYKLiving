//
//  NDBarButtonItem.swift
//  NDYingKe_swift4
//
//  Created by 李家奇_南湖国旅 on 2017/8/12.
//  Copyright © 2017年 NorthDogLi. All rights reserved.
//

import UIKit


extension UIBarButtonItem {
    
    class func creatBarItem(image:String, highImage:String, title:String, tagget:Any, action:Selector) -> UIBarButtonItem {
        
        let button = UIButton.init(type: UIButtonType.custom)
        button.setTitle(title, for: UIControlState.normal)
        button.setImage(UIImage.init(named: image), for: UIControlState.normal)
        button.setImage(UIImage.init(named: highImage), for: UIControlState.highlighted)
        button.addTarget(tagget, action: action, for: UIControlEvents.touchUpInside)
        
        button.sizeToFit()
        
        return UIBarButtonItem.init(customView: button)
    }
    
}

