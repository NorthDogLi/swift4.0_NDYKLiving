//
//  NDLiveData.swift
//  NDYingKe_swift4
//
//  Created by <https://github.com/NorthDogLi> on 2017/8/25.
//  Copyright © 2017年 NorthDogLi. All rights reserved.
//

import UIKit

//热门接口数据
class NDLiveData: NSObject {
    
    var lives = [livess]()
    
    func getHotLivDatas(message:@escaping (String?) -> ()) {
        NDConnectionManager.shareManager.request(Type: ConnectionType.Get, url: kTJPHotLiveAPI, parames: kParame as [String : AnyObject], succeed: { (succes, responsObject) in
            
            let model = NDLiveData.model(withJSON: responsObject as AnyObject)
            self.lives = (model?.lives)!
            
            message(kSucceed)
            
        }) { (failer) in
            message(kFailer)
        }
    }
    
    static func modelContainerPropertyGenericClass() -> [String : AnyObject]? {
        return ["lives"    : livess.self]
    }
}

class livess: NSObject {
    /** 观看人数 */
    var online_users : String = ""
    /** 城市 */
    var city : String = ""
    /** ID号*/
    var id : String = ""
    /** 直播间名称*/
    var name : String = ""
    //直播间ID
    var room_id : String = ""
    //距离
    var distance : String = ""
    
    
    //cell高度
    var cellHeight : CGFloat = 300
    
    
    
    /** 直播流地址 */
    public var stream_addr = String() {
        didSet {
            if !stream_addr.hasPrefix("http") {
                self.stream_addr = kTJPCommonServiceAPI + self.stream_addr
            }
        }
    }
    /** 分享地址*/
    public var share_addr = String() {
        didSet {
            if !share_addr.hasPrefix("http") {
                self.share_addr = kTJPCommonServiceAPI + self.share_addr
            }
        }
    }
    
    /** 主播信息 */
    var creator : creators?
    /** 扩展属性*/
    var extra : extras?
    
    static func modelContainerPropertyGenericClass() -> [String : AnyObject]? {
        return ["creator"    : creators.self,
                "extra"  : extras.self]
    }
}

//主播个人信息
class creators: NSObject {
    var id : String = ""
    var level : String = ""
    var gender : String = ""
    var nick : String = ""
    
    public var portrait = String() {
        didSet {
            if !portrait.hasPrefix("http") {
                self.portrait = "http://img.meelive.cn/" + self.portrait
            }
        }
    }
}

//标签
class extras: NSObject {
    
    var label = [labelst]()
    
    static func modelContainerPropertyGenericClass() -> [String : AnyObject]? {
        return ["label"    : labelst.self]
    }
}

class labelst: NSObject {
    var tab_name : String = ""
    var tab_key : String = ""
}
