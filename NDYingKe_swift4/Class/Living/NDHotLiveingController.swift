//
//  NDHotLiveingController.swift
//  NDYingKe_swift4
//
//  Created by 李家奇_南湖国旅 on 2017/8/30.
//  Copyright © 2017年 NorthDogLi. All rights reserved.
//

import UIKit



class NDHotLiveingController: UIViewController {
    
    var liveArrays :livess? //[livess]()//直播数据源
    
    var currentIndex : Int = 0 // 当前点击第几个
    
    
    fileprivate let CellID = "NDLiveRoomCell"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 原点从（0，0）开始
        self.automaticallyAdjustsScrollViewInsets = false
        self.view.backgroundColor = UIColor.clear
        
        self.collectionView.reloadData()
    }

    
    //完成消失
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        //发送通知
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: kNotificationClickUser), object: nil)
        //移除通知
        NotificationCenter.default.removeObserver(self)
    }
    
    deinit {
        print("释放播放controller")
    }
    
    
    lazy var collectionView: UICollectionView = {
        let collection = UICollectionView.init(frame: self.view.bounds, collectionViewLayout: NDLiveRoomFlowLayout.init())
        collection.register(NDHotCollectionCell.self, forCellWithReuseIdentifier: self.CellID)
        collection.delegate = self
        collection.dataSource = self
        
        self.view.addSubview(collection)
        
        collection.backgroundColor = UIColor.clear
        return collection
    }()
}

extension NDHotLiveingController : UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellID, for: indexPath) as! NDHotCollectionCell
        cell.controller = self
        
        cell.setlivHotData = self.liveArrays!
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
}
