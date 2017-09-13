//
//  NDAdvertiseView.swift
//  NDYingKe_swift4
//
//  Created by 李家奇_南湖国旅 on 2017/8/11.
//  Copyright © 2017年 NorthDogLi. All rights reserved.
//

import UIKit
import SDWebImage

class NDAdvertiseView: UIView {

    fileprivate var adShowTime = 5
    fileprivate let duration:CFTimeInterval = 0.25
    fileprivate var timer = Timer()
    fileprivate let dataModel = NDLoginDataModel()
    
    //广告
    fileprivate var adImageView = UIImageView()
    fileprivate var showTimeBtn = UIButton()
    
 
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        //self.frame = CGRect.init(x: 0, y: 0, width: kSCREEN_WIDTH, height: kSCREEN_HEIGHT)
        
        setUpUI()
        
        initialization()
        
        advertiseShow()
    }
    
    func setUpUI() {
        
        self.addSubview(adImageView)
        self.adImageView.frame = self.frame
        adImageView.isUserInteractionEnabled = true
        let tapGes = UITapGestureRecognizer.init(target: self, action: #selector(adImageTap))
        adImageView.addGestureRecognizer(tapGes)
        
        //showTimeBtn = UIButton.init(type: UIButtonType.custom)
        self.addSubview(showTimeBtn)
        //重新布局
        showTimeBtn.frame = CGRect.init(x: self.ND_Width - __X(x: 70), y: __Y(y: 30), width: __X(x: 50), height: __X(x: 20))
        showTimeBtn.setTitleColor(UIColor.white, for: UIControlState.normal)
        showTimeBtn.backgroundColor = UIColor.init(colorLiteralRed: 0, green: 0, blue: 0, alpha: 0.8)
        showTimeBtn.titleLabel?.font = __FONT(x: 15)
        showTimeBtn.setTitle("跳过5", for: UIControlState.normal)
        showTimeBtn.layer.cornerRadius = 3
        showTimeBtn.layer.masksToBounds = true
        showTimeBtn.addTarget(self, action: #selector(goHomePage), for: UIControlEvents.touchUpInside)
    }
    
    fileprivate func initialization() {
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerGo), userInfo: nil, repeats: true)
        RunLoop.current.add(timer, forMode: RunLoopMode.commonModes)
        
        let launchImage = UIImage.init(named: self.getLaunchImage())
        self.adImageView.image = launchImage//UIColor.init(patternImage: launchImage!)
        
    }
    /** 展示广告*/
    fileprivate func advertiseShow() {
        
        let lastCacheImage = SDWebImageManager.shared().imageCache?.imageFromDiskCache(forKey: NDUserDefauls.getAdvertiseImage())
        
        if lastCacheImage == nil {
            
            downloadAdvertise()
        }else {
            self.adImageView.image = lastCacheImage
        }
    }
    
    //下载广告
    fileprivate func downloadAdvertise() {
        self.dataModel.getAdvertiseModel { [unowned self] (message) in
            if message == kFailer {
                return;
            }
            var imageURL = URL.init(string: self.dataModel.resources[0].image)
            
            if !self.dataModel.resources[0].image.hasPrefix("http://") {
                imageURL = URL.init(string: String.init(format: "%@%@", kTJPCommonServiceAPI, self.dataModel.resources[0].image))
            }
            
            /**  优先级
             userInteractive
             userInitiated
             default
             utility
             background
             unspecified
             */
            let anotherQueue = DispatchQueue(label: "com.nh", qos: .userInitiated, attributes: .concurrent)
            anotherQueue.async {
                SDWebImageManager.shared().loadImage(with: imageURL, options: SDWebImageOptions.avoidAutoSetImage, progress: nil, completed: { (image, data, error, cacheType, isSuccees, imageURL) in
                    
                    NDUserDefauls.setAdvertiseImage(value: self.dataModel.resources[0].image)
                    NDUserDefauls.setAdvertiseLink(value: self.dataModel.resources[0].link)
                    //显示广告
                    if image != nil {
                        DispatchQueue.main.async {
                            self.adImageView.image = image
                        }
                        print("广告下载成功")
                    }
                })
            }
        }
    }
    
    //点击前往广告链接
    @objc fileprivate func adImageTap() {
        
    }
    //前往主页
    @objc fileprivate func goHomePage() {
        //销毁定时器
        timer.invalidate()
        self.removeFromSuperview()
    }
    
    //获取启动图片
    fileprivate func getLaunchImage() -> String {
        var launchImageName = ""
        let orentationStr = "Portrait"
        let viewSize = UIScreen.main.bounds.size
        let diction = Bundle.main.infoDictionary
        var launchImages = [NSDictionary]()
        
        launchImages = diction?["UILaunchImages"] as! [NSDictionary]
        
        for dic in launchImages {
            let imageSize = CGSizeFromString(dic["UILaunchImageSize"] as! String)
         
            if __CGSizeEqualToSize(imageSize, viewSize) &&  orentationStr == dic["UILaunchImageOrientation"] as! String {
                
                launchImageName = dic.value(forKey: "UILaunchImageName") as! String;
            }
        }
        
        return launchImageName
    }
    
    @objc fileprivate func timerGo() {
        if adShowTime == 0 {
            //销毁定时器
            timer.invalidate()
            
            self.removeFromSuperview()
        }else {
            adShowTime = adShowTime - 1
            //print("-------\(adShowTime)")
            
            let subString = String.init(format: "跳过%d", adShowTime)
            self.showTimeBtn.setTitle(subString, for: UIControlState.normal)
        }
    }

    
    deinit {
        print("销毁广告页面")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
