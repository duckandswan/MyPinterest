//
//  MonthViewCollectionViewLayout.swift
//  finding
//
//  Created by admin on 15/10/23.
//  Copyright © 2015年 zhangli. All rights reserved.
//

import UIKit

//class MonthViewCollectionViewLayout: UICollectionViewFlowLayout {
//
//    override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
//        return true
//    }
//    
//    override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
//        let collection = self.collectionView
//        let insets = collection?.contentInset
//        let offet = collection?.contentOffset
//        let minY = -insets!.top
//        let attributes = super.layoutAttributesForElementsInRect(rect)
//        if offet!.y < minY || offet!.y > minY {
//            let deltaY = offet!.y - minY
//            for var attrs in attributes! {
//                if attrs.representedElementKind == UICollectionElementKindSectionHeader {
//                    attrs.frame.origin.y =  attrs.frame.origin.y + deltaY
//                    break;
//                }
//            }
//        }
//        return attributes
//    }
//    
//}
