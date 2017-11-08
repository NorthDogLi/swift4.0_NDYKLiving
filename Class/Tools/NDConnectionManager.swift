//
//  NDConnectionManager.swift
//  NDFX_swift
//
//  Created by <https://github.com/NorthDogLi> on 2017/6/13.
//  Copyright © 2017年 <https://github.com/NorthDogLi>. All rights reserved.
//

import UIKit
import Alamofire


enum ConnectionType {
    case Get
    case Post
}


class NDConnectionManager: NSObject {

    //单例创建
    static let shareManager : NDConnectionManager = {
        let manager = NDConnectionManager()
        
        return manager
    }()
    
    //回调成功和失败的 闭包方法
    /*
     *例外一种闭包写法
     func segmentBarTarget(selectedIndex:(NSInteger), string:(String) -> (String)) {
     }
    */
    func request(Type:ConnectionType, url:String, parames:[String:AnyObject], succeed:@escaping(String?, AnyObject?)->(), failure:@escaping(String?)->() ) {
        
        Alamofire.request(url, method:.get, parameters:parames).responseJSON { (retultOb) in
            
            switch retultOb.result {
                
            //成功
            case .success:
                
                if let value = retultOb.result.value{
                    // 成功闭包
                    succeed("succeed", value as AnyObject)
                }
                
            //失败
            case .failure:
                
                failure("failure")
            }
        }
    }
    
    
}
