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
        myRefreshControl = UIActivityIndicatorView(frame: CGRect(x: 0, y: -50, width: 50, height: 50))
        myRefreshControl.center.x = frame.width / 2
        myRefreshControl.activityIndicatorViewStyle = .gray
        myRefreshControl.hidesWhenStopped = false
        
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
        addObserver(self, forKeyPath: #keyPath(UICollectionView.contentOffset), options: NSKeyValueObservingOptions.new, context: nil)
//         addObserver(self, forKeyPath: #keyPath(UICollectionView.isDecelerating), options: [.new,.old,.initial,.prior], context: nil)
    }
    
    func beginMyRefresh(){
        if refreshStatus == .headRefreshing {
            return
        }
        refreshStatus = .headRefreshing
        myRefreshControl.startAnimating()
        UIView.animate(withDuration: 0.5, animations: {
            self.contentOffset.y = -50
            self.contentInset.top = 50
        }, completion: { (b) in
            _ = self.headerObj?.perform(self.headerAction, with: self.myRefreshControl)
        })
    }
    
    func endMyRefresh(){
        if refreshStatus == .headRefreshing {
            self.refreshStatus = .idle
            UIView.animate(withDuration: 0.5, animations: {
                self.contentOffset.y = 0
                self.contentInset.top = 0
            }, completion: { (b) in
                //            self.myRefreshControl.stopAnimating()
            })
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        print("keyPath: \(keyPath): \(change?[.newKey])")
        let contentOffset = change?[.newKey] as! CGPoint
        if contentOffset.y < -50 && isDragging == false {
            beginMyRefresh()
        }
//        if change?[.newKey] as! Bool == false {
//            if contentOffset.y < -50 {
//                beginMyRefresh()
//            }
//        }
    }
    
}
