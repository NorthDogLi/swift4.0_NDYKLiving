//
//  NDLiveRoomFlowLayout.swift
//  NDYingKe_swift4
//
//  Created by 李家奇_南湖国旅 on 2017/8/31.
//  Copyright © 2017年 NorthDogLi. All rights reserved.
//

import UIKit

class NDLiveRoomFlowLayout: UICollectionViewFlowLayout {

    override func prepare() {
        super.prepare()
        self.scrollDirection = UICollectionViewScrollDirection.vertical
        self.itemSize = (self.collectionView?.bounds.size)!
        self.minimumLineSpacing = 0 //间距
        self.minimumInteritemSpacing = 0
        
        //滑动条
        self.collectionView?.showsVerticalScrollIndicator = false
        self.collectionView?.showsHorizontalScrollIndicator = false
    }
    
}
