//
//  NDRefreshGifHeader.swift
//  NDYingKe_swift4
//
//  Created by <https://github.com/NorthDogLi> on 2017/8/26.
//  Copyright © 2017年 NorthDogLi. All rights reserved.
//


import MJRefresh


class NDRefreshGifHeader: MJRefreshGifHeader {
    
    fileprivate var refreshImages = [UIImage]()//刷新图片的数组
    fileprivate var idleArr = [UIImage]()
    
    // 闭包
    //public var refreshBlock : (() -> Void)?
    
    //fileprivate let gifHeader = MJRefreshGifHeader()
    
    func refresh_GifHeader(refresh_Block:@escaping(String) -> ()) {
        
        //刷新
        self.lastUpdatedTimeLabel.isHidden = true
        self.stateLabel.isHidden = true
        
        for i in 1 ..< 30 {
            let refresStr = String.init(format: "refresh_fly_00%d", i)
            
            refreshImages.append(UIImage.init(named: refresStr)!)
        }
        self.setImages(refreshImages, duration: 1.5, for: MJRefreshState.refreshing)
        
        for i in 22 ..< 29 {
            let refresStrs = String.init(format: "refresh_fly_00%d", i)
            
            idleArr.append(UIImage.init(named: refresStrs)!)
        }
        self.setImages(idleArr, for: MJRefreshState.idle)
        self.setImages(idleArr, for: MJRefreshState.pulling)
        
        self.refreshingBlock = { () -> Void in
            //回调
            refresh_Block(kSucceed)
        }
    }

}
