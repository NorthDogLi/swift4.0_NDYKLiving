
//
//  NDNearbyModel.swift
//  NDYingKe_swift4
//
//  Created by <https://github.com/NorthDogLi> on 2017/9/8.
//  Copyright © 2017年 NorthDogLi. All rights reserved.
//

import UIKit

//附近接口数据
class NDNearbyModel: NSObject {
    
    var flow = [flows]()
    
    public func getNearbyDatas(message:@escaping (String) -> () ) {
        NDConnectionManager.shareManager.request(Type: ConnectionType.Post, url: kTJPNearFlowLiveAPI, parames: kParame as [String : AnyObject], succeed: { [unowned self] (succes, responsObject) in
            
            let model = NDNearbyModel.model(withJSON: responsObject as AnyObject)
            self.flow = (model?.flow)!
            
            message(kSucceed)
            
        }) { (failer) in
            
            message(kFailer)
        }
    }
    
    static func modelContainerPropertyGenericClass() -> [String : AnyObject]? {
        return ["flow"    : flows.self]
    }
}


class flows: NSObject {
    
    var info : livess?
    var flow_type : String = ""
    
    static func modelContainerPropertyGenericClass() -> [String : AnyObject]? {
        return ["info"    : livess.self]
    }
}
