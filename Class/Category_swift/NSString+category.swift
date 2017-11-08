//
//  NSString+category.swift
//  UI_Overload
//
//  Created by <https://github.com/NorthDogLi> on 2017/8/1.
//  Copyright © 2017年 <https://github.com/NorthDogLi>. All rights reserved.
//

import UIKit



extension String {
    
    //MARK: 判断字符串中是否含有表情   好像会很卡～～～～～
    var containsEmoji: Bool {
        for scalar in unicodeScalars {
            switch scalar.value {
            case
            0x00A0...0x00AF,
            0x2030...0x204F,
            0x2120...0x213F,
            0x2190...0x21AF,
            0x2310...0x329F,
            0x1F000...0x1F9CF:
                return true
            default:
                continue
            }
        }
        return false
    }
    
}
