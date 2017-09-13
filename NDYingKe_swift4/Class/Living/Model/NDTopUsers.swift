//
//  NDTopUsers.swift
//  NDYingKe_swift4
//
//  Created by 李家奇_南湖国旅 on 2017/9/7.
//  Copyright © 2017年 NorthDogLi. All rights reserved.
//

import UIKit

class NDTopUsers: NSObject {

    
    var users = [creators]()
    
    /**  获取直播间用户的数据 */
    public func getTopUsers(userID:String ,message:@escaping (String)->() ) {
        
        let urlString = kTJPLivingRoomUserInfoAPI + userID + "&s_sg=c2681fa2c3c60a48e6de037e84df86f9&s_sc=100&s_st=1481858627"
        NDConnectionManager.shareManager.request(Type: ConnectionType.Post, url: urlString, parames: kParame as [String : AnyObject], succeed: { (succees, responseObject) in
            
            let model = NDTopUsers.model(withJSON: responseObject as AnyObject)
            self.users = (model?.users)!
            
            message(kSucceed)
            
        }) { (failer) in
            message(kFailer)
        }
    }
    
    static func modelContainerPropertyGenericClass() -> [String : AnyObject]? {
        return ["users"    : creators.self]
    }
}
