//
//  NDLoginDataModel.swift
//  NDYingKe_swift4
//
//  Created by <https://github.com/NorthDogLi> on 2017/8/12.
//  Copyright © 2017年 NorthDogLi. All rights reserved.
//

import UIKit

class NDLoginDataModel: NSObject {

    
    
    var resources = [resour]()
    
    
    func getAdvertiseModel(message:@escaping(String)->()) {
        NDConnectionManager.shareManager.request(Type: ConnectionType.Post, url: kTJPAdvertiseAPI, parames: kParame as [String : AnyObject], succeed: { [unowned self] (suc, value) in
            
            let model = NDLoginDataModel.model(withJSON: value as AnyObject)
            
            self.getAssagin(model: model!)
            
            message(kSucceed)
            
        }) { (failer) in
            
            message(kFailer)
        }
    }
    
    
    func getAssagin(model:NDLoginDataModel) {
        resources = model.resources
        
    }
    static func modelContainerPropertyGenericClass() -> [String : AnyObject]? {
        return ["resources"    : resour.self]
    }
}

class resour: NSObject {
    var action :String!
    var image :String!
    var link :String!
    var position :String!
}
