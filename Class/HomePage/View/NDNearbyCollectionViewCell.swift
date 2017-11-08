//
//  NDNearbyCollectionViewCell.swift
//  NDYingKe_swift4
//
//  Created by <https://github.com/NorthDogLi> on 2017/9/8.
//  Copyright © 2017年 NorthDogLi. All rights reserved.
//

import UIKit
import SDWebImage.SDWebImageDownloader

class NDNearbyCollectionViewCell: UICollectionViewCell {

    
    @IBOutlet weak var userBackImageV: UIImageView!
    
    @IBOutlet weak var userImageV: UIImageView!
    
    @IBOutlet weak var peopleS: UILabel!
    
    @IBOutlet weak var distanceLb: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //userImageV.layer.cornerRadius = userImageV.ND_Height/2
    }
    
    public var nearbyModle = livess() {
        didSet {
            
            userBackImageV.setURLImageWithURL(url: URL.init(string: (nearbyModle.creator?.portrait)!)!, placeHoldImage: UIImage.init(named: "default_head")!, isCircle: false)
            
            userImageV.setURLImageWithURL(url: URL.init(string: (nearbyModle.creator?.portrait)!)!, placeHoldImage: UIImage.init(named: "default_head")!, isCircle: true)
            
            peopleS.text = String.init(format: "%d", arc4random_uniform(200)+arc4random_uniform(500))
            
            distanceLb.text = nearbyModle.distance
            
        }
    }
    
    

}
