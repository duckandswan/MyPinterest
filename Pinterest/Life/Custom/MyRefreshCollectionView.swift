//
//  MyRefreshCollectionView.swift
//  MyPinterest
//
//  Created by bob song on 16/12/12.
//  Copyright © 2016年 finding. All rights reserved.
//

import UIKit

class MyRefreshCollectionView: UICollectionView {
    
    var myHeaderRefresh:UIActivityIndicatorView!
    var myFooterLoad:UIActivityIndicatorView!
    
    enum Status{
        case idle, headRefreshing, footerLoading
    }
    var status:Status = .idle
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        myHeaderRefresh = UIActivityIndicatorView(frame: CGRect(x: 0, y: -50, width: 50, height: 50))
        myHeaderRefresh.center.x = frame.width / 2
        myHeaderRefresh.activityIndicatorViewStyle = .gray
        myHeaderRefresh.hidesWhenStopped = false
        
        myFooterLoad = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        myFooterLoad.center.x = frame.width / 2
        myFooterLoad.activityIndicatorViewStyle = .gray
        myFooterLoad.hidesWhenStopped = false
        
        addObserver(self, forKeyPath: #keyPath(UICollectionView.contentOffset), options: NSKeyValueObservingOptions.new, context: nil)
        addObserver(self, forKeyPath: #keyPath(UICollectionView.contentSize), options: NSKeyValueObservingOptions.new, context: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    weak var headerObj:AnyObject?
    var headerAction:Selector?
    
    //MARK: -下拉刷新
    func addMyHeaderRefresh(obj:AnyObject, action:Selector) {
        headerObj = obj
        headerAction = action
        addSubview(myHeaderRefresh)
//        addObserver(self, forKeyPath: #keyPath(UICollectionView.contentOffset), options: NSKeyValueObservingOptions.new, context: nil)
//         addObserver(self, forKeyPath: #keyPath(UICollectionView.isDecelerating), options: [.new,.old,.initial,.prior], context: nil)
    }
    
    weak var footerObj:AnyObject?
    var footerAction:Selector?
    
    func adjustFooterY(){
        myFooterLoad.frame.origin.y = contentSize.height > frame.height ? contentSize.height : frame.height
    }
    //MARK: -上拉加载更多
    func addMyFooterLoad(obj:AnyObject, action:Selector) {
        footerObj = obj
        footerAction = action
        adjustFooterY()
        addSubview(myFooterLoad)
//        addObserver(self, forKeyPath: #keyPath(UICollectionView.contentOffset), options: NSKeyValueObservingOptions.new, context: nil)
    }
    
    func beginMyRefresh(){
        if status == .headRefreshing || status == .footerLoading {
            return
        }
        status = .headRefreshing
        myHeaderRefresh.startAnimating()
        UIView.animate(withDuration: 0.5, animations: {
            self.contentOffset.y = -50
            self.contentInset.top = 50
        }, completion: { (b) in
            _ = self.headerObj?.perform(self.headerAction, with: self.myHeaderRefresh)
        })
    }
    
    func endMyRefresh(){
        if status == .headRefreshing {
            self.status = .idle
            UIView.animate(withDuration: 0.5, animations: {
                self.contentOffset.y = 0
                self.contentInset.top = 0
            }, completion: { (b) in
                self.myHeaderRefresh.stopAnimating()
            })
        }else if status == .footerLoading {
            self.status = .idle
//            self.myFooterLoad.stopAnimating()
        }
    }
    
    func beginMyFooterLoad(){
        if status == .headRefreshing || status == .footerLoading {
            return
        }
        status = .footerLoading
        adjustFooterY()
        myFooterLoad.startAnimating()
        _ = self.footerObj?.perform(self.footerAction, with: self.myFooterLoad)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
//        print("keyPath: \(keyPath): \(change?[.newKey])")
        if status == .idle {
            if keyPath == #keyPath(UICollectionView.contentOffset) {
//                let contentOffset = change?[.newKey] as! CGPoint
                if isDecelerating == true {
                    if contentOffset.y < -50{
                        beginMyRefresh()
                    }else if contentOffset.y > contentSize.height - frame.height + 50 && contentOffset.y > 50{
                        print("beginMyFooterLoad at :\(contentOffset.y)")
                        beginMyFooterLoad()
                    }
                }
            }
        }
        
        if keyPath == #keyPath(UICollectionView.contentSize) {
            //                let contentOffset = change?[.newKey] as! CGPoint
            adjustFooterY()
        }
        
//        if change?[.newKey] as! Bool == false {
//            if contentOffset.y < -50 {
//                beginMyRefresh()
//            }
//        }
    }
    
}
