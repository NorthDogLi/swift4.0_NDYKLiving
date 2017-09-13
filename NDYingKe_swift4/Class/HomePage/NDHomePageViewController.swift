//
//  NDHomePageViewController.swift
//  NDYingKe_swift4.0
//
//  Created by 李家奇_南湖国旅 on 2017/8/10.
//  Copyright © 2017年 NorthDogLi. All rights reserved.
//

import UIKit


class NDHomePageViewController: UIViewController, segmentBarTargetDelegate {

    fileprivate let navModel = NDNavigationItem()
    fileprivate var itemArray = [String]() //可变string空数组
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if NDTools.shareTool.isShowBar == true {
            self.navigationController?.navigationBar.isHidden = false
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if NDTools.shareTool.isShowBar == true {
            UIView.animate(withDuration: 0.2, animations: {
                self.tabBarController?.tabBar.ND_Y = kSCREEN_HEIGHT - (self.tabBarController?.tabBar.ND_Height)!
            }) { (finished) in}
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.clear
        // 原点从（0，0）开始
        self.automaticallyAdjustsScrollViewInsets = false
        
        setupNavigationItem()
        
        loadDataForNavTag()
    }
    
    //加载数据
    fileprivate func loadDataForNavTag() {
        //[unowned self]表示弱引用
        //unowned 表示:即使它原来引用的对象被释放了，仍然会保持对被已经释放了的对象的一个 "无效的" 引用，它不能是 Optional 值，也不会被指向 nil
        DispatchQueue(label: "com.ScrollView", qos: .default, attributes: .concurrent, autoreleaseFrequency: .workItem, target: nil).async { 
            self.navModel.getNavigationTagModels {[unowned self] (message) in
                print(message)
                print(self.navModel.tabs[0].tab_title)
                
                if self.navModel.tabs.count == 0 {
                    self.itemArray = ["关注", "热门", "附近", "才艺"]
                }else {
                    for item in self.navModel.tabs {
                        self.itemArray.append(item.tab_title)
                    }
                }
                DispatchQueue.main.async {
                    self.setupNavigationTitleViewWithItems(array: self.itemArray)
                }
            }
        }
    }
    
    //设置页面
    fileprivate func setupNavigationTitleViewWithItems(array:[String]) {
        self.navigationItem.titleView = self.segmentItem;
        
        let controller1 = NDAttentionViewController()
        let controller2 = NDHotViewController()
        let controller3 = NDNearByViewController()
        let controller4 = NDTalentViewController()
        
        let childs = [controller1, controller2, controller3, controller4]
        
        self.setUpWithItems(items: array, childVCs: childs)
    }
    
    
    func setUpWithItems(items:[String], childVCs:[UIViewController]) {
        
        self.segmentItem.items = items
        self.segmentItem.setItems()
        
        
        for controllers in self.childViewControllers {
            controllers.removeFromParentViewController()
        }
        
        for vc in childVCs {
            self.addChildViewController(vc)
        }
        
        self.contentView.contentSize = CGSize.init(width: self.view.ND_Width * CGFloat(items.count), height: 0.0)
        //默认选择第2个
        self.segmentItem.selectIndex = 1
        self.segmentItem.setSelectIndex()
    }
    
    //代理方法
    func segmentBarTarget(selectedIndex: Int) {
        
        self.showChildVCViewsAtIndex(index: selectedIndex)
    }
    
    //滚动位置
    func showChildVCViewsAtIndex(index:Int) {
        //因为只是手动加载了4个控制器，所以当点击index>4以后从数组中取不到会崩溃
        if index>self.childViewControllers.count-1 {
            return
        }
        
        let contro = self.childViewControllers[index]
        contro.view.frame = CGRect.init(x: CGFloat(index) * self.contentView.ND_Width, y: 0.0, width: self.contentView.ND_Width, height: self.contentView.ND_Height)
        self.contentView.addSubview(contro.view)
        
        //滚动
        UIView.animate(withDuration: 0.15) {
            self.contentView.setContentOffset(CGPoint.init(x: CGFloat(index) * self.contentView.ND_Width, y: 0.0), animated: true)
        }
    }
    
    lazy var segmentItem: NDSegmemeItem = {
        let segmen = NDSegmemeItem.init(frame: CGRect.init(x: __X(x: 50), y: 2.5, width: self.view.ND_Width-__X(x: 100), height: 35))
        segmen.deleagte = self
        segmen.backgroundColor = UIColor.clear
        
        return segmen
    }()
    
    lazy var contentView: UIScrollView = {
        let scrView = UIScrollView.init(frame: CGRect.init(x: 0, y: 0, width: self.view.ND_Width, height: self.view.ND_Height))
        scrView.delegate = self
        scrView.isPagingEnabled = true
        //scrView.backgroundColor = UIColor.purple
        
        self.view.addSubview(scrView)
        
        return scrView
    }()
    
    //创建左右导航栏按钮
    private func setupNavigationItem() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.creatBarItem(image: "title_button_search", highImage: "title_button_search", title: "", tagget: self, action: #selector(gobackLiving))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.creatBarItem(image: "title_button_more", highImage: "title_button_more", title: "", tagget: self, action: #selector(gobackLiving))
    }
    
    @objc private func gobackLiving() {
        let livingVC = NDWebViewController()
        self.navigationController?.pushViewController(livingVC, animated: true)
    }
    
    
}

//delegate
extension NDHomePageViewController : UIScrollViewDelegate {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        //计算最后的索引
        let index = self.contentView.contentOffset.x / self.contentView.ND_Width
        self.segmentItem.selectIndex = Int(index)
        self.segmentItem.setSelectIndex()
    }
}


