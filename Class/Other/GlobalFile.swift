//
//  GlobalFile.swift
//  swift_非同凡享
//
//  Created by <https://github.com/NorthDogLi> on 2017/6/12.
//  Copyright © 2017年 <https://github.com/NorthDogLi>. All rights reserved.
//

import UIKit
import SnapKit //和masonry一样的功能
import YYKit.NSObject_YYModel //数据解析
import SDWebImage



//import IJKMediaFramework


//MARK: 屏幕设置系列
let kSCREEN_WIDTH = UIScreen.main.bounds.size.width
let kSCREEN_HEIGHT = UIScreen.main.bounds.size.height
let kSCREEN_BOUNDS = UIScreen.main.bounds
//顶部电池条的状态栏高度
let kStatubarHeight = UIApplication.shared.statusBarFrame.size.height

/** 高度667(6s)为基准比例！！！做到不同屏幕适配高度*/
let ND_HEI =  kSCREEN_HEIGHT/667.0

/** 宽度375.0f(6s)为基准比例！！！做到不同屏幕适配宽度  */
let ND_WID =  kSCREEN_WIDTH/375.0

let __LEFT = __X(x:12)


/** 适配屏幕宽度比例*f  */
func __X(x:CGFloat) -> CGFloat {
    return ND_WID * x
}

/** 适配屏幕高度比例*f  */
func __Y(y:CGFloat) -> CGFloat {
    return ND_HEI * y
}

func __FONT(x:CGFloat) -> UIFont {
    return UIFont.systemFont(ofSize: __X(x: x))
}

func __setCGRECT(x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat) -> CGRect {
    return CGRect(x: x, y: y, width: width, height: height)
}

/**  如果传入进来的name为空，会导致崩溃 因为必须返回有值 */
func __setImageName(name:String) -> UIImage {
    
    return UIImage(named: name)!
}


func __CGFloat(number:AnyObject) -> CGFloat {
    return CGFloat(number as! NSNumber)
}


let KUserDefauls = UserDefaults.standard

//MARK: 颜色系列
//导航栏颜色
let kGlobalLightBlueColor = UIColor.colorWithHexString(color: "#00d9c9")


