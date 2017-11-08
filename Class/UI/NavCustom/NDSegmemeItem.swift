//
//  NDSegmemeItem.swift
//  NDYingKe_swift4
//
//  Created by <https://github.com/NorthDogLi> on 2017/8/14.
//  Copyright © 2017年 NorthDogLi. All rights reserved.
//

import UIKit

@objc protocol segmentBarTargetDelegate {
    //可选方法
    @objc optional func segmentBarTarget(selectedIndex:Int)
}

class NDSegmemeItem: UIView {
    
    //存放所有的按钮
    var itemBtns = [UIButton]()
    var lastBtn = UIButton()
    var items = [String]()
    var selectIndex : Int = 0
    
    let indicatorH:CGFloat = 1.5 //指示器高度
    
    //声明代理
    weak var deleagte : segmentBarTargetDelegate?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    //存放navItem视图
    lazy var contentView: UIScrollView = {
        
        let scrView = UIScrollView()
        scrView.delegate = self as? UIScrollViewDelegate
        scrView.showsHorizontalScrollIndicator = false
        self.addSubview(scrView)
        
        return scrView
    }()
    
    
    lazy var indicatorView: UIView = {
        
        let indicatorView = UIView.init(frame: CGRect.init(x: 0.0, y: self.ND_Height-self.indicatorH-1.0, width: 0.0, height: self.indicatorH))
        indicatorView.backgroundColor = UIColor.white
        self.contentView.addSubview(indicatorView)
        
        return indicatorView
    }()
    
    // 存放所有数据
    func setItems() {
        //清除所有按钮数组
        self.itemBtns.removeAll()
        
        for title in self.items {
            let button = UIButton.init(type: UIButtonType.custom)
            button.tag = self.itemBtns.count
            button.addTarget(self, action: #selector(btnClick(btn:)), for: UIControlEvents.touchUpInside)
            button.titleLabel?.font = __FONT(x: 14)
            
            button.setTitle(title, for: UIControlState.normal)
            
            button.setTitleColor(UIColor.white, for: UIControlState.normal)
            button.setTitleColor(UIColor.white, for: UIControlState.selected)
            
            button.sizeToFit()
            self.contentView.addSubview(button)
            self.itemBtns.append(button)
        }
        self.layoutIfNeeded()
        
    }
    //选择的索引
    func setSelectIndex() {
        if self.items.count<=0 || selectIndex>self.items.count-1 {
            return
        }
        let btn = self.itemBtns[selectIndex]
        self.btnClick(btn: btn)
    }
    
    
    //按钮点击
    func btnClick(btn:UIButton) {
        //代理方法
        self.deleagte?.segmentBarTarget!(selectedIndex: Int(btn.tag))
        
        self.selectIndex = btn.tag
        
        UIView.animate(withDuration: 0.15) { 
            self.lastBtn.titleLabel?.font = __FONT(x: 14)
            self.lastBtn.isSelected = false
            btn.titleLabel?.font = __FONT(x: 14)
            btn.isSelected = true
            
            self.lastBtn = btn
            
            self.layoutIfNeeded()
        }
        
        UIView.animate(withDuration: 0.15) { 
            self.indicatorView.ND_Width = btn.width-40
            self.indicatorView.ND_CenterX = btn.ND_CenterX
        }
        //1.先滚动到btn的位置
        var scrollX = btn.ND_CenterX - self.contentView.ND_Width * 0.5
        if scrollX < 0 { //这个代表点击了视图中心左边的按钮,所以不需要移动
            scrollX = 0.0
        }
        //这里代表点击视图中心右边的按钮
        // > 表示按钮的所有宽度加起来已经超过了视图的宽度
        if scrollX > self.contentView.contentSize.width - self.contentView.ND_Width {
            scrollX = self.contentView.contentSize.width - self.contentView.ND_Width
        }
        UIView.animate(withDuration: 0.15) { 
            self.contentView.setContentOffset(CGPoint.init(x: scrollX, y: 0.0), animated: true)
        }
    }
    
    //刷新布局
    override func layoutSubviews() {
        self.contentView.frame = self.bounds
        
        if (self.itemBtns.count == 0) {
            return;
        }
        
        //计算button
        let totalBtnWidth:CGFloat = 20.0
        
        var lastX:CGFloat = 0.0
        
        for button in self.itemBtns {
            button.sizeToFit()
            
            button.ND_Y = 0
            button.ND_X = lastX//totalBtnWidth + lastX
            button.ND_Width = CGFloat(self.itemBtns.count)*(button.ND_Width + totalBtnWidth)>self.ND_Width ? (button.ND_Width + totalBtnWidth) : self.ND_Width/4;
            
            lastX = button.frame.maxX
            
        }
        
        self.contentView.contentSize = CGSize.init(width: lastX, height: 0)
        
        let button = self.itemBtns[self.selectIndex]
        self.indicatorView.ND_Width = button.ND_Width - totalBtnWidth*2
        self.indicatorView.ND_CenterX = button.ND_CenterX
        self.indicatorView.ND_Height = indicatorH
        self.indicatorView.ND_Y = self.ND_Height - self.indicatorView.ND_Height - 2
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
