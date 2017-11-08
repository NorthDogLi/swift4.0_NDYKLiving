//
//  UIColor+category.swift
//  UI_Overload
//
//  Created by <https://github.com/NorthDogLi> on 2017/7/31.
//  Copyright © 2017年 <https://github.com/NorthDogLi>. All rights reserved.
//

import UIKit

extension UIColor {
    
    // 用十六进制颜色创建UIColor
    class func colorWithHexString(color : NSString) -> UIColor {
        return UIColor.colorWithHexString_alpha(alpha: 1.0, color: color)
    }
    
    /// 用十六进制颜色创建UIColor
    class func colorWithHexString_alpha(alpha : CGFloat, color : NSString) -> UIColor {

        let set = NSCharacterSet()
        var strCo = color.trimmingCharacters(in: set as CharacterSet).uppercased()
        
        if strCo.characters.count != 7 {
            return self.clear
        }
        
        if strCo.hasPrefix("0X") {
            let index = strCo.index(strCo.startIndex, offsetBy:2)
            strCo = strCo.substring(from: index)
        }
        
        if strCo.hasPrefix("#") {
            let index = strCo.index(strCo.startIndex, offsetBy:1)
            strCo = strCo.substring(from: index)
        }
        
        
        //分割字符串
        var startIndex = strCo.index(strCo.startIndex, offsetBy:0)
        var endIndex = strCo.index(startIndex, offsetBy:2)
        
        let red = strCo.substring(with: startIndex..<endIndex)
        
        
        startIndex = strCo.index(strCo.startIndex, offsetBy: 2)
        endIndex = strCo.index(startIndex, offsetBy: 2)
        
        let greend = strCo.substring(with: startIndex..<endIndex)
        
        startIndex = strCo.index(strCo.startIndex, offsetBy: 4)
        endIndex = strCo.index(startIndex, offsetBy: 2)
        
        let blue = strCo.substring(with: startIndex..<endIndex)
        
        
        // 存储转换后的数值
        var r:UInt32 = 0, g:UInt32 = 0, b:UInt32 = 0
        
        // 分别转换进行转换
        Scanner(string: red).scanHexInt32(&r)
        
        Scanner(string: greend).scanHexInt32(&g)

        Scanner(string: blue).scanHexInt32(&b)
        
        return self.init(red: CGFloat(r)/255.0, green: CGFloat(g)/255.0, blue: CGFloat(b)/255.0, alpha: alpha)
    }
    
}
