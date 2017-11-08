//
//  NDNavigationController.swift
//  swift_非同凡享
//
//  Created by <https://github.com/NorthDogLi> on 2017/6/9.
//  Copyright © 2017年 <https://github.com/NorthDogLi>. All rights reserved.
//

import UIKit


class NDNavigationController: UINavigationController {

    //var supportPortraitOnly:Bool = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //设置导航栏背景颜色
        self.navigationBar.barTintColor = kGlobalLightBlueColor
        
        let dict:NSDictionary = [NSForegroundColorAttributeName: UIColor.red, NSFontAttributeName : UIFont.systemFont(ofSize: 18)]
        //标题颜色
        self.navigationBar.titleTextAttributes = dict as? [String : AnyObject]
        //self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: self.leftBarBtn)
        
        
        //setShadowLayer(view: self.navigationBar)
        
        self.setNeedsStatusBarAppearanceUpdate()
    }
    
    fileprivate func setShadowLayer(view : UIView) {
        //  给导航栏视图添加阴影层
        let layer = view.layer
        layer.shadowOffset = CGSize.init(width: 0, height: 2)
        layer.shadowRadius = 3.0 //默认为3.0
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 1.0
    }
    
    /**
     全屏返回手势
     
     @param isForBidden 是否禁止
     */
//    func setupBackPanGestureIsForbiddden(isForBidden:Bool) {
//        
//    }
    
    
    //重写父类方法
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        
        super.pushViewController(viewController, animated: animated)
        
        if (viewController.navigationController?.responds(to: #selector(getter: interactivePopGestureRecognizer)))! {
            
            viewController.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
            viewController.navigationController?.interactivePopGestureRecognizer?.delegate = nil;
        }
        //viewController.navigationItem.leftBarButtonItem == nil && self.viewControllers.count > 1
        //不是第一层控制器的时候
        if viewController != self.childViewControllers[0]{
            
            viewController.navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: self.leftBarBtn)
            
            viewController.navigationItem.leftBarButtonItem?.imageInsets = UIEdgeInsetsMake(0, 0, 0, 0)
            
            //如果push进来的不是第一个控制器
            //当push的时候 隐藏tabbar
            UIView.animate(withDuration: 0.2, animations: {
                
                viewController.tabBarController?.tabBar.ND_Y = kSCREEN_HEIGHT+__Y(y: 25)
            }) { (finished) in
                
            }
        }
    }
    
    
    fileprivate lazy var leftBarBtn : UIButton = {
        let leftView = UIButton.init(type: UIButtonType.custom)
        leftView.frame = __setCGRECT(x: 0, y: 0, width: __X(x: 55), height: __X(x: 26))
        leftView.addTarget(self, action: #selector(popself), for: UIControlEvents.touchUpInside)
        
        let img1 = UIImageView.init(image: __setImageName(name: "title_button_back"))
        leftView.addSubview(img1)
        img1.frame = __setCGRECT(x: 0, y: 5, width: __X(x: 20), height: __X(x: 22))
        
//        let img2 = UIImageView.init(image: __setImageName(name: "icon_icon"))
//        leftView.addSubview(img2)
//        img2.frame = __setCGRECT(x: __X(x: 23), y: 0, width: __X(x: 26), height: __X(x: 26))
        
        return leftView
    }()
    
    @objc fileprivate func popself() {
        self.popViewController(animated: true)
    }
    
    
}




