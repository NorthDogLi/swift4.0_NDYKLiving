//
//  NDUserDefauls.swift
//  NDYingKe_swift4.0
//
//  Created by <https://github.com/NorthDogLi> on 2017/8/10.
//  Copyright © 2017年 NorthDogLi. All rights reserved.
//

import UIKit

class NDUserDefauls: NSObject {

    
    //单例创建
//    static let shareDefauls : NDUserDefauls = {
//        let Defauls = NDUserDefauls()
//        
//        return Defauls
//    }()
    
    /** 是否登录*/
    class func isLogin() -> Bool {
        return KUserDefauls.bool(forKey: strisLogin)
    }
    
    /** 广告图片 */
    class func getAdvertiseImage() -> String {
        if KUserDefauls.string(forKey: AdImage_Name) == nil {
            return ""
        }
        return KUserDefauls.string(forKey: AdImage_Name)!
    }
    
    //存储登陆信息
    class func saveLoginMark(value:Bool) {
        KUserDefauls.set(value, forKey: strisLogin)
        KUserDefauls.synchronize()
    }
    
    /** 存储广告图片*/
    class func setAdvertiseImage(value:String) {
        KUserDefauls.set(value, forKey: AdImage_Name)
        KUserDefauls.synchronize()
    }
    
    /** 存储广告链接*/
    class func setAdvertiseLink(value:String) {
        KUserDefauls.set(value, forKey: AdImage_Link)
        KUserDefauls.synchronize()
    }
    
    
}
