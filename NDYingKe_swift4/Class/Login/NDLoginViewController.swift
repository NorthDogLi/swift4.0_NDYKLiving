//
//  NDLoginViewController.swift
//  NDYingKe_swift4.0
//
//  Created by 李家奇_南湖国旅 on 2017/8/10.
//  Copyright © 2017年 NorthDogLi. All rights reserved.
//

import UIKit

class NDLoginViewController: UIViewController {

    @IBOutlet weak var treeImageView: UIImageView!
    
    @IBOutlet weak var protocolLabel: UILabel!
    
    fileprivate var bigCloud = UIImageView.init()
    fileprivate var smallCloud = UIImageView.init()
    fileprivate var smallerCloud = UIImageView.init()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    //改变状态栏
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    fileprivate func setupUI() {
        
        bigCloud = createImageViewWithImage(image: "login_bg_cloud_1");
        bigCloud.ND_X = kSCREEN_WIDTH;
        bigCloud.ND_Y = __Y(y: 100);
        self.view.addSubview(bigCloud)
        bigCloud.layer.add(startAnimationWithDuration(duration: 23.0, point: CGPoint.init(x: 0-bigCloud.ND_Width, y: bigCloud.ND_Y)), forKey: "bigCloudMove")
        
        
        smallCloud = createImageViewWithImage(image: "login_bg_cloud_2")
        smallCloud.ND_X = bigCloud.ND_X
        smallCloud.ND_Y = bigCloud.frame.maxY+__Y(y: 80)
        self.view.insertSubview(smallCloud, belowSubview: treeImageView)
        smallCloud.layer.add(startAnimationWithDuration(duration: 18.5, point: CGPoint.init(x: 0-smallCloud.ND_Width, y: smallCloud.ND_Y)), forKey: "smallCloudMove")
        
        
        smallerCloud = createImageViewWithImage(image: "login_bg_cloud_2")
        smallerCloud.ND_X = bigCloud.ND_X
        smallerCloud.ND_Y = treeImageView.frame.maxY+__Y(y: 5)
        self.view.insertSubview(smallerCloud, belowSubview: treeImageView)
        smallerCloud.layer.add(startAnimationWithDuration(duration: 26.0, point: CGPoint.init(x: 0-smallerCloud.ND_Width, y: smallerCloud.ND_Y)), forKey: "smallerCloudMove")
        
        //富文本
        let textS = protocolLabel.text! as NSString;
        
        let abs = NSMutableAttributedString.init(string: protocolLabel.text!)
        abs.beginEditing()
        abs.addAttribute(NSForegroundColorAttributeName, value: kGlobalLightBlueColor, range: NSMakeRange(8, textS.length - 8))
        //需要rawValue将int转换为nsnumber类型
        abs.addAttribute(NSUnderlineStyleAttributeName, value: NSUnderlineStyle.styleSingle.rawValue, range: NSMakeRange(8, textS.length-8))
        protocolLabel.attributedText = abs
        
    }
    
    
   
    @IBAction func weiboBtnClick(_ sender: Any) {
        goHomePage()
    }

    @IBAction func wechatBtnClick(_ sender: Any) {
        goHomePage()
    }
    
    @IBAction func mobileBtnClick(_ sender: Any) {
        goHomePage()
    }
    
    @IBAction func qqBtnClick(_ sender: Any) {
        goHomePage()
    }
    
    fileprivate func goHomePage() {
        //保持已登陆状态，下次不再进入登陆页面
        NDUserDefauls.saveLoginMark(value: true)
        
        let delegate = UIApplication.shared.delegate as! AppDelegate
        delegate.homePageViewControllerShow()
        
    }
    
    fileprivate func createImageViewWithImage(image:String) -> UIImageView {
        let imageView = UIImageView.init(image: __setImageName(name: image));
        imageView.sizeToFit()
        return imageView;
    }
    
    fileprivate func startAnimationWithDuration(duration:CFTimeInterval, point:CGPoint) -> CABasicAnimation {
        let animation = CABasicAnimation.init(keyPath: "position")
        animation.toValue = NSValue.init(cgPoint: point)
        animation.duration = duration;
        animation.repeatCount = MAXFLOAT;
        animation.isRemovedOnCompletion = false;
        return animation;
    }
    
    fileprivate func removeAnimation() {
        
        bigCloud.layer.removeAnimation(forKey: "bigCloudMove")
        smallCloud.layer.removeAnimation(forKey: "smallCloudMove")
        smallerCloud.layer.removeAnimation(forKey: "smallerCloudMove")
    }
    
    //与dealloc一样的功能
    deinit {
        print("销毁登陆页面")
        removeAnimation()
    }
}
