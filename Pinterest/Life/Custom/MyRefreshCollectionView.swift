//
//  MyRefreshCollectionView.swift
//  MyPinterest
//
//  Created by bob song on 16/12/12.
//  Copyright © 2016年 finding. All rights reserved.
//

import UIKit

class MyRefreshCollectionView: UICollectionView {
    
    var myRefreshControl:UIActivityIndicatorView!
    
    enum RefreshStatus{
        case idle, headRefreshing, footerRefreshing
    }
    var refreshStatus:RefreshStatus = .idle
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        myRefreshControl = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        myRefreshControl.center.x = frame.width / 2
        myRefreshControl.activityIndicatorViewStyle = .gray
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    weak var headerObj:AnyObject?
    var headerAction:Selector?
    
    //MARK: -下拉刷新，上拉加载更多
    func addMyHeaderRefresh(obj:AnyObject, action:Selector) {
        headerObj = obj
        headerAction = action
        addSubview(myRefreshControl)
    }
    
    func beginMyRefresh(){
        myRefreshControl.startAnimating()
        UIView.animate(withDuration: 1.0, animations: {
            self.contentOffset.y = -75
        }, completion: { (b) in
            UIView.animate(withDuration: 1.0, animations: {
                self.contentOffset.y = 0
            }, completion: { (b) in
                self.myRefreshControl.stopAnimating()
                _ = self.headerObj?.perform(self.headerAction, with: self.myRefreshControl)
            })
        })
    }
    
}
