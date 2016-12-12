//
//  MyRefreshCollectionView.swift
//  MyPinterest
//
//  Created by bob song on 16/12/12.
//  Copyright © 2016年 finding. All rights reserved.
//

import UIKit

class MyRefreshCollectionView: UICollectionView {
    
    var myRefreshControl = UIActivityIndicatorView(frame: CGRect(x: 0, y: -75, width: 50, height: 50))
    
    enum RefreshStatus{
        case idle, headRefreshing, footerRefreshing
    }
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: -下拉刷新，上拉加载更多
    func addMyHeaderRefresh(obj:AnyObject, action:Selector) {
        
        refreshControl?.addTarget(obj, action: action, for: UIControlEvents.valueChanged)
    }
    
}
