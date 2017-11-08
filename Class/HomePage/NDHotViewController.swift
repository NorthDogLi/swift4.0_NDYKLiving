//
//  NDHotViewController.swift
//  NDYingKe_swift4
//
//  Created by <https://github.com/NorthDogLi> on 2017/8/14.
//  Copyright © 2017年 NorthDogLi. All rights reserved.
//

import UIKit


private let Identifier = "BaseStrategyCell"

//热门
class NDHotViewController: UIViewController {

    fileprivate let scrollerModel = NDNavigationItem()
    fileprivate let liveModel = NDLiveData()
    fileprivate var tableView = UITableView.init()
    fileprivate var imageArray = [String]()
    fileprivate var oldScrollerY : CGFloat = 0
    fileprivate var oldIndex : Int = 0
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white
        // 原点从（0，0）开始
        self.automaticallyAdjustsScrollViewInsets = false
        
        initloadView()
        
        initScrollerData()
        
        NDTools.shareTool.isShowBar = false
    }
    
    fileprivate func initloadView() {
        tableView = UITableView.init(frame: CGRect.init(x: 0, y: 64, width: kSCREEN_WIDTH, height: kSCREEN_HEIGHT), style: UITableViewStyle.plain)
        self.view.addSubview(tableView)
        //tableView.register(UINib.init(nibName: "NDHotTableCell", bundle: nil), forCellReuseIdentifier: Identifier)
        //tableView.register(NDHotTableViewCell.self, forCellReuseIdentifier: Identifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor.white
        //不显示下划线
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        
        tableView.tableHeaderView = self.headerView
        //加载下拉刷新
        let gifHeader = NDRefreshGifHeader()
        tableView.mj_header = gifHeader
        gifHeader.refresh_GifHeader { [unowned self](message) in
            self.initLivedata()
        }
    }
    
    //懒加载
    lazy var headerView: LPBannerView = {
        let header = LPBannerView.init(frame: CGRect.init(x: 0, y: 0, width: kSCREEN_WIDTH, height: __Y(y: 170)))
        header.delegate = self
        header.pageDotColor = UIColor.white
        header.currentPageDotColor = kGlobalLightBlueColor
        //block
        header.clickItemClosure = { (index) -> Void in
            //print("闭包回调---\(index)")
        }
        return header
    }()
    
    
    func pushController(controller:UIViewController) {
        
        //self.navigationController?.pushViewController(controller, animated: true)
        //self.navigationController?.navigationBar.isHidden = true
        self.present(controller, animated: true, completion: nil)
    }
}

extension NDHotViewController : LPBannerViewDelegate {
    //轮播图点击方法
    func cycleScrollView(_ scrollView: LPBannerView, didSelectItemAtIndex index: Int) {
        print(self.scrollerModel.ticker[index].link)
    }
}

extension NDHotViewController {
    
    //请求轮播数据
    fileprivate func initScrollerData() {
        
        DispatchQueue(label: "com.tableheader", qos: .default, attributes: .concurrent, autoreleaseFrequency: .workItem, target: nil).async {
            
            self.scrollerModel.getHeaderScrollerData {[unowned self] (message) in
                if message == kSucceed {
                    for item in self.scrollerModel.ticker {
                        
                        if !item.image.hasPrefix("http") {
                            item.image = kTJPCommonServiceAPI + item.image
                        }
                        self.imageArray.append(item.image)
                    }
                    DispatchQueue.main.async {
                        self.headerView.imagePaths = self.imageArray
                    }
                }
            }
        }
        
        self.initLivedata()
    }
    
    //请求热门数据
    fileprivate func initLivedata() {
        DispatchQueue(label: "com.ndHotData", qos: .userInitiated, attributes: .concurrent, autoreleaseFrequency: .workItem, target: nil).async {
            self.liveModel.getHotLivDatas {[unowned self] (message) in
                if message == kSucceed {
                    
                    self.tableView.reloadData()
                }
                self.tableView.mj_header.endRefreshing()
            }
        }
    }
}


extension NDHotViewController : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return liveModel.lives.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //xib加载用这个  需要在 initloadView 中解开注册方法的注释
//        let cell = tableView.dequeueReusableCell(withIdentifier: Identifier, for: indexPath) as! NDHotTableCell
//        let cell = tableView.dequeueReusableCell(withIdentifier: Identifier, for: indexPath) as! NDHotTableViewCell
        
        //纯代码cell
        let cell = NDHotTableViewCell.init(style: UITableViewCellStyle.default, reuseIdentifier: Identifier)
        //点击取消高亮
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        cell.livData = liveModel.lives[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let hotLivController = NDHotLiveingController()
        hotLivController.currentIndex = indexPath.row
        hotLivController.liveArrays = liveModel.lives[indexPath.row]
        
        self.pushController(controller: hotLivController)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       
        return liveModel.lives[indexPath.row].cellHeight
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        //scrollView已经有拖拽手势，直接拿到scrollView的拖拽手势
        let pan = scrollView.panGestureRecognizer;
        //获取到拖拽的速度 >0 向下拖动 <0 向上拖动
        let velocity = pan.velocity(in: scrollView).y
        if (velocity < -5) {
            //向上拖动，隐藏导航栏
            setTabBarHiddn(hiddn: true)
            
        }else if (velocity > 5) {
            //向下拖动，显示导航栏
            setTabBarHiddn(hiddn: false)
        }else if (velocity == 0) {
            //停止拖拽
        }
    }
    
    /** true:向上拖动隐藏  false:向下  显示*/
    fileprivate func setTabBarHiddn(hiddn:Bool) {
        UIView.animate(withDuration: 0.2, animations: {
            if hiddn {
                self.tabBarController?.tabBar.ND_Y = kSCREEN_HEIGHT+__Y(y: 25)
                self.tableView.ND_Y = 0
                self.navigationController?.navigationBar.isHidden = true
                
            }else { //显示
                self.tabBarController?.tabBar.ND_Y = kSCREEN_HEIGHT - (self.tabBarController?.tabBar.ND_Height)!
                self.tableView.ND_Y = 64
                self.navigationController?.navigationBar.isHidden = false
            }
        })
    }
}
