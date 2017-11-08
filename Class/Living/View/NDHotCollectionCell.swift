//
//  NDHotCollectionCell.swift
//  NDYingKe_swift4
//
//  Created by <https://github.com/NorthDogLi> on 2017/8/31.
//  Copyright © 2017年 NorthDogLi. All rights reserved.
//

import UIKit
import IJKMediaFramework

class NDHotCollectionCell: UICollectionViewCell {
    
    var controller = UIViewController()
    
    
    fileprivate var _flv : String = ""
    
    /** 直播开始前的占位图片*/
    fileprivate var placeHolderView = UIImageView()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        //
        NotificationCenter.default.addObserver(self, selector: #selector(clickUser(notification:)), name: NSNotification.Name(rawValue: kNotificationClickUser), object: nil)
    }
    
    override func layoutSubviews() {
        placeHolderView.frame = self.contentView.frame
        self.contentView.addSubview(placeHolderView)
        
        self.moviePlayer.view.frame = self.contentView.bounds
        self.bottomView.frame = CGRect.init(x: 0, y: self.contentView.ND_Height-54, width: self.contentView.ND_Width, height: 44)
        self.headerView.frame = CGRect.init(x: 0, y: 0, width: self.ND_Width, height: 110)
    }
    
    //显示数据
    public var setlivHotData = livess() {
        didSet {
            self.playWithFLV(flv: setlivHotData.stream_addr, placeHolderUrl: URL.init(string: (setlivHotData.creator?.portrait)!)!)
            //添加头部视图
            self.headerView.setLivess = setlivHotData
        }
    }
    
    //开始直播
    fileprivate func playWithFLV(flv:String, placeHolderUrl:URL) {
        _flv = flv
        self.contentView.insertSubview(self.placeHolderView, aboveSubview: self.moviePlayer.view)
//        self.moviePlayer.shutdown() // 停播
//        self.moviePlayer.view.removeFromSuperview()
//        //moviePlayer = nil
//        //如果有粒子动画,先移除
        //self.emitterLayer.removeFromSuperlayer()
        self.removeMovieNotificationObservers()
        
        //占位图片
        self.placeHolderView.setImageViewBlur(url: placeHolderUrl, float: 0.7)
        
        self.contentView.insertSubview(self.moviePlayer.view, at: 0)
        
        addObserveForMoviePlayer() //添加监听
        
        setupBottomView() //底部视图方法监听
    }
    //底部视图按钮的点击block
    fileprivate func setupBottomView() {
        
        self.bottomView.bottomViewBtnClickBlock = {
            [unowned self] (LivingBottomViewBtnClickType) -> Void in
            switch LivingBottomViewBtnClickType {
            case .hotMessageType:
                
                break
            case .hot_e_mailClickType:
                
                break
            case .hot_giftClickType:
                
                break
            case .hot_shareClickType:
                
                break
            case .hot_gobackClickType:
                self.controller.dismiss(animated: true, completion: nil)
                self.playStop()
                break
            }
        }
    }
    
    //MARK: 四个通知方法
    @objc fileprivate func loadStateDidChange(notification:Notification) {
        let loadState = self.moviePlayer.loadState as IJKMPMovieLoadState
        
        if  (loadState.rawValue & IJKMPMovieLoadState.playthroughOK.rawValue) != 0{
            //shouldAutoplay 为yes 在这种状态下会自动开始播放
            if !self.moviePlayer.isPlaying() {
                self.moviePlayer.play()
                //粒子动画开始
                self.emitterLayer.isHidden = false
                
                let delay = DispatchTime.now() + .seconds(1)
                DispatchQueue.main.asyncAfter(deadline: delay, execute: { 
                    self.placeHolderView.removeFromSuperview()
                })
            }else if (loadState.rawValue & IJKMPMovieLoadState.stalled.rawValue) != 0 { //如果正在播放,会在此状态下暂停
                print("--此状态下暂停--：\(loadState)")
            }else {
                print("---播放开始--：\(loadState)")
            }
        }
    }
    
    @objc fileprivate func moviePlayBackFinish(notification:Notification) {
        //播放结束时,或者是用户退出时会触发
        
        /*
        let reason = notification.userInfo?[IJKMPMoviePlayerPlaybackDidFinishReasonUserInfoKey] as! IJKMPMovieFinishReason
        switch reason {
            
        case IJKMPMovieFinishReason.playbackEnded:
            print("playbackEnded---:\n\(reason)")
            break
        case IJKMPMovieFinishReason.userExited:
            print("userExited---:\n\(reason)")
            break
        case IJKMPMovieFinishReason.playbackError:
            print("playbackError---:\n\(reason)")
            break
        }
        */
    }
    
    @objc fileprivate func mediaIsPreparedToPlayDidChange(notification:Notification) {
        print("mediaIsPrepareToPlayDidChange")
    }
    
    @objc fileprivate func moviePlayBackStateDidChange(notification:Notification) {
        
        switch self.moviePlayer.playbackState {
            
        case IJKMPMoviePlaybackState.stopped:
            print("stopped--:\n\(self.moviePlayer.playbackState)")
            break
        case IJKMPMoviePlaybackState.playing:
            print("playing--:\n\(self.moviePlayer.playbackState)")
            break
        case IJKMPMoviePlaybackState.paused:
            print("paused--:\n\(self.moviePlayer.playbackState)")
            break
        case IJKMPMoviePlaybackState.interrupted:
            print("interrupted--:\n\(self.moviePlayer.playbackState)")
            break
        case IJKMPMoviePlaybackState.seekingForward:
            print("seekingForward--:\n\(self.moviePlayer.playbackState)")
            break
        case IJKMPMoviePlaybackState.seekingBackward:
            print("seekingBackward--:\n\(self.moviePlayer.playbackState)")
            break
        
        }
    }
    
    //页面离开后删除所有通知和方法
    public func playStop() {
        self.moviePlayer.shutdown()
        self.moviePlayer.stop()
        self.emitterLayer.removeFromSuperlayer()
        self.removeFromSuperview()
        
        removeMovieNotificationObservers()
        NotificationCenter.default.removeObserver(self)
    }
    
    //主页消失通知方法
    @objc fileprivate func clickUser(notification:Notification) {
        playStop()
    }
    
    /** 添加全部通知 */
    fileprivate func addObserveForMoviePlayer() {
        DispatchQueue(label: "com.nsnotifica", qos: .userInitiated, attributes: .concurrent, autoreleaseFrequency: .workItem, target: nil).async { 
            NotificationCenter.default.addObserver(self, selector: #selector(self.loadStateDidChange(notification:)), name: NSNotification.Name.IJKMPMoviePlayerLoadStateDidChange, object: self.moviePlayer)
            
            NotificationCenter.default.addObserver(self, selector: #selector(self.moviePlayBackFinish(notification:)), name: NSNotification.Name.IJKMPMoviePlayerPlaybackDidFinish, object: self.moviePlayer)
            
            NotificationCenter.default.addObserver(self, selector: #selector(self.mediaIsPreparedToPlayDidChange(notification:)), name: NSNotification.Name.IJKMPMediaPlaybackIsPreparedToPlayDidChange, object: self.moviePlayer)
            
            NotificationCenter.default.addObserver(self, selector: #selector(self.moviePlayBackStateDidChange(notification:)), name: NSNotification.Name.IJKMPMoviePlayerPlaybackStateDidChange, object: self.moviePlayer)
        }
    }
    
    /** 释放全部通知 */
    fileprivate func removeMovieNotificationObservers() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.IJKMPMoviePlayerLoadStateDidChange, object: moviePlayer)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.IJKMPMoviePlayerPlaybackDidFinish, object: moviePlayer)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.IJKMPMediaPlaybackIsPreparedToPlayDidChange, object: moviePlayer)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.IJKMPMoviePlayerPlaybackStateDidChange, object: moviePlayer)
    }
    
    
    //MARK: 懒加载各种载体
    /** 直播播放器*/
    fileprivate lazy var moviePlayer: IJKFFMoviePlayerController = {
        let movie = IJKFFMoviePlayerController.init(contentURLString: self._flv, with: self.options)
        movie?.scalingMode = IJKMPMovieScalingMode.aspectFill
        // 设置自动播放(必须设置为NO, 防止自动播放, 才能更好的控制直播的状态)
        movie?.shouldAutoplay = false
        movie?.shouldShowHudView = false// 默认不显示
        DispatchQueue(label: "com.moviePlayer", qos: .userInitiated, attributes: .concurrent, autoreleaseFrequency: .workItem, target: nil).async {
            movie?.prepareToPlay()
        }
        return movie!
    }()
    /** 播放器属性*/
    fileprivate lazy var options: IJKFFOptions = {
        let option = IJKFFOptions.byDefault()
        option?.setPlayerOptionIntValue(1, forKey: "videotoolbox")
        // 帧速率(fps) 非标准桢率会导致音画不同步，所以只能设定为15或者29.97
        option?.setPlayerOptionIntValue(Int64(29.97), forKey: "r")
        // 置音量大小，256为标准  要设置成两倍音量时则输入512，依此类推
        option?.setPlayerOptionIntValue(256, forKey: "vol")
        return option!
    }()
    
    /** 粒子动画*/
    fileprivate lazy var emitterLayer: CAEmitterLayer = {
        let emitter = CAEmitterLayer.init()
        //发射器在xy平面的中心位置
        emitter.emitterPosition = CGPoint.init(x: self.moviePlayer.view.ND_Width - 50, y: self.moviePlayer.view.ND_Height - 50)
        //发射器尺寸
        emitter.emitterSize = CGSize.init(width: 20, height: 20)
        //渲染模式
        emitter.renderMode = kCAEmitterLayerUnordered;
        
        var emitterCellArr = [CAEmitterCell]()
        //创建粒子
        for i in 1 ..< 10 {
            let cell = CAEmitterCell.init() //发射单元
            cell.birthRate = 1 //粒子速率 默认1/s
            cell.lifetime = Float(arc4random_uniform(4) + 1) //粒子存活时间
            cell.lifetimeRange = 1.5 //粒子生存时间容差
            let image = UIImage.init(named: String.init(format: "good%d_30x30_", i)) //粒子显示内容
            cell.contents = image?.cgImage
            cell.velocity = CGFloat(arc4random_uniform(100) + 100)//粒子运动速度
            cell.velocityRange = 80 //粒子运动速度容差
            //粒子在xy平面的发射角度
            cell.emissionLongitude = 4.6
            cell.emissionRange = 0.3 //发射角度容差
            cell.scale = 0.3 //缩放比例
            emitterCellArr.append(cell)
        }
        emitter.emitterCells = emitterCellArr
        self.moviePlayer.view.layer.addSublayer(emitter)
        
        return emitter
    }()
    
    /** 礼物*/
    
    /** 底部视图*/
    lazy var bottomView: NDLivingBottomView = {
        let bView = NDLivingBottomView.instanceFromNib()
        bView.backgroundColor = UIColor.clear
        self.contentView.addSubview(bView)
        return bView
    }()
    
    /** 头部视图*/
    lazy var headerView: NDHotCellHeaderView = {
        let HView = NDHotCellHeaderView.instanceFromNib()
        HView.backgroundColor = UIColor.clear
        self.contentView.addSubview(HView)
        return HView
    }()
    
    deinit {
        print("dealloc方法被调用")
        self.playStop()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
