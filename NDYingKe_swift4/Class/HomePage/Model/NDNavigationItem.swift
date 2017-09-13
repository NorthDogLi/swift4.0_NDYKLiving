//
//  NDNavigationItem.swift
//  NDYingKe_swift4
//
//  Created by 李家奇_南湖国旅 on 2017/8/12.
//  Copyright © 2017年 NorthDogLi. All rights reserved.
//

import UIKit

class NDNavigationItem: NSObject {
    
    var tabs = [tab]()
    var ticker = [ticke]()
    
    func getNavigationTagModels(message:@escaping(String)->() ) {
        
        NDConnectionManager.shareManager.request(Type: ConnectionType.Post, url: kTJPNavigationTagAPI, parames: kParame as [String : AnyObject], succeed: {[unowned self] (succees, responseObject) in
            
            let model = NDNavigationItem.model(withJSON: responseObject as AnyObject)
            
            self.getAssagin(model: model!)
            
            message("succeed")
            
        }) { (failer) in
            
            message("failer")
        }
    }
    
    //获取轮播图数据
    func getHeaderScrollerData(message:@escaping (String) ->()) {
        
        NDConnectionManager.shareManager.request(Type: ConnectionType.Post, url: kTJPHomeTopCarouselAPI, parames: kParame as [String : AnyObject], succeed: { (succees, responseObject) in
            
            let model = NDNavigationItem.model(withJSON: responseObject as AnyObject)
            self.ticker = (model?.ticker)!
            
            message(kSucceed)
            
        }) { (failer) in
            message(kFailer)
        }
    }
    
    
    func getAssagin(model:NDNavigationItem) {
        tabs = model.tabs
        
    }
    
    
    static func modelContainerPropertyGenericClass() -> [String : AnyObject]? {
        return ["tabs"    : tab.self,
                "ticker"  : ticke.self]
    }
}

class tab: NSObject {
    var offline_time : String = ""
    var selected : String = ""
    var sort : String = ""
    var tab_id : String = ""
    var tab_key : String = ""
    var tab_title : String = ""
}


class ticke: NSObject {
    var image : String = ""
    var link : String = ""
    var atom : String = ""
}
