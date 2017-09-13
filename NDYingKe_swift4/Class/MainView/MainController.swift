//
//  MainController.swift
//  swift_非同凡享
//
//  Created by 李家奇_南湖国旅 on 2017/6/7.
//  Copyright © 2017年 李家奇_南湖国旅. All rights reserved.
//

import UIKit


class MainController: UITabBarController {

    fileprivate var tabBarView = UIView()
    fileprivate var previousBtn = tabBarBtn()
    
    /**
     * 自定义的tabbar在iOS8 中重叠的情况.就是原本已经移除的UITabBarButton再次出现.
     在iOS8 是允许动态添加tabbaritem的
     */
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        for child in tabBar.subviews as [UIView] {
            if child.isKind(of: NSClassFromString("UITabBarButton")!) {
                child.removeFromSuperview()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        for obj in self.tabBar.subviews as[UIView] {
            if obj != tabBarView {
                obj.removeFromSuperview()
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBar.barTintColor = UIColor.white
        self.tabBar.backgroundColor = UIColor.white
        view.backgroundColor = UIColor.white
        
        creatUI()
    }

    
    
    private func creatUI() {
        tabBarView = UIView(frame: self.tabBar.bounds)
        tabBarView.isUserInteractionEnabled = true;
        tabBarView.backgroundColor = UIColor.white
        
        tabBar.addSubview(tabBarView)
        
        
        let titleAry = ["", "", ""]
        let normalImage = ["tab_live", "tab_launch", "tab_me"]
        let selectedImage = ["tab_live_p", "tab_launch", "tab_me_p"]
        let VCary = ["NDHomePageViewController", "NDMineViewController", "NDMineViewController"]
      
        
        for i in 0..<VCary.count {
            
            let str = VCary[i]
            
            let nav = addChildViewController(childControllerName: str)
            
            if nav != nil {
                self.addChildViewController(nav!)
            }
            creatBtnWith(Title: titleAry[i], NormalImage: normalImage[i], selectedImage: selectedImage[i], index: i)
        }
        
        //默认选择
        let chooseBtn = tabBarView.subviews[0];
        changeViewController(button: chooseBtn as! tabBarBtn)
        
        let fpsLb = NDFPSLabel.init(frame: CGRect.init(x: kSCREEN_WIDTH-80, y: 80, width: 70, height: 30))
        self.view.addSubview(fpsLb)
    }
    
    //类名转控制器
    private func addChildViewController(childControllerName : String) -> NDNavigationController? {
        
        // 1.获取命名空间
        guard let clsName = Bundle.main.infoDictionary!["CFBundleExecutable"] else {
            print("命名空间不存在")
            return nil
        }
        // 2.通过命名空间和类名转换成类
        let cls : AnyClass? = NSClassFromString((clsName as! String) + "." + childControllerName)
        
        // swift 中通过Class创建一个对象,必须告诉系统Class的类型
        //guard只有在条件不满足的时候才会执行这段代码
        guard let clsType = cls as? UIViewController.Type else {
            print("无法转换成UIViewController")
            return nil
        }
        
        // 3.通过Class创建对象
        let childController = clsType.init()
        
        // 包装导航控制器
        let nav = NDNavigationController(rootViewController: childController)
        
        return nav
    }
    
    
    private func creatBtnWith(Title:String, NormalImage:String, selectedImage:String, index:Int) {
        
        let barBtn = tabBarBtn(type: UIButtonType.custom)
        barBtn.tag = 500+index;
        
        let buttonW = tabBarView.frame.size.width/3
        let buttonH = tabBarView.frame.size.height
        //强制转换类型CGFloat(index)
        barBtn.frame = CGRect(x: buttonW*CGFloat(index), y: 0, width: buttonW, height: buttonH)
        
        //设置中间按钮的y
        if index == 1 {
            
            
        }
        
        //状态图片
        barBtn.setImage(UIImage(named:NormalImage), for: UIControlState.normal)
        barBtn.setImage(UIImage(named:selectedImage), for: UIControlState.selected)
       
        //barBtn.setTitle(Title, for: UIControlState())
        //barBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        //barBtn.titleLabel?.textAlignment = NSTextAlignment.center
        
        barBtn.imageView?.contentMode = UIViewContentMode.center
        //UIViewContentModeScaleAspectFit;
        //barBtn.titleLabel?.contentMode = UIViewContentMode.scaleAspectFit
        
        //字体颜色
        //barBtn.setTitleColor(UIColor.black, for: UIControlState.normal)
        //barBtn.setTitleColor(UIColor.white, for: UIControlState.selected)
        
        barBtn.addTarget(self, action: #selector(changeViewController(button:)), for: UIControlEvents.touchUpInside)
        
        tabBarView.addSubview(barBtn)
        
    }
    
    //点击按钮
    @objc private func changeViewController(button:tabBarBtn) {
        
        let btnTag = button.tag - 500
        
        if self.selectedIndex != btnTag {
            self.selectedIndex = btnTag
            
            //使上一个变为非选中
            previousBtn.isSelected = !previousBtn.isSelected
            
            previousBtn = button;
            previousBtn.isSelected = true//当前选择
        }else {
            
            previousBtn.isSelected = true
        }
    }
    
}


//---------------------------

class tabBarBtn: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }

    override func imageRect(forContentRect contentRect: CGRect) -> CGRect {
        var imageY = contentRect.size.height*0
        let imageW = contentRect.size.width
        var imageH = contentRect.size.height
        
        if self.tag == 501 { //中间那个
            imageY = -contentRect.size.height*0.6
            imageH += contentRect.size.height*0.6
        }
        return CGRect(x: 0, y: imageY, width: imageW, height: imageH)
    }
    
    //点击范围
//    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
//        if self.tag == 501 {
//            var bounds = self.bounds;
//            let widthDelta = 44.0 - bounds.size.width;
//            let heightDelta = 44.0 - bounds.size.height;
//            bounds = CGRect.init(origin: CGPoint.init(x: <#T##CGFloat#>, y: <#T##CGFloat#>), size: <#T##CGSize#>)(bounds, -0.5 * widthDelta, -0.5 * heightDelta);
//            return CGRectContainsPoint(bounds, point);
//        }
//    }
    
//    override func titleRect(forContentRect contentRect: CGRect) -> CGRect {
//        
//        let titleY = contentRect.size.height * 0.65
//        let titleW = contentRect.size.width
//        let titleH = contentRect.size.height - titleY
//        
//        return CGRect(x: 0, y: titleY, width: titleW, height: titleH)
//    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
