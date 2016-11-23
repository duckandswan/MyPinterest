//
//  WaterFlowViewLayout.swift
//  finding
//
//  Created by bob song on 16/3/7.
//  Copyright © 2016年 zhangli. All rights reserved.
//

import UIKit
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


protocol WaterFlowViewLayoutDelegate:NSObjectProtocol
{
    func waterFlowViewLayout(_ waterFlowViewLayout:WaterFlowViewLayout,heightForWidth:CGFloat,indextPath indexPath:IndexPath)->CGFloat
}

class WaterFlowViewLayout: UICollectionViewLayout {
    
    weak var delegate:WaterFlowViewLayoutDelegate?
    
    ///所有cell的布局属性
    var layoutAttributes = [UICollectionViewLayoutAttributes]()
    
    ///使用一个字典记录每列的最大Y值
    var maxYDict = [Int:CGFloat]()
    
    static var Margin:CGFloat = 8
    
    ///瀑布流四周的间距
    static var sectionInsert = UIEdgeInsets(top: Margin, left: Margin, bottom: Margin, right: Margin)
    //列间距
    static var columnMargin:CGFloat = Margin
    
    //行间距
    static var rowMargin:CGFloat = Margin
    
    ///瀑布流列数
    static var column = 2
    
    var maxY:CGFloat = 0
    
    var index = 0
    
    static var columnWidth:CGFloat = (UIScreen.main.bounds.width - sectionInsert.left - sectionInsert.right - (CGFloat(column) - 1)*columnMargin)/CGFloat(column)
    
    ///prepareLayout会在调用collectionView.reloadData()
    override func prepare() {
//        print("prepareLayout")
        //设置布局
        //需要清空字典里面的值
        for key in 0..<WaterFlowViewLayout.column
        {
            maxYDict[key] = 0
        }
        //清空之前的布局属性
        layoutAttributes.removeAll()
        //清空最大列的Y值
        maxY = 0
        
        topHeight = 0
        
//        ///清空列宽
//        columnWidth = 0
//        
//        //计算每列的宽度，需要在布局之前算好
//        columnWidth = (UIScreen.mainScreen().bounds.width - sectionInsert.left - sectionInsert.right - (CGFloat(column) - 1)*columnMargin)/CGFloat(column)
        
//        if collectionView?.numberOfItemsInSection(0) == 1{
//            let layoutAttr = layoutAttributesForItemAtIndexPath(NSIndexPath(forItem: 0, inSection: 0))!
//            layoutAttributes.append(layoutAttr)
//        }
        
        if let n = collectionView?.numberOfItems(inSection: 0){
            for i in 0..<n{
                let layoutAttr = layoutAttributesForItem(at: IndexPath(item: i, section: 0))!
                layoutAttributes.append(layoutAttr)
            }
        }

        
        let number = collectionView?.numberOfItems(inSection: 1) ?? 0
        
        for i in 0..<number
        {
            //布局每一个cell的frame
            let layoutAttr = layoutAttributesForItem(at: IndexPath(item: i, section: 1))!
            layoutAttributes.append(layoutAttr)
        }
        
        calcMaxY()
        
    }
    
    func calcMaxY(){
        //获取最大这一列的Y
        //默认第0列最长
        var maxYCoulumn = 0
        //for 循环比较，获取最长的这列
        for (key,value) in maxYDict
        {
            if value > maxYDict[maxYCoulumn]{
                //key这列的Y值是最大的
                maxYCoulumn = key
            }
        }
        //获取到Y值最大的这一列
        maxY = maxYDict[maxYCoulumn]! + WaterFlowViewLayout.sectionInsert.bottom
        
    }
    
    //返回collectionViewContentSize 大小
    override  var collectionViewContentSize : CGSize {
//        print("collectionViewContentSize")
        return CGSize(width: UIScreen.main.bounds.width, height: maxY)
        
    }
    
    var topHeight:CGFloat = 0
    
    // 返回每一个cell的布局属性(layoutAttributes)
    //  UICollectionViewLayoutAttributes: 1.cell的frame 2.indexPath
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes?
    {
        //        print("layoutAttributesForItemAtIndexPath")
        assert(delegate != nil,"瀑布流必须实现代理来返回cell的高度")
        
        if indexPath.section == 0 {
//            let firstHeight = delegate!.waterFlowViewLayout(self, heightForWidth: WaterFlowViewLayout.columnWidth, indextPath: indexPath)
//            let layoutAttr = UICollectionViewLayoutAttributes(forCellWithIndexPath: indexPath)
//            layoutAttr.frame = CGRect(x: 0, y: 0, width: UIScreen.mainScreen().bounds.width, height: firstHeight)
            
            let  incrementH = delegate!.waterFlowViewLayout(self, heightForWidth: WaterFlowViewLayout.columnWidth, indextPath: indexPath)
            let layoutAttr = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            layoutAttr.frame = CGRect(x: 0, y: topHeight, width: UIScreen.main.bounds.width, height: incrementH)
            topHeight += incrementH
            
            for key in 0..<WaterFlowViewLayout.column
            {
                maxYDict[key] = topHeight + 5
            }
            
            return layoutAttr
        }
        
        let height = delegate!.waterFlowViewLayout(self, heightForWidth: WaterFlowViewLayout.columnWidth, indextPath: indexPath)
        // 找到最短的那一列,去maxYDict字典中找
        
        // 最短的这一列
        var minYColumn = 0
        
        //通过for循环去和其他列比较
        for(key, value) in maxYDict {
            
            if value < maxYDict[minYColumn]
            {
                minYColumn = key
                
            }
        }
        
        // minYColumn 就是短的那一列
        let x = WaterFlowViewLayout.sectionInsert.left + CGFloat(minYColumn) * (WaterFlowViewLayout.columnWidth + WaterFlowViewLayout.columnMargin)
        //最短这列的Y值 + 行间距
        let y = maxYDict[minYColumn]! + WaterFlowViewLayout.rowMargin
        //设置cell的frame
        let frame = CGRect(x: x, y: y, width: WaterFlowViewLayout.columnWidth, height: height)
        //更新最短这列的最大Y值
        maxYDict[minYColumn] = frame.maxY
        //创建每个cell对应的布局属性
        let layoutAttr = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        layoutAttr.frame = frame
        return layoutAttr
    }
    
    var number = 0
    //预加载下一页数据
    override func layoutAttributesForElements(in rect:CGRect) -> [UICollectionViewLayoutAttributes]{
//        print("layoutAttributesForElementsInRect: \(number++)")
//        print("super.layoutAttributesForElementsInRect(rect):\(super.layoutAttributesForElementsInRect(rect))")
        return layoutAttributes
    }
    
    
}
extension UIColor {
    
    //随机颜色
    class func randomColor() ->UIColor {
        return UIColor(red: randomValue(), green: randomValue(), blue: randomValue(), alpha: 1)
    }
    
    class  func randomValue()->CGFloat {
        return CGFloat(arc4random_uniform(256))/255
    }
    
}
