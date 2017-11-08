//
//  NDNearByViewController.swift
//  NDYingKe_swift4
//
//  Created by <https://github.com/NorthDogLi> on 2017/8/14.
//  Copyright © 2017年 NorthDogLi. All rights reserved.
//

import UIKit

//附近
class NDNearByViewController: UIViewController {

    let nearbyData = NDNearbyModel()
    
    fileprivate let collectionID : String = "collectionID"
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // 原点从（0，0）开始
        //self.automaticallyAdjustsScrollViewInsets = false
        self.view.backgroundColor = UIColor.colorWithHexString(color: "#e7e7e7")
        
        initNearByData()
    }
    
    fileprivate func initNearByData() {
        nearbyData.getNearbyDatas { [unowned self] (message) in
            if message == kSucceed {
                self.collectionView.reloadData()
            }
            self.collectionView.mj_header.endRefreshing()
        }
    }
    
    lazy var collectionView: UICollectionView = {
        //创建collectionView
        let flowLayout = NDCollectionView()
        let collection = UICollectionView.init(frame: CGRect.init(x: 0, y: 64, width: kSCREEN_WIDTH, height: kSCREEN_HEIGHT-60), collectionViewLayout: flowLayout)
        self.view.addSubview(collection)
        //注册
        collection.register(UINib.init(nibName: "NDNearbyCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: self.collectionID)
        //collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: collectionID)
        
        collection.dataSource = self
        collection.delegate = self
        collection.backgroundColor = UIColor.white
        
        //加载下拉刷新
        let gifHeader = NDRefreshGifHeader()
        collection.mj_header = gifHeader
        gifHeader.refresh_GifHeader { [unowned self](message) in
            self.initNearByData()
        }
        
        return collection
    }()
}


extension NDNearByViewController : UICollectionViewDataSource, UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return nearbyData.flow.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: collectionID, for: indexPath) as! NDNearbyCollectionViewCell
        
        cell.nearbyModle = nearbyData.flow[indexPath.row].info!
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let hotLivController = NDHotLiveingController()
        hotLivController.currentIndex = indexPath.row
        hotLivController.liveArrays = nearbyData.flow[indexPath.row].info
        
        self.present(hotLivController, animated: true, completion: nil)
    }
    
}
