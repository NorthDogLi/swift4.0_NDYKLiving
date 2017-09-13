//
//  NDCollectionView.swift
//  swift3_瀑布流
//
//  Created by 李家奇_南湖国旅 on 2017/6/29.
//  Copyright © 2017年 李家奇_南湖国旅. All rights reserved.
//

import UIKit

class NDCollectionView: UICollectionViewFlowLayout {
    
    /** 默认列数 */
    private(set) var ColumnCountDefault : Int = 2
    /** 每一列之间的间距  */
    private(set) var ColumnMargin : CGFloat = 2
    /** 每一行之间的间距  */
    private(set) var ItemMargin : CGFloat = 0
    /** 边缘间距 */
    private(set) var EdgeInsetsDefault : UIEdgeInsets = UIEdgeInsetsMake(0, 0, 10, 0)
    
    //懒加载
    //存放所有cell的布局属性
    lazy var attrsArray = [UICollectionViewLayoutAttributes]()
    //存放所有列的当前高度
    lazy var columnHeightsAry = [CGFloat]()
    
    
    //第一步 ：初始化
    override func prepare() {
        super.prepare()
        //清除高度
        columnHeightsAry.removeAll()
        
        for _ in 0 ..< ColumnCountDefault {
            columnHeightsAry.append(EdgeInsetsDefault.top)
        }
        
        //清除所有的布局属性
        attrsArray.removeAll()
        
        let sections : Int = (self.collectionView?.numberOfSections)!
        
        for num in 0 ..< sections {
            let count : Int = (self.collectionView?.numberOfItems(inSection: num))!//获取分区0有多少个item
            for i in 0 ..< count {
                let indexpath : NSIndexPath = NSIndexPath.init(item: i, section: num)
                let attrs = self.layoutAttributesForItem(at: indexpath as IndexPath)!
                
                attrsArray.append(attrs)
            }
        }
    }
    
    /**
     * 第二步 ：返回indexPath位置cell对应的布局属性
     */
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        
        let attrs = UICollectionViewLayoutAttributes.init(forCellWith: indexPath)
        let collectionWidth = self.collectionView?.frame.size.width
        
        //获得所有item的宽度
        let __W = (collectionWidth! - EdgeInsetsDefault.left - EdgeInsetsDefault.right - CGFloat(ColumnCountDefault-1) * ColumnMargin) / CGFloat(ColumnCountDefault)
        
        let __H = arc4random_uniform(100) + 250
        //print("collection-----\(__H)")
        
        //找出高度最短那一列
        var dextColum : Int = 0
        var mainH = columnHeightsAry[0]
        
        for i in 1 ..< ColumnCountDefault{
            //取出第i列的高度
            let columnH = columnHeightsAry[i]
            
            if mainH > columnH {
                mainH = columnH
                dextColum = i
            }
        }
        
        
        let x = EdgeInsetsDefault.left + CGFloat(dextColum) * (__W + ColumnMargin)
        var y = mainH
        
        if y != EdgeInsetsDefault.top{
            y = y + ItemMargin
        }
        attrs.frame = CGRect(x: x, y: y, width: __W, height: CGFloat(__H))
        //更新最短那列高度
        columnHeightsAry[dextColum] = attrs.frame.maxY
        //print("frame\(attrs.frame)")
        return attrs
    }
    
    //第三步 ：重写  返回所有列的高度
    override var collectionViewContentSize: CGSize {
        
        var maxHeight = columnHeightsAry[0]
        
        for i in 1 ..< ColumnCountDefault {
            let columnHeight = columnHeightsAry[i]
            
            if maxHeight < columnHeight {
                maxHeight = columnHeight
            }
        }
        
        return CGSize.init(width: 0, height: maxHeight + EdgeInsetsDefault.bottom)
    }
    
    //第四步 ：返回collection的item的frame
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        return attrsArray
    }
}
