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
    var noDataLabel:UILabel!
    
    enum Status{
        case idle, headRefreshing, footerLoading
    }
    
    var status:Status = .idle
    
    func set(sta:Status){
        status = sta
        switch sta {
        case .idle:
            self.contentOffset.y = 0
            self.contentInset.top = 0
            myHeaderRefresh.stopAnimating()
            myFooterLoad.stopAnimating()
        case .headRefreshing:
            self.contentOffset.y = -50
            self.contentInset.top = 50
            myHeaderRefresh.startAnimating()
        case .footerLoading:
            myFooterLoad.startAnimating()
        }
    }
    
    var isNoData = false{
        didSet {
            myFooterLoad.isHidden = isNoData
            noDataLabel.isHidden = !isNoData
        }
    }
    
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
        
        noDataLabel = UILabel(frame: CGRect(x: 0, y: 0, width: frame.width, height: 50))
        noDataLabel.font = UIFont.systemFont(ofSize: 12)
        noDataLabel.textAlignment = .center
        noDataLabel.text = "没有了"
        noDataLabel.textColor = UIColor.black
        
        addObserver(self, forKeyPath: #keyPath(UICollectionView.contentOffset), options: NSKeyValueObservingOptions.new, context: nil)
        addObserver(self, forKeyPath: #keyPath(UICollectionView.contentSize), options: NSKeyValueObservingOptions.new, context: nil)
    }
    
    deinit {
        removeObserver(self, forKeyPath: #keyPath(UICollectionView.contentOffset))
        removeObserver(self, forKeyPath: #keyPath(UICollectionView.contentSize))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    weak var headerObj:AnyObject?
    var headerAction:Selector?
    
    var hasHeader:Bool = false
    var hasFooter:Bool = false
    //MARK: -下拉刷新
    func addMyHeaderRefresh(obj:AnyObject, action:Selector) {
        headerObj = obj
        headerAction = action
        addSubview(myHeaderRefresh)
        hasHeader = true
//        addObserver(self, forKeyPath: #keyPath(UICollectionView.contentOffset), options: NSKeyValueObservingOptions.new, context: nil)
//         addObserver(self, forKeyPath: #keyPath(UICollectionView.isDecelerating), options: [.new,.old,.initial,.prior], context: nil)
    }
    
    weak var footerObj:AnyObject?
    var footerAction:Selector?
    
    func adjustFooterY(){
        myFooterLoad.frame.origin.y = contentSize.height > frame.height ? contentSize.height : frame.height
        noDataLabel.frame.origin.y = contentSize.height > frame.height ? contentSize.height : frame.height
    }
    //MARK: -上拉加载更多
    func addMyFooterLoad(obj:AnyObject, action:Selector) {
        footerObj = obj
        footerAction = action
        adjustFooterY()
        self.contentInset.bottom = 50
        addSubview(myFooterLoad)
        addSubview(noDataLabel)
        noDataLabel.isHidden = true
        hasFooter = true
//        addObserver(self, forKeyPath: #keyPath(UICollectionView.contentOffset), options: NSKeyValueObservingOptions.new, context: nil)
    }
    
    func beginMyRefresh(){
        if status == .headRefreshing || status == .footerLoading {
            return
        }
        status = .headRefreshing
        isNoData = false
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
            UIView.animate(withDuration: 0.5, animations: {
                self.contentOffset.y = 0
                self.contentInset.top = 0
            }, completion: { (b) in
                self.status = .idle
                self.myHeaderRefresh.stopAnimating()
            })
        }else if status == .footerLoading {
            self.status = .idle
            self.myFooterLoad.stopAnimating()
        }
    }
    
    func beginMyFooterLoad(){
        if !(status == .idle && isNoData == false) {
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
                    if contentOffset.y < -75{
                        if hasHeader == true {
                            beginMyRefresh()
                        }
                    }else if contentOffset.y > contentSize.height - frame.height + 50 && contentOffset.y > 50{
                        print("beginMyFooterLoad at :\(contentOffset.y)")
                        if isNoData == false && hasFooter == true{
                            beginMyFooterLoad()
                        }
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
