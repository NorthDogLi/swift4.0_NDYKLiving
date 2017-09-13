//
//  LPBannerView.swift
//  LPBannerView
//
//  Created by Tony on 2017/8/16.
//  Copyright © 2017年 Tony. All rights reserved.
//

import UIKit


public protocol LPBannerViewDelegate: NSObjectProtocol {
    func cycleScrollView(_ scrollView: LPBannerView, didSelectItemAtIndex index: Int)
}
extension LPBannerViewDelegate {
    func cycleScrollView(_ scrollView: LPBannerView, didSelectItemAtIndex index: Int) {}
}

public enum LPBannerViewPageContolAliment {
    case left
    case center
    case right
}

public class LPBannerView: UIView, UICollectionViewDataSource, UICollectionViewDelegate {
    
    // MARK: - 外部调用属性
    /// 代理
    public weak var delegate: LPBannerViewDelegate?
    /// 闭包
    public var clickItemClosure: ((Int) -> Void)?
    
    // MARK: 图片、标题
    /// 图片下方对应的文字标题数组
    public var titlesArr: [String] = []
    /// 图片路径数组
    public var imagePaths: [String] = [] {
        didSet {
            setImagePaths()
        }
    }
    /// 网络图片未加载出来时的默认图
    public var placeholderImage = UIImage() {
        didSet {
            self.backgroundImageView.image = placeholderImage
        }
    }
    
    // MARK: 滚动
    /// 是否无限循环，默认true
    public var isInfiniteLoop = true
    /// 是否自动滚动，默认true
    public var isAutoScroll = true {
        didSet {
            setAutoScroll(isAutoScroll)
        }
    }
    /// 自动滚动间隔时间，默认2秒
    public var autoScrollTimeInterval: Float = 2 {
        didSet {
            setAutoScroll(isAutoScroll)
        }
    }
    /// 图片滚动方向，默认横向滚动
    public var scrollDirection: UICollectionViewScrollDirection = .horizontal {
        didSet {
            flowLayout.scrollDirection = scrollDirection
        }
    }
    
    // MARK: 分页控件
    /// 分页控件位置，默认居中
    public var pageContolAliment: LPBannerViewPageContolAliment = .center
    /// 分页控件距离轮播图的底部间距，默认10
    public var pageControlBottomDistance: CGFloat = 10
    /// 分页控件距离轮播图的左边或右边的间距(居左或居右显示时)，默认10
    public var pageControlSideDistance: CGFloat = 10
    /// 当前分页控件小圆标颜色，默认白色
    public var currentPageDotColor = UIColor.white
    /// 其他分页控件小圆标颜色，默认灰色
    public var pageDotColor = UIColor.gray
    /// 是否在只有一张图时隐藏分页控件，默认隐藏
    public var isHiddenWhenSinglePage = true
    
    // MARK: 标题文字
    /// 轮播文字label字体颜色，默认白色
    public var titleLabelTextColor = UIColor.white
    /// 轮播文字label字体大小，默认15
    public var titleLabelTextFont = UIFont.systemFont(ofSize: 15)
    /// 轮播文字label背景颜色，默认黑色半透明
    public var titleLabelBackgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.5)
    /// 轮播文字label高度，默认35
    public var titleLabelHeight: CGFloat = 35
    /// 轮播文字label对齐方式，默认居左
    public var titleLabelTextAlignment: NSTextAlignment = .left
    
    
    // MARK: - 私有属性
    fileprivate var timer: Timer?
    fileprivate var totalItemsCount = 0
    fileprivate var mainView: UICollectionView!
    fileprivate var flowLayout: UICollectionViewFlowLayout!
    fileprivate var pageControl: UIPageControl?
    fileprivate lazy var backgroundImageView: UIImageView = {// 当图片路径数组为空时的背景图
        let bgImageView = UIImageView()
        bgImageView.contentMode = .scaleAspectFill
        bgImageView.layer.masksToBounds = true
        self.insertSubview(bgImageView, belowSubview: self.mainView)
        return bgImageView
    }()
    
    
    // MARK: - 初始化方法
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupMainView()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupMainView()
    }
    
    private func setupMainView() {
        
        self.backgroundColor = UIColor.lightGray
        
        flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = 0
        flowLayout.scrollDirection = .horizontal
        
        mainView = UICollectionView(frame: self.bounds, collectionViewLayout: flowLayout)
        mainView.backgroundColor = UIColor.clear
        mainView.isPagingEnabled = true
        mainView.showsHorizontalScrollIndicator = false
        mainView.showsVerticalScrollIndicator = false
        mainView.register(LPBannerCell.self, forCellWithReuseIdentifier: NSStringFromClass(LPBannerCell.self))
        mainView.dataSource = self
        mainView.delegate = self
        mainView.scrollsToTop = false
        self.addSubview(mainView)
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        flowLayout.itemSize = self.bounds.size
        mainView.frame = self.bounds
        if (mainView.contentOffset.x == 0) && (totalItemsCount > 0) {
            var targetIndex = 0
            if isInfiniteLoop {
                targetIndex = totalItemsCount / 2
            }
            mainView.scrollToItem(at: NSIndexPath.init(row: targetIndex, section: 0) as IndexPath, at: .init(rawValue: 0), animated: false)
        }
        
        let pageDotSize = CGSize(width: 15, height: 10)
        let pageControlSize = CGSize(width: pageDotSize.width * CGFloat(imagePaths.count), height: pageDotSize.height)
        let pageControlY = mainView.bounds.height - pageDotSize.height - pageControlBottomDistance
        var pageControlX: CGFloat = 0
        if pageContolAliment == .left {
            pageControlX = pageControlSideDistance
        } else if pageContolAliment == .right {
            pageControlX = mainView.bounds.width - pageControlSize.width - pageControlSideDistance
        } else if pageContolAliment == .center {
            pageControlX = (mainView.bounds.width - pageControlSize.width) / 2.0
        }
        
        pageControl?.frame = CGRect(x: pageControlX, y: pageControlY, width: pageControlSize.width, height: pageControlSize.height)
        self.backgroundImageView.frame = self.bounds
    }
    
    /// 释放
    public func releaseCarouseView() {
        invalidateTimer()
    }
    
    deinit {
        print("deinit---LPBannerView")
        mainView.delegate = nil
        mainView.dataSource = nil
    }
}


extension LPBannerView {
    
    // MARK: - setProperty
    fileprivate func setAutoScroll(_ autoScroll: Bool) {
        
        invalidateTimer()
        if autoScroll {
            setupTimer()
        }
    }
    
    fileprivate func setImagePaths() {
        
        invalidateTimer()
        
        totalItemsCount = isInfiniteLoop ? imagePaths.count * 100 : imagePaths.count
        
        if imagePaths.count > 1 {
            mainView.isScrollEnabled = true
            setAutoScroll(isAutoScroll)
        } else {
            mainView.isScrollEnabled = false
            setAutoScroll(false)
        }
        
        setupPageControl()
        mainView.reloadData()
    }
    
    fileprivate func setupTimer() {
        
        invalidateTimer()
        
        timer = Timer.scheduledTimer(timeInterval: TimeInterval(autoScrollTimeInterval), target: self, selector: #selector(automaticScroll), userInfo: nil, repeats: true)
        RunLoop.current.add(timer!, forMode: .commonModes)
    }
    
    fileprivate func invalidateTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    fileprivate func setupPageControl() {
        
        // 重新加载数据时调整
        pageControl?.removeFromSuperview()
        if imagePaths.count == 0 {
            return
        }
        if (imagePaths.count == 1) && isHiddenWhenSinglePage {
            return
        }
        
        let pageIndex = getPageControlIndex(getCurrentIndex())
        pageControl = UIPageControl()
        pageControl?.numberOfPages = imagePaths.count
        pageControl?.currentPageIndicatorTintColor = currentPageDotColor
        pageControl?.pageIndicatorTintColor = pageDotColor
        pageControl?.isUserInteractionEnabled = false
        pageControl?.currentPage = pageIndex
        self.addSubview(pageControl!)
    }
}

extension LPBannerView {
    
    // MARK: - collectionView
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return totalItemsCount
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NSStringFromClass(LPBannerCell.self), for: indexPath) as! LPBannerCell
        
        let cellIndex = getPageControlIndex(indexPath.item)
        
        // 设置图片
        let imagePath = self.imagePaths[cellIndex]
        cell.imageView.sd_setImage(with: URL.init(string: imagePath), placeholderImage: nil)
        
        // 设置图片下方文字介绍
        if cellIndex < titlesArr.count {
            cell.title = titlesArr[cellIndex]
        } else {
            cell.title = ""
        }
        if cell.isConfigured == false {
            cell.isConfigured = true
            cell.titleLabelTextColor = titleLabelTextColor
            cell.titleLabelTextFont = titleLabelTextFont
            cell.titleLabelBackgroundColor = titleLabelBackgroundColor
            cell.titleLabelTextAlignment = titleLabelTextAlignment
            cell.titleLabelHeight = titleLabelHeight
        }
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let index = getPageControlIndex(indexPath.item)
        delegate?.cycleScrollView(self, didSelectItemAtIndex: index)
        
        clickItemClosure?(index)
    }
    
    
    // MARK: scrollView
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if imagePaths.count == 0 {
            return
        }
        let cellIndex = getCurrentIndex()
        let indexOnPageControl = getPageControlIndex(cellIndex)
        pageControl?.currentPage = indexOnPageControl
    }
    
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
        if isAutoScroll {
            invalidateTimer()
        }
    }
    
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        if isAutoScroll {
            setupTimer()
        }
    }
}


extension LPBannerView {
    
    // MARK: - actions
    // 定时器监听方法
    @objc fileprivate func automaticScroll() {
        
        if totalItemsCount == 0 {
            return
        }
        let curIndex = getCurrentIndex()
        let targetIndex = curIndex + 1
        scrollToIndex(targetIndex: targetIndex)
    }
    
    // 滚动至指定页面
    fileprivate func scrollToIndex(targetIndex: Int) {
        
        var targetIndex = targetIndex
        if targetIndex >= totalItemsCount {
            if isInfiniteLoop {
                targetIndex = totalItemsCount / 2
                mainView.scrollToItem(at: NSIndexPath.init(row: targetIndex, section: 0) as IndexPath, at: .init(rawValue: 0), animated: true)
            }
            return
        }
        mainView.scrollToItem(at: NSIndexPath.init(row: targetIndex, section: 0) as IndexPath, at: .init(rawValue: 0), animated: true)
    }
    
    // 获取当前cell下标
    fileprivate func getCurrentIndex() -> Int {
        
        if mainView.bounds.width == 0 || mainView.bounds.height == 0 {
            return 0
        }
        let index: Int
        if flowLayout.scrollDirection == .horizontal {
            index = Int((mainView.contentOffset.x + flowLayout.itemSize.width * 0.5) / flowLayout.itemSize.width)
        } else {
            index = Int((mainView.contentOffset.y + flowLayout.itemSize.height * 0.5) / flowLayout.itemSize.height)
        }
        return index
    }
    
    // 获取当前页码下标
    fileprivate func getPageControlIndex(_ currentCellIndex: Int) -> Int {
        
        return currentCellIndex % imagePaths.count
    }
}
